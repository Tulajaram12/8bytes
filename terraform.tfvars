##VPC
vpc_name = "bytes-VPC"
vpc_cidr = "10.0.0.0/16"

azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

private_subnet_names = ["private-subnet-1", "private-subnet-2", "private-subnet-3"]
private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_tags  = {
  Name        = "PrivateSubnet"
  Environment = "staging"
}

public_subnet_names = ["public-subnet-1", "public-subnet-2", "public-subnet-3"]
public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
public_subnet_tags  = {
  Name        = "PublicSubnet"
  Environment = "staging"
}



##EC2-INSTANCE
ec2name             = "web-server"
ami                 = "ami-0f918f7e67a3323f0" 
instance_type       = "t2.micro"
security_group_name = "web-sg"
env                 = "staging"



##RDS
engine_version                      = "15.7"
db_identifier                       = "bytespostgresqldb"
db_master_username                  = "bytes_Master_User"
#instance_class                      = "db.t3.micro"
instance_class                      = "db.c6gd.medium"
storage_type                        = "gp2"
allocated_storage                   = 20
max_allocated_storage               = 100
network_type                        = "IPV4"
publicly_accessible                 = false
db_port                             = 5432
db_name                             = "bytes_db"
backup_retention_period             = 7
backup_window                       = "09:00-09:30"
auto_minor_version_upgrade          = true
maintenance_window                  = "Mon:00:00-Mon:02:00"
performance_insights_enabled        = true
performance_insights_retention_period = 7
enabled_cloudwatch_logs_exports     = ["postgresql", "upgrade", "iam-db-auth-error"]


##ALB
alb_name                = "bytes-alb"
target_group_name_prefix = "bytes"

