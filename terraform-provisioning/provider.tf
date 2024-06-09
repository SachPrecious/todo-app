provider "aws" {
  region = "ap-south-1" # defines which region the ec2 instance should be provisioned
  profile = "lecture" # defines the aws profile configured by the aws cli
  
}

# configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}