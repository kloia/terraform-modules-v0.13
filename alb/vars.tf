variable "name" {
  description = "Name of the ALB."
  type        = string

  validation {
    condition     = length(var.name) < 32
    error_message = "The name value must be below 32 char limit."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-]*[A-Za-z0-9]$", var.name))
    error_message = "The name value must alphanumeric. Can include dash, but can't start or end with it."
  }
}

variable "create_alb" {
  description = "Enable creation of the ALB or not."
  type        = bool
  default     = true
}

variable "internal" {
  description = "Checks if the ALB is internal."
  type        = bool
  default     = false
}

variable "subnets" {
  description = "A list of subnets to place the ALB."
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "A list of security group sfor the ALB."
  type        = list(string)
  default     = []
}


variable "access_logs_enabled" {
  description = "Checks if access logs for the ALB is enabled."
  type        = bool
  default     = false
}

variable "access_log_bucket_name" {
  description = "Access log bucket for the ALB."
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB."
  type        = bool
  default     = false
}

variable "tags" {
  type = map(string)
  description = "Tags for the ALB."
  default     = {}
}


variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable HTTP/2 or not."
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "10m"
}