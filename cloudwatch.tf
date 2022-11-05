##CloudWatch log group [30 days retention]
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "${var.name_prefix}-VPC-Logs"
  retention_in_days = var.logs_retention

  tags = { Name = "${var.name_prefix}-VPC-Logs" }
}