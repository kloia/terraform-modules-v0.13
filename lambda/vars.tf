variable "name" {
  description = "Name of the Lambda function."
  type        = string

  validation {
    condition     = length(var.name) < 64
    error_message = "The name value must be below 64 char limit."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-]*[A-Za-z0-9]$", var.name))
    error_message = "The name value must alphanumeric. Can include dash, but can't start or end with it."
  }
}

variable "handler" {
  description = "Name of the Lambda function handler."
  type        = string

  validation {
    condition     = length(var.handler) < 128
    error_message = "The handler value must be below 128 char limit."
  }
  validation {
    condition     = can(regex("^[\\S]+$", var.handler))
    error_message = "The handler value can't include whitespace."
  }
}

variable "create_function" {
  description = "Enable creation of the lambda function or not."
  type        = bool
  default     = true
}

variable "create_cw" {
  description = "Enable creation of cloudwatch log group for the lambda function or not."
  type        = bool
  default     = false
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem. If not defined s3_bucket should given."
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Name of the runtime environment."
  type        = string
}

variable "s3_bucket" {
  description = "The s3 bucket that function resides in. If not defined filename should given."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "The S3 key of an object containing the function's deployment package."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "The S3 object's version."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Lambda function."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment variable config for Lambda function."
  type        = map(string)
  default     = null
}

variable "log_retention_days" {
  description = "Log retention for cloud watch lo group."
  type        = number
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Fargate."
  default     = {}
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  type        = number
  default     = -1
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = []
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key."
  type        = string
  default     = null
}

variable "security_groups" {
  description = "List of security groups to attach your Lambda Function."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnet to provision your Lambda Function on."
  type        = list(string)
  default     = []
}

variable "tracing_mode" {
  description = "Can be either PassThrough or Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  type        = string
  default     = "PassThrough"
}

variable "efs_arn" {
  type        = string
  default     = ""
}

variable "dead_letter_arn" {
  type        = string
  default     = null
}

variable "efs_mount_path" {
  type        = string
  default     = ""
  validation {
    condition = can(regex("^$|^/mnt/[\\w-/]*$", var.efs_mount_path))
    error_message = "Invalid value for efs_mount_path(must start with '/mnt/')!"
  }
}
