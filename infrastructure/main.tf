
# requires Terraform 0.13 +
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # or whatever region you are targeting
}
