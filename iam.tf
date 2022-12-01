# VPC Flow Logs IAM Policy Document
data "aws_iam_policy_document" "s3" {
  count = var.vpc_flow_logs_destination == "S3" ? 1 : 0
  statement {
    sid    = "SendVPCFlowLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3RW"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:*Object"
    ]
    resources = [
      "${aws_s3_bucket.vpc_flow_logs[0].arn}",
      "${aws_s3_bucket.vpc_flow_logs[0].arn}/*",
    ]
  }


  statement {
    sid    = "KMSRW"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      aws_kms_key.vpc_flow_logs[0].arn
    ]
  }

  depends_on = [
    aws_s3_bucket.vpc_flow_logs,
    aws_kms_key.vpc_flow_logs
  ]
}

data "aws_iam_policy_document" "cloudwatch" {
  count = var.vpc_flow_logs_destination == "S3" ? 0 : 1
  statement {
    sid    = "SendVPCFlowLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

# VPC Flow Logs IAM Role Policy Document
data "aws_iam_policy_document" "vpc_fl_role_source" {
  statement {
    sid    = "VPCFlowLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# VPC Flow Logs IAM Policy
resource "aws_iam_policy" "vpc_fl_policy" {
  name        = "${var.name_prefix}-VPCFlowLogs-Policy"
  path        = "/"
  description = "VPC Flow Logs"
  policy      = var.vpc_flow_logs_destination == "S3" ? data.aws_iam_policy_document.s3[0].json : data.aws_iam_policy_document.cloudwatch[0].json
  tags        = { Name = "${var.name_prefix}-VPCFlowLogs-Policy" }
}

# VPC Flow Logs IAM Role (vpc_fl_ Task Execution role)
resource "aws_iam_role" "vpc_fl_policy_role" {
  name               = "${var.name_prefix}-VPCFlowLogs-Role"
  assume_role_policy = data.aws_iam_policy_document.vpc_fl_role_source.json
  tags               = { Name = "${var.name_prefix}-VPCFlowLogs-Role" }
}

# Attach VPC Flow Logs Role and Policy
resource "aws_iam_role_policy_attachment" "vpc_fl_attach" {
  role       = aws_iam_role.vpc_fl_policy_role.name
  policy_arn = aws_iam_policy.vpc_fl_policy.arn
}