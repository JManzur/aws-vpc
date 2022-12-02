# Create the Bucket
resource "aws_s3_bucket" "vpc_flow_logs" {
  count  = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  bucket = "${aws_vpc.vpc.id}-flow-logs"

  tags = { Name = lower("${var.name_prefix}-vpc-flow-logs") }

  depends_on = [
    aws_vpc.vpc
  ]
}

# Enable Versioning on Bucket
resource "aws_s3_bucket_versioning" "vpc_flow_logs" {
  count  = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  bucket = aws_s3_bucket.vpc_flow_logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access to the bucket and objects
resource "aws_s3_bucket_public_access_block" "vpc_flow_logs" {
  count  = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  bucket = aws_s3_bucket.vpc_flow_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enble Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs" {
  count  = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  bucket = aws_s3_bucket.vpc_flow_logs[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

##CloudWatch log group
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  count             = var.vpc_flow_logs_destination == "S3" ? 0 : 1
  name              = "${aws_vpc.vpc.id}-flow-logs"
  retention_in_days = var.logs_retention

  tags = { Name = lower("${var.name_prefix}-vpc-flow-logs") }

  depends_on = [
    aws_vpc.vpc
  ]
}

# VPC Flow Logs to CloudWatch
resource "aws_flow_log" "cloudwatch" {
  count           = var.vpc_flow_logs_destination == "S3" ? 0 : 1
  iam_role_arn    = aws_iam_role.vpc_fl_policy_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id

  tags = { Name = lower("${var.name_prefix}-cw-vpc-flow-logs") }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "s3" {
  count                = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  iam_role_arn         = aws_iam_role.vpc_fl_policy_role.arn
  log_destination      = aws_s3_bucket.vpc_flow_logs[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  tags = { Name = lower("${var.name_prefix}-s3-vpc-flow-logs") }
}