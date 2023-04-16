data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc_ipam_pool" "ipam_pool" {

  filter {
    name   = "address-family" #fetches ipam pool available in current region using service vpc IPAM
    values = ["ipv4"]
  }
  
   filter {
    name = "locale"
    values = [data.aws_region.current.name]
  }
}

data "aws_ssm_parameter" "db_master_credentials" {
  name = "/platform/landing_zone"
  with_decryption = true
}