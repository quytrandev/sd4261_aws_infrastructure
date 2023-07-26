variable "aws-region" {
  description = "AWS region to launch servers."
  default     = "ap-southeast-1"
}

variable "create_private_natgw" {
  type    = bool
  default = false
}

variable "name" {}

variable "project-name" {}

#variable "environment" {}

variable "owner" {}

variable "vpc-cidr-block-dev" {}

variable "public-subnet-numbers-dev" {}

variable "private-subnet-numbers-dev" {}

variable "vpc-cidr-block-staging" {}

variable "public-subnet-numbers-staging" {}

variable "private-subnet-numbers-staging" {}
