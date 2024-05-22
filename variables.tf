variable "deploy" {
  description = "Boolean to deploy resources"
  type        = bool
  default     = true
}

variable "stream_name" {
  description = "Name of the firehose stream"
  type        = string
  default     = ""
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
  default     = ""
}

variable "s3_prefix" {
  description = "S3 prefix"
  type        = string
  default     = ""
}

variable "buffer_size" {
  description = "Buffer size in MBs"
  type        = number
  default     = 5
}

variable "buffer_interval" {
  description = "Buffer interval in seconds"
  type        = number
  default     = 300
}

variable "role_arn" {
  description = "IAM role ARN"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "KMS key ARN for S3 bucket encryption"
  # Required only if `server_side_encryption` is set to "CUSTOMER_MANAGED_CMK"
  type        = string
  default     = ""
}

variable "compression_format" {
  description = "Compression format for S3"
  # Possible values: UNCOMPRESSED, GZIP, ZIP, Snappy, HADOOP_SNAPPY
  type        = string
  default     = "GZIP"
}

variable "sse_kms_key_type" {
  description = "SSE KMS key type"
  # Possible values: AWS_OWNED_CMK, CUSTOMER_MANAGED_CMK
  type        = string
  default     = "AWS_OWNED_CMK"
}

variable "error_output_prefix" {
  description = "Prefix for error output"
  type        = string
  default     = ""
}

variable "dynamic_partitioning" {
  description = "Boolean to enable or disable dynamic partitioning"
  type        = bool
  default     = false
}

variable "dynamic_partitioning_retry_duration" {
  description = "Retry duration for dynamic partitioning in seconds"
  type        = number
  default     = 300
}

variable "enable_processing_configuration" {
  description = "Boolean to enable or disable the processing configuration"
  type        = bool
  default     = false
}

variable "lambda_arn" {
  description = "ARN of the Lambda function for processing, required if enable_processing_configuration is true"
  type        = string
  default     = ""
}

variable "enable_cloudwatch_logging" {
  description = "Boolean to enable or disable CloudWatch logging"
  type        = bool
  default     = false
}

variable "cloudwatch_log_retention" {
  description = "Retention period for CloudWatch logs in days"
  type        = number
  default     = 7
}

variable "cloudwatch_log_stream_name" {
  description = "Name of the CloudWatch log stream"
  type        = string
  default     = "S3Delivery"
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
  default     = {}
}
