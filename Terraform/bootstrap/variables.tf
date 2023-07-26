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
