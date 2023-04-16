##### VPC VARS
variable "region" {
  type = string
  default = "eu-west-1"
}
variable "netmask_length" {
  type        = number
  description = "Netmask length for CIDR allocations."
  default = 16
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Additional tags aded to resources."
  default     = {}
}

variable "vpc_tags_environment" {
  description = "Environment [dev, uat, prod, sandbox, sharedservices] to associate with the VPC (Used in VPC name and tags)."
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod", "sandbox", "nonprod", "sharedservices"], lower(var.vpc_tags_environment))
    error_message = "Must be dev, uat, prod, sandbox, nonprod, or sharedservices."
  }
  default = "uat"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create."
  type        = number   
  default = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create."
  type        = number   
  default = 4
}

variable "workload_subnet_newbits" {
  description = "(Optional) Newbits for workload subnets (See Terraform cidrsubnet function) (default = null)"
  type        = number
  default     = 8
}


##### ASG VARS
variable "web_sg_rules" {
  description = "List of additional security group rules for the web layer"
  type        = list(object({
    protocol    = string
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    description = string
  }))

  default = []
}

variable "app_sg_rules" {
  description = "List of additional security group rules for the application layer"
  type        = list(object({
    protocol    = string
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    description = string
  }))
  default = []
}

variable "db_sg_rules" {
  description = "List of additional security group rules for the database layer"
  type        = list(object({
    protocol    = string
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    description = string
  }))
  default = []
}

variable "core_count" {
  type = number
  description = "cores required for instances in autoscaling groups"
  default = 4
}

variable "threads_per_core" {
  type = number
  description = "threads per core required for instances in autoscaling groups"
  default = 2
}

variable "ami_id" {
  type = string
  description = "AMI ID with which we need to launch instances in autoscaling group"
  default = "ami-07da0250e5552b1e4"
}

variable "instance_type" {
  type = string
  description = "instance type for ec2 instances to be launched in ASG"
  default = "t3.xlarge"
}

variable "asg_max_size" {
  type = number
  description = "Max Size required for autoscaling group"
  default = 2
}

variable "asg_min_size" {
  type = number
  description = "Min Size required for autoscaling group"
  default = 1
}

variable "asg_desired_cap" {
  type = number
  description = "desired capacity required for autoscaling group"
  default = 1
}

##### RDS VARS
variable "db_engine" {
  type = string
  description = "name of db engine to be used for rds instances"
  default = "mysql"
  #supported values - https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
}

variable "db_engine_version" {
  type = string
  description = "db engine version to be used for rds instances"
  default = "8.0"
  #supported values -https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
}

variable "instance_class" {
  type = string
  description = "instance type of RDS instance"
  default = "i3.large"
}

variable "allocated_storage" {
  type = number
  default = 200
  description = "The allocated storage in gibibytes."  
}

variable "max_allocated_storage" {
  type = number
  default = 200
  description = "upper limit to which Amazon RDS can automatically scale the storage of the DB instance"  
}

variable "backup_retention_days" {
  type = number
  description = "The days to retain backups for."
  default = 7
}

variable "backup_window" {
  type = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled"
  default = "05:00-06:00"
}

variable "db_name" {
  type = string
  description = "he name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance. "
  default = "mysqlserver"
}