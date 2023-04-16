locals {

    vpc_name = lower(format("vpc-%s",var.vpc_tags_environment))
    ipam_pool = data.aws_vpc_ipam_pool.ipam_pool.id
    workload_az_names = data.aws_availability_zones.available.names
}

locals {
    
    mandatory_tags = {
        environment  = "${var.vpc_tags_environment}"
    }
    
    tags = merge(var.tags, local.mandatory_tags)

}