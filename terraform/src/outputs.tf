output "api_url" {
  value = aws_api_gateway_deployment.contact_email_lambda_rest_api_deployment.invoke_url
}
