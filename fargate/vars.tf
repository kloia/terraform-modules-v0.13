variable "enabled" {
  description = "Create the Fargate cluster or not."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the Fargate cluster."
  type        = string

  validation {
    condition     = length(var.name) < 255
    error_message = "The name value must be below 255 char limit."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9-_]*$", var.name))
    error_message = "The name value can include up to 255 letters, numbers, hyphens, and underscores."
  }
}

variable "spot_enabled" {
  description = "Create the Fargate cluster on spot instances."
  type        = bool
  default     = false
}

variable "container_insights_enabled" {
  description = "Enable container insights for the Fargate cluster."
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Fargate."
  default     = {}
}

variable "weight" {
  description = "The relative percentage of the total number of launched tasks that should use the specified capacity provider."
  type        = number
  default     = null
}

variable "base" {
  description = "The number of tasks, at a minimum, to run on the specified capacity provider. Only one capacity provider in a capacity provider strategy can have a base defined."
  type        = number
  default     = null
}