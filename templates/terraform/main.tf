provider "aws" {
  region = "us-east-1"
}


###########
# Backend configuration
###########
terraform {
  backend "s3" {
    key            = "{project_name}/backend/terraform.tfstate" # Default as devl but loaded from ./config/backend-{environment}.conf
    region         = "us-east-1"
    encrypt        = true
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}