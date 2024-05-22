# module "kinesis_firehose" {
#   source = "../"

#   deploy = true

#   stream_name = "kinesis_firehose_2"

#   s3_bucket_arn                       = "arn:aws:s3:::arike123"
#   s3_prefix                           = "prefix/"
#   error_output_prefix                 = "errors/"
#   buffer_size                         = 1
#   buffer_interval                     = 60
#   role_arn                            = "arn:aws:iam::692383251404:role/Kinesis_Firehose_Role"
#   compression_format                  = "GZIP"
#   sse_kms_key_type                    = "CUSTOMER_MANAGED_CMK"
#   kms_key_arn                         = "arn:aws:kms:us-east-1:692383251404:key/92320492-5495-4106-ac7d-d8c6957cbfc8" # This is required for CUSTOMER_MANAGED_CMK
#   enable_cloudwatch_logging           = true                                                                          # Set to true to enable CloudWatch logging
#   cloudwatch_log_retention            = 7                                                                             # Retention period for CloudWatch logs in days
#   dynamic_partitioning                = true                                                                          # Set to true to enable dynamic partitioning
#   dynamic_partitioning_retry_duration = 300                                                                           # Retry duration for dynamic partitioning


#   tags = {
#     Environment = "dev"
#     Project     = "example-project"
#   }
# }


module "kinesis_firehose" {
  source = "../"

  deploy = true

  stream_name = "kinesis_firehose-1"

  s3_bucket_arn              = "arn:aws:s3:::arike123"
  s3_prefix                  = "prefix/"
  buffer_size                = 1
  buffer_interval            = 60
  role_arn                   = "arn:aws:iam::692383251404:role/Kinesis_Firehose_Role"
  kms_key_arn                = "arn:aws:kms:us-east-1:692383251404:key/92320492-5495-4106-ac7d-d8c6957cbfc8" # Your KMS Key ARN here
  compression_format         = "GZIP"
  sse_kms_key_type           = "CUSTOMER_MANAGED_CMK"
  cloudwatch_log_stream_name = "S3Delivery" # Name of the CloudWatch log stream
  error_output_prefix        = "error/"
  enable_cloudwatch_logging  = true # Set to true to enable CloudWatch logging
  cloudwatch_log_retention   = 7    # Retention period for CloudWatch logs in days
  #   dynamic_partitioning                = true                                                          # Set to true to enable dynamic partitioning
  #   dynamic_partitioning_retry_duration = 300                                                           # Retry duration for dynamic partitioning
  #   enable_processing_configuration     = true                                                          # Set to true to enable processing configuration
  #   lambda_arn                          = "arn:aws:lambda:us-east-1:692383251404:function:test_kinesis" # ARN of the Lambda function

  tags = {
    Environment = "dev"
    Project     = "example-project"
  }
}