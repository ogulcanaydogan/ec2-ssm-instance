terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2_ssm_instance" {
  source = "../.."

  name          = "example"
  ami_id        = "ami-1234567890abcdef0"
  instance_type = "t3.micro"
  subnet_id     = "subnet-1234567890abcdef0"
  vpc_id        = "vpc-1234567890abcdef0"
}
