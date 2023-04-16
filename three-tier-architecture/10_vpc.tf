##### VPC
resource "aws_vpc" "new_vpc" {

  ipv4_ipam_pool_id   = local.ipam_pool #ipam pool id for allocating ip addresses in controlled manner
  ipv4_netmask_length = var.netmask_length

  tags = merge(
    local.tags,
    tomap({ "Name" = local.vpc_name })
  )
}

##### PUBLIC SUBNETS
resource "aws_subnet" "public_subnet" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.new_vpc.cidr_block, var.workload_subnet_newbits, count.index)
  availability_zone = local.workload_az_names[count.index]
  tags = merge(
    local.tags,
    tomap({
      "Name"         = "${local.vpc_name}-public-${local.workload_az_names[count.index]}"
    })
  )
}

##### PRIVATE SUBNETS
resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.new_vpc.cidr_block, var.workload_subnet_newbits, count.index)
  availability_zone = local.workload_az_names[count.index % 2]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc_name}-private-${count.index+1}-${local.workload_az_names[count.index % 2]}"
    })
  )
}

##### INTERNET GATEWAY
resource "aws_internet_gateway" "new_igw" {
  vpc_id = aws_vpc.new_vpc.id
  tags = merge(
    local.tags,tomap({
     "Name" = format("%s-igw",local.vpc_name) 
     })
  )  
}

##### NAT Gateway Between Web And App Layer
resource "aws_eip" "web_eip" {
  vpc = true
}

resource "aws_nat_gateway" "web_nat_gateway" {
  allocation_id = aws_eip.web_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}


##### Web Layer Route Table
resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.new_vpc.id
}

# resource "aws_route" "web_local_route_1" {
#   route_table_id         = aws_route_table.web_route_table.id
#   destination_cidr_block = aws_subnet.public_subnet[0].cidr_block
#   network_interface_id = aws_autoscaling_group.web_asg.id
# }

# resource "aws_route" "web_local_route_2" {
#   route_table_id         = aws_route_table.web_route_table.id
#   destination_cidr_block = aws_subnet.public_subnet[1].cidr_block
#   network_interface_id = aws_autoscaling_group.web_asg.id
# }

# resource "aws_route" "web_route" {
#   route_table_id = aws_route_table.web_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.new_igw.id #web lb
# }

# resource "aws_route" "app_lb_route" {
#   route_table_id         = aws_route_table.web_route_table.id
#   destination_cidr_block = aws_subnet.private_subnet[0].cidr_block
#   nat_gateway_id         = "" #app LB
# }

# resource "aws_route" "app_lb_route" {
#   route_table_id         = aws_route_table.web_route_table.id
#   destination_cidr_block = aws_subnet.private_subnet[1].cidr_block
#   nat_gateway_id         = "" #app lb
# }

resource "aws_route_table_association" "web_subnet_association" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.web_route_table.id
}

# ##### APP Layer Route Table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.new_vpc.id
}

# resource "aws_route" "app_local_route_1" {
#   route_table_id         = aws_route_table.app_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[0].cidr_block
#   network_interface_id = aws_autoscaling_group.app_asg.id
# }

# resource "aws_route" "app_local_route_2" {
#   route_table_id         = aws_route_table.app_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[1].cidr_block
#   network_interface_id = aws_autoscaling_group.app_asg.id
# }

# resource "aws_route" "elb_route" {
#   route_table_id = aws_route_table.app_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   network_interface_id = aws_network_interface.elb_interface.id ## To be added
# }

# resource "aws_route" "app_db_route_1" {
  
#   route_table_id         = aws_route_table.app_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[2].cidr_block
#   network_network_interface_id = "" #primary db instance id
# }

# resource "aws_route" "app_db_route_2" {
  
#   route_table_id         = aws_route_table.app_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[3].cidr_block
#   network_network_interface_id = "" #primary db instance id
# }

resource "aws_route_table_association" "app_subnet_association" {
  count = length(aws_subnet.private_subnet)/2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.app_route_table.id
}


# #### Database Layer Route Table
resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.new_vpc.id
}

# resource "aws_route" "db_local_route_1" {
#   route_table_id         = aws_route_table.db_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[2].cidr_block
#   networknetwork_interface_id = "" #id of primary db
# }

# resource "aws_route" "db_local_route_2" {
#   route_table_id         = aws_route_table.db_route_table.id
#   destination_cidr_block = aws_vpc.private_subnet[3].cidr_block
#   local_gateway_id       = "" #id of primary db
# }


# resource "aws_route" "db_app_route_1" {
  
#   route_table_id         = aws_route_table.db_route_table.id
#   destination_cidr_block = aws_subnet.private_subnet[0].cidr_block
#   network_interface_id = aws_autoscaling_group.app_asg.id
# }

# resource "aws_route" "db_app_route_2" {
  
#   route_table_id         = aws_route_table.db_route_table.id
#   destination_cidr_block = aws_subnet.private_subnet[1].cidr_block
#   network_interface_id = aws_autoscaling_group.app_asg.id
# }

resource "aws_route_table_association" "db_subnet_association" {
  count = length(aws_subnet.private_subnet)/2
  subnet_id      = aws_subnet.private_subnet[count.index+2].id
  route_table_id = aws_route_table.db_route_table.id
}

