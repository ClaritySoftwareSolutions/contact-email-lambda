resource "aws_api_gateway_api_key" "clarity_software_solutions" {
  name = "Clarity Software Solutions"
  description = "Clarity Software Solutions"
  tags = {
    "contact_email_to" = "${var.contact_email_to.clarity_software_solutions}"
  }
  enabled = true
}

resource "aws_api_gateway_usage_plan_key" "associate_clarity_software_solutions" {
  key_id        = aws_api_gateway_api_key.clarity_software_solutions.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.contact_email_lambda_usage_plan.id
}

resource "aws_api_gateway_api_key" "jake_russell_photography" {
  name = "Jake Russell Photography"
  description = "Jake Russell Photography"
  tags = {
    "contact_email_to" = "${var.contact_email_to.jake_russell_photography}"
  }
  enabled = true
}

resource "aws_api_gateway_usage_plan_key" "associate_jake_russell_photography" {
  key_id        = aws_api_gateway_api_key.jake_russell_photography.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.contact_email_lambda_usage_plan.id
}
