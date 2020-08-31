variable "bucket_name" {
    type = string
    description = "Name of bucket"
}

variable "acl" {
    default = "private"
}

variable "tags" {
    type = map(string)
    description = "Tags for bucket"
}

variable "is_vers_enabled" {
    type = bool
    description = "Enable versioning"
    default = false
}

variable "is_lifecycle_enabled" {
    type = bool
    description = "Enable lifecycle"
    default = false
}

variable "short_storage_day" {
    type = string
    default =  40
}

variable "long_storage_day" {
    type = string
    default =  90
}

variable "storage_class" {
  default = "STANDARD_IA"
}

variable "long_storage_class" {
  default = "GLACIER"
}

variable "force_destroy" {
    type = bool
    description = "Force to destroy bucket"
    default = false
}

variable "expiration" {
    default     = 90

}

variable "prefix" {
    default = "/"
}