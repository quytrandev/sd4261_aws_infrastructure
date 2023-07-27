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
    bucket         = "quytran-practical-devops-bucket-tf"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-boostrap-nashtech-devops"
    profile        = "quytran-aws-practical-devops"
    encrypt        = true
    kms_key_id     = "fff758c9-658d-4a49-98c4-3fabf9b7384d"
  }
}
