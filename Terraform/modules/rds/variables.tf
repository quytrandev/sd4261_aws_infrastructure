variable "project" {
  type        = string
  description = "project name"
  default     = ""
}

variable "owner" {
  type        = string
  description = "owner name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "rds" {
  type    = any 
  default = {}
}