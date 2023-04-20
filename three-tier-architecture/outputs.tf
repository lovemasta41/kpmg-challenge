output "primary_rds_endpoint" {
  value = aws_db_instance.primary_instance.endpoint
  description = "Primary RDS endpoint for connectivity."
}

output "web_ec2_ips" {

    value = [for instance in aws_autoscaling_group.web_asg.instances : aws_instance.instance.private_ip ]
    description = "web layer instances private ip addresses"
}

output "app_ec2_ips" {

    value = [for instance in aws_autoscaling_group.ap_asg.instances : aws_instance.instance.private_ip ]
    description = "app layer instances private ip addresses"
}