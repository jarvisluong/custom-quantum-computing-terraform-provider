provider "aws" {
  region = "us-west-1"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "braket" {
  aws_service_name = "braket.amazonaws.com"
}

resource "aws_iam_role_policy_attachment" "braket_service_linked" {
  role       = aws_iam_service_linked_role.braket.name
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonBraketServiceRolePolicy"
}

resource "aws_iam_role" "braket_execution" {
  name = "BraketExecutionRole"
  path = "service-role"
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
  bucket = "aws_braket_results_${data.aws_caller_identity.current.account_id}"
}
