variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_names" {
  description = "Names for private subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
}

variable "public_subnet_names" {
  description = "Names for public subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
}


variable "ec2name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine"
}

variable "db_identifier" {
  type        = string
  description = "The unique identifier for the RDS DB instance"
}

variable "db_master_username" {
  type        = string
  description = "Master username for the database"
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS DB"
}

variable "storage_type" {
  type        = string
  description = "The type of storage to allocate"
}

variable "allocated_storage" {
  type        = number
  description = "The initial allocated storage size in GB"
}

variable "max_allocated_storage" {
  type        = number
  description = "The maximum storage that RDS can auto-scale up to (in GB)"
}

variable "network_type" {
  type        = string
  description = "The network type for the DB"
}


variable "publicly_accessible" {
  type        = bool
  description = "Whether the DB instance is publicly accessible"
}

variable "db_port" {
  type        = number
  description = "The port on which the DB accepts connections"
}

variable "db_name" {
  type        = string
  description = "The name of the initial database to create"
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days to retain backups for"
}

variable "backup_window" {
  type        = string
  description = "Preferred backup time window"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Whether to enable automatic minor version upgrades for the DB engine"
}

variable "maintenance_window" {
  type        = string
  description = "The preferred maintenance window for DB instance updates"
}


variable "performance_insights_enabled" {
  type        = bool
  description = "Whether to enable Performance Insights monitoring"
}

variable "performance_insights_retention_period" {
  type        = number
  description = "The number of days to retain Performance Insights data"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to CloudWatch Logs"
}


variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name_prefix" {
  description = "Prefix for the target group name"
  type        = string
}

