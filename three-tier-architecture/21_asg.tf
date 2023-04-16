##### APP LAYER ASG

resource "aws_security_group" "app_sg" {
  
  description = "Security group for the application layer"
  
  dynamic "ingress" {
    for_each = concat([
      {
        protocol    = "tcp"
        cidr_blocks = [aws_security_group.web_sg.id]
        from_port   = 443
        to_port     = 443
        description = "Allow HTTP traffic from web layer"
      },
      {
        protocol    = "tcp"
        cidr_blocks = [aws_security_group.web_sg.id]
        from_port   = 22
        to_port     = 22
        description = "Allow SSH traffic from web layer"
      }
    ], var.app_sg_rules)
  
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

resource "aws_launch_template" "app_launch_template"{
  name = "app-launch-template"
  cpu_options {
    core_count       = var.core_count
    threads_per_core = var.threads_per_core
  }
  disable_api_termination = true
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = "default"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = merge(
    local.tags,
    {"Name" = "APP-launch-template"}
  )
  user_data = filebase64("${path.module}/scripts/login_website.sh")
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app_asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.asg_desired_cap
  force_delete              = true
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [for idx, subnet in aws_subnet.private_subnet : idx < 2 ? subnet.id : ""]

  tag {
    key = "name"
    value = "web-asg"
    propagate_at_launch = true
  }

  tag {
    key = "environement"
    value = var.vpc_tags_environment
    propagate_at_launch = true
  }
}