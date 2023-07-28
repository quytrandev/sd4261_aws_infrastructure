variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "intra_subnet_cidrs" {
 type        = list(string)
 description = "Intra Subnet CIDR values"
 default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "name" {
  description = "Resource name."
  default     = ""
}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment name. If not specified, this module will use workspace as default value"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Adds a tag indicating the creator of this resource"
  default     = ""
}