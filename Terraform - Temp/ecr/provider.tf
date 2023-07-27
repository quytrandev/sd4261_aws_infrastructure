provider "aws" {
  region  = "us-west-2"
  profile = "quytran-aws-practical-devops"
}

terraform {
  required_version = "~> 1.3.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-boostrap-nashtech-devops"
    key            = "ecr.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-boostrap-nashtech-devops"
    profile        = "quytran-aws-practical-devops"
    encrypt        = true
    kms_key_id     = "05e421ca-4bbc-4f0f-be49-e53fbb97769c"
  }
} 