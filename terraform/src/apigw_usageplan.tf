resource "aws_api_gateway_usage_plan" "contact_email_lambda_usage_plan" {
  name = "Contact Email Usage Plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
    stage  = aws_api_gateway_deployment.contact_email_lambda_rest_api_deployment.stage_name
  }

  throttle_settings {
    burst_limit = 2
    rate_limit  = 10
  }
}
