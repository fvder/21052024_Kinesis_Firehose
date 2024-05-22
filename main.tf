locals {
  s3_prefix = var.dynamic_partitioning ? "${var.s3_prefix}/!{partitionKeyFromQuery:field}" : var.s3_prefix

  firehose_config = {
    name                          = var.stream_name
    s3_bucket_arn                 = var.s3_bucket_arn
    buffer_size                   = var.buffer_size
    buffer_interval               = var.buffer_interval
    role_arn                      = var.role_arn
    kms_key_arn                   = var.kms_key_arn
    compression_format            = var.compression_format
    sse_kms_key_type              = var.sse_kms_key_type
    error_output_prefix           = var.error_output_prefix
    enable_cloudwatch_logging     = var.enable_cloudwatch_logging
    cloudwatch_log_retention      = var.cloudwatch_log_retention
    dynamic_partitioning          = var.dynamic_partitioning
    dynamic_partitioning_retry_duration = var.dynamic_partitioning_retry_duration
    enable_processing_configuration = var.dynamic_partitioning || var.enable_processing_configuration
    lambda_arn                    = var.lambda_arn
    cloudwatch_log_stream_name    = var.cloudwatch_log_stream_name
    tags                          = var.tags
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  for_each = var.deploy ? { for idx, val in [local.firehose_config] : idx => val } : {}

  name        = each.value.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = each.value.role_arn
    bucket_arn          = each.value.s3_bucket_arn
    prefix              = local.s3_prefix
    buffering_size         = each.value.buffer_size
    buffering_interval     = each.value.buffer_interval
    compression_format  = each.value.compression_format
    kms_key_arn = each.value.kms_key_arn
    error_output_prefix = each.value.error_output_prefix

    cloudwatch_logging_options {
      enabled         = each.value.enable_cloudwatch_logging
      log_group_name  = aws_cloudwatch_log_group.firehose_logs[each.value.name].name
      log_stream_name = each.value.cloudwatch_log_stream_name
    }

    dynamic "dynamic_partitioning_configuration" {
      for_each = each.value.dynamic_partitioning ? [each.value] : []
      content {
        enabled                      = true
        retry_duration    = each.value.dynamic_partitioning_retry_duration
      }
    }

    dynamic "processing_configuration" {
      for_each = each.value.enable_processing_configuration ? [each.value] : []
      content {
        enabled = true

        dynamic "processors" {
          for_each = each.value.dynamic_partitioning ? [1] : []
          content {
            type = "MetadataExtraction"
            parameters {
              parameter_name  = "MetadataExtractionQuery"
              parameter_value = "{field: .field}"
            }
            parameters {
              parameter_name  = "JsonParsingEngine"
              parameter_value = "JQ-1.6"
            }
          }
        }

        processors {
          type = "Lambda"
          parameters {
            parameter_name  = "LambdaArn"
            parameter_value = each.value.lambda_arn
          }
        }
      }
    }
  }

  tags = each.value.tags
}

resource "aws_cloudwatch_log_group" "firehose_logs" {
  for_each = var.deploy && var.enable_cloudwatch_logging ? { (var.stream_name) : local.firehose_config } : {}

  name              = "/aws/kinesisfirehose/${each.value.name}"
  retention_in_days = each.value.cloudwatch_log_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  for_each = var.deploy && var.enable_cloudwatch_logging ? { for idx, val in [local.firehose_config] : idx => val } : {}

  name           = each.value.cloudwatch_log_stream_name
  log_group_name = aws_cloudwatch_log_group.firehose_logs[each.value.name].name
}
