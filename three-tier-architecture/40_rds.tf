# ##### Database Layer
resource "aws_security_group" "db_sg" {
  name_prefix = "db-"
  description = "Security group for the database layer"
  
  dynamic "ingress" {
    for_each = concat([
      {
        protocol    = "tcp"
        cidr_blocks = [aws_security_group.app_sg.id]
        from_port   = 3306
        to_port     = 3306
        description = "Allow MSSQL traffic from app sg"
      }
    ], var.db_sg_rules)
  
    content {
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = [
      {
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        description = "Allow all outbound traffic"
      }
    ]

    content {
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      description = egress.value.description
    }
  }
}

resource "aws_db_subnet_group" "primary_group" {
  name        = "primary-subnet-group"
  subnet_ids = [ for idx,subnet in aws_subnet.private_subnet : idx == 3 ? subnet.id : ""]
}

resource "aws_db_subnet_group" "replica_group" {
  name        = "replica-subnet-group"
  subnet_ids = [ for idx,subnet in aws_subnet.private_subnet : idx == 4 ? subnet.id : ""]
}


resource "aws_db_instance" "primary_instance" {
  engine            = var.db_engine
  engine_version = var.db_engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  availability_zone = local.workload_az_names[0]
  backup_retention_period = var.backup_retention_days #must be greater than 0 if instance is used as a source for read replica
  backup_window = var.backup_window
  db_name = var.db_name
  db_subnet_group_name = aws_db_subnet_group.primary_group.name
  username          = data.aws_ssm_parameter.db_master_credentials.value
  password          = data.aws_ssm_parameter.db_master_credentials.value
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_instance" "read_replica_instance" {
  engine            = var.db_engine
  engine_version = var.db_engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  availability_zone = local.workload_az_names[1]
  backup_retention_period = var.backup_retention_days #must be greater than 0 if instance is used as a source for read replica
  backup_window = var.backup_window
  db_name = var.db_name
  replicate_source_db = aws_db_instance.primary_instance.id
  db_subnet_group_name = aws_db_subnet_group.replica_group.name
  username          = data.aws_ssm_parameter.db_master_credentials.value
  password          = data.aws_ssm_parameter.db_master_credentials.value
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}