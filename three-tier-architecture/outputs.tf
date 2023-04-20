output "primary_rds_endpoint" {
  value = aws_db_instance.primary_instance.endpoint
}

output "web_ec2_ips" {

    value = [for instance in aws_autoscaling_group.web_asg.instances : aws_instance.instance.private_ip ]
  
}

output "app_ec2_ips" {

    value = [for instance in aws_autoscaling_group.ap_asg.instances : aws_instance.instance.private_ip ]
  
}