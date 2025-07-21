provider "vault" {
      address = "https://127.0.0.1:8200"
      token = ""
      skip_tls_verify  = true
}

data "vault_generic_secret" "aws_credentials" {
      path = "my-secrets/aws"
}


provider "aws" {
      region     = "ap-south-1"
      access_key = data.vault_generic_secret.aws_credentials.data["aws_access_key_id"]
      secret_key = data.vault_generic_secret.aws_credentials.data["aws_secret_access_key"]
}

module "vpc" {
      source = "terraform-aws-modules/vpc/aws"

      name = var.vpc_name
      cidr = var.vpc_cidr

      azs  = var.azs
      
      private_subnet_names = var.private_subnet_names
      private_subnets = var.private_subnets
      private_subnet_tags = var.public_subnet_tags      

      public_subnet_names = var.public_subnet_names
      public_subnets  = var.public_subnets
      public_subnet_tags = var.private_subnet_tags
      
      create_igw = true
      enable_nat_gateway = true
      single_nat_gateway = true

      public_route_table_tags = {
        Name = "public-route-table"
      }

      private_route_table_tags = {
        Name = "private-route-table"
      }

      tags = {
        Terraform = "true"
        Environment = "staging"
      }
}

resource "tls_private_key" "ec2_key" {
      algorithm = "RSA"
      rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
      key_name   = "bytes" 
      public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_security_group" "ec2_sg" {
     name        = "ec2-sg"
     description = "Allow SSH and HTTP"
     vpc_id      = module.vpc.vpc_id

     ingress {
       description = "Allow SSH"
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
      }

     ingress {
       description = "Allow HTTP"
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
      }

     egress {
       description = "Allow all outbound"
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
      }

     tags = {
       Name        = "ec2-sg"
       Environment = var.env
  }
}

module "ec2_instance" {
      source  = "terraform-aws-modules/ec2-instance/aws"

      name = var.ec2name
      ami  = var.ami
      instance_type = var.instance_type
      key_name      = aws_key_pair.ec2_key_pair.key_name
      subnet_id     = module.vpc.public_subnets[0]
      vpc_security_group_ids = [aws_security_group.ec2_sg.id]
      associate_public_ip_address = true
      ebs_volumes = {
       vol = {
        device_name = "/dev/sdh"
        volume_type = "gp2"
        size = 10
        delete_on_termination = true
       }
  }
      user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              systemctl start nginx
              EOF
      tags = {
        Name        = var.ec2name
        Environment = var.env
       }

}


resource "aws_security_group" "db_sg" {
       name        = "rds-db-sg"
       description = "Allow PostgreSQL access"
       vpc_id      = module.vpc.vpc_id  

       ingress {
           description = "PostgreSQL from EC2 or other allowed sources"
           from_port   = 5432
           to_port     = 5432
           protocol    = "tcp"
           cidr_blocks = ["10.0.0.0/16"] 
        } 

       egress {
           from_port   = 0
           to_port     = 0
           protocol    = "-1"
           cidr_blocks = ["0.0.0.0/0"]
       }

       tags = {
           Name        = "rds-db-sg"
           Environment = var.env
       }
}


resource "aws_security_group" "elb_sg" {
       name        = "elb-sg"
       description = "Allow internet access"
       vpc_id      = module.vpc.vpc_id

       ingress {
           description = "Allow traffic"
           from_port   = 80
           to_port     = 80
           protocol    = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
        }

       egress {
           from_port   = 0
           to_port     = 65535
           protocol    = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
       }

       tags = {
           Name        = "rds-db-sg"
           Environment = var.env
       }

}


module "db" {
       source = "terraform-aws-modules/rds/aws"
       engine                          = "postgres"
       family                          = "postgres15"
       major_engine_version            = "15"
       engine_version                  = var.engine_version
       identifier                      = var.db_identifier
       username                        = var.db_master_username
       manage_master_user_password     = true
       instance_class                  = var.instance_class
       storage_type                    = var.storage_type
       allocated_storage               = var.allocated_storage
       max_allocated_storage           = var.max_allocated_storage
       network_type                    = var.network_type
       multi_az                        = false
       create_db_subnet_group          = true
       subnet_ids                      = module.vpc.private_subnets
       publicly_accessible             = var.publicly_accessible
       vpc_security_group_ids          = [aws_security_group.db_sg.id]
       port                            = var.db_port
       db_name                         = var.db_name
       backup_retention_period         = var.backup_retention_period
       backup_window                   = var.backup_window
       copy_tags_to_snapshot           = true
       auto_minor_version_upgrade      = var.auto_minor_version_upgrade
       maintenance_window              = var.maintenance_window
       performance_insights_enabled    = var.performance_insights_enabled
       performance_insights_retention_period = var.performance_insights_retention_period
       enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports

       tags = {
           Name  = var.db_name
           Environment = var.env
       }
}



module "alb" {
       source  = "terraform-aws-modules/alb/aws"
       name               = var.alb_name
       load_balancer_type = "application"
       internal           = false
       ip_address_type    = "ipv4"
       vpc_id  = module.vpc.vpc_id
       subnets = module.vpc.public_subnets
       security_groups = [aws_security_group.elb_sg.id]
       enable_deletion_protection = false
       target_groups = {
        "bytes" = {
          target_type      = "instance"
          name_prefix      = var.target_group_name_prefix
          protocol    = "HTTP"
          port        = "80"
          target_id   = module.ec2_instance.id
          vpc_id      = module.vpc.vpc_id
          protocol_version = "HTTP1"
        }
       }
       listeners = {
         http = {
          port = 80
          protocol = "HTTP"
          forward = {
           target_group_key = "bytes"
          }
         }
       }
       
}
