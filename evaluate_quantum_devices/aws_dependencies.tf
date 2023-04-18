provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "uswest1"
  region = "us-west-1"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "braket" {
  aws_service_name = "braket.amazonaws.com"
}

resource "aws_iam_role" "braket_execution" {
  name = "AmazonBraketJobsExecutionRole"
  path = "/service-role/"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonBraketJobsExecutionPolicy"
  ]
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "braket.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "braket_result" {
  provider = aws.uswest1
  bucket = "amazon-braket-results-${data.aws_caller_identity.current.account_id}"
}
