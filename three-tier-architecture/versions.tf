terraform {

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">3.41.0"
      }
    }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "organization-gcf"
  
    workspaces {
      name = "test-sample1-dev-account-infra"
    }

  }
}