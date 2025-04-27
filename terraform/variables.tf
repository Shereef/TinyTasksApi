variable "app_name" {
  description = "Name of the application, used to prefix resources"
  type        = string
  default = "shereef-tinytasksapi"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID - will be prompted for this value at apply time"
  type        = string
  # No default means Terraform will prompt for this value
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository containing the application image"
  type        = string
  default     = "shereef-tinytasksapi"
}

variable "ecr_image_tag" {
  description = "Tag of the container image to deploy"
  type        = string
  default     = "latest"
}