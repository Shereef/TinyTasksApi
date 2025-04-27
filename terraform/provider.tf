provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # You may want to uncomment and configure this section to use remote state
  # backend "s3" {
  #   # Configure remote state to be prompted at init time
  # }
}