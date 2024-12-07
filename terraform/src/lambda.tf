resource "aws_iam_role" "contact_email_lambda_role" {
  name               = "contact-email-lambda-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "contact_email_lambda" {
  filename      = "../../dist/lambda_function_${var.lambdaVersion}.zip"
  function_name = "contact_email_lambda"
  role          = aws_iam_role.contact_email_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  memory_size   = 1024
  timeout       = 300
}

resource "aws_cloudwatch_log_group" "contact_email_lambda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.contact_email_lambda.function_name}"
  retention_in_days = 3
}

data "aws_iam_policy_document" "contact_email_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.contact_email_lambda_loggroup.arn,
      "${aws_cloudwatch_log_group.contact_email_lambda_loggroup.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "contact_email_lambda_role_policy" {
  policy = data.aws_iam_policy_document.contact_email_lambda_policy.json
  role   = aws_iam_role.contact_email_lambda_role.id
  name   = "contact-email-lambda-policy"
}
