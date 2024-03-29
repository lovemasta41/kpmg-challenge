## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >3.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.app_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.web_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.app_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.web_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_db_instance.primary_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.read_replica_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.primary_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_db_subnet_group.replica_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.web_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.new_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.app_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.web_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.app_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.web_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.app_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.web_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.target_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.web_target_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.app_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.web_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.web_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.app_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.db_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.web_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.app_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.web_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.app_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.new_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.db_master_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_vpc_ipam_pool.ipam_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gibibytes. | `number` | `200` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID with which we need to launch instances in autoscaling group | `string` | `"ami-07da0250e5552b1e4"` | no |
| <a name="input_app_sg_rules"></a> [app\_sg\_rules](#input\_app\_sg\_rules) | List of additional security group rules for the application layer | <pre>list(object({<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    from_port   = number<br>    to_port     = number<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_asg_desired_cap"></a> [asg\_desired\_cap](#input\_asg\_desired\_cap) | desired capacity required for autoscaling group | `number` | `1` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Max Size required for autoscaling group | `number` | `2` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Min Size required for autoscaling group | `number` | `1` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The days to retain backups for. | `number` | `7` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled | `string` | `"05:00-06:00"` | no |
| <a name="input_core_count"></a> [core\_count](#input\_core\_count) | cores required for instances in autoscaling groups | `number` | `4` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | name of db engine to be used for rds instances | `string` | `"mysql"` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | db engine version to be used for rds instances | `string` | `"8.0"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | he name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance. | `string` | `"mysqlserver"` | no |
| <a name="input_db_sg_rules"></a> [db\_sg\_rules](#input\_db\_sg\_rules) | List of additional security group rules for the database layer | <pre>list(object({<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    from_port   = number<br>    to_port     = number<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | instance type of RDS instance | `string` | `"i3.large"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | instance type for ec2 instances to be launched in ASG | `string` | `"t3.xlarge"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | upper limit to which Amazon RDS can automatically scale the storage of the DB instance | `number` | `200` | no |
| <a name="input_netmask_length"></a> [netmask\_length](#input\_netmask\_length) | Netmask length for CIDR allocations. | `number` | `16` | no |
| <a name="input_private_subnet_count"></a> [private\_subnet\_count](#input\_private\_subnet\_count) | Number of private subnets to create. | `number` | `4` | no |
| <a name="input_public_subnet_count"></a> [public\_subnet\_count](#input\_public\_subnet\_count) | Number of public subnets to create. | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | #### VPC VARS | `string` | `"eu-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Additional tags aded to resources. | `map(string)` | `{}` | no |
| <a name="input_threads_per_core"></a> [threads\_per\_core](#input\_threads\_per\_core) | threads per core required for instances in autoscaling groups | `number` | `2` | no |
| <a name="input_vpc_tags_environment"></a> [vpc\_tags\_environment](#input\_vpc\_tags\_environment) | Environment [dev, uat, prod, sandbox, sharedservices] to associate with the VPC (Used in VPC name and tags). | `string` | `"uat"` | no |
| <a name="input_web_sg_rules"></a> [web\_sg\_rules](#input\_web\_sg\_rules) | List of additional security group rules for the web layer | <pre>list(object({<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    from_port   = number<br>    to_port     = number<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_workload_subnet_newbits"></a> [workload\_subnet\_newbits](#input\_workload\_subnet\_newbits) | (Optional) Newbits for workload subnets (See Terraform cidrsubnet function) (default = null) | `number` | `8` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_ec2_ips"></a> [app\_ec2\_ips](#output\_app\_ec2\_ips) | app layer instances private ip addresses |
| <a name="output_primary_rds_endpoint"></a> [primary\_rds\_endpoint](#output\_primary\_rds\_endpoint) | Primary RDS endpoint for connectivity. |
| <a name="output_web_ec2_ips"></a> [web\_ec2\_ips](#output\_web\_ec2\_ips) | web layer instances private ip addresses |
