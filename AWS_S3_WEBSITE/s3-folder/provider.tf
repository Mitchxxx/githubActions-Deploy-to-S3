terraform {
  required_providers {
    aws = {
        version = "~> 5.0"
        source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "mitch-gitlab-cicd"
    key = "githubActions/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  
}