terraform {
  required_providers {
    aws = {
        version = "~> 5.0"
        source = "hashicorp/aws"
    }
  }
  backend "s3" {
    
  }
}

provider "aws" {
  
}