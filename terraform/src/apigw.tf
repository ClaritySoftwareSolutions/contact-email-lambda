resource "aws_api_gateway_rest_api" "contact_email_lambda_rest_api" {
  name = "contact-email-lambda-rest-api"
  description = "Contact Email Lambda API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "contact" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  parent_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.root_resource_id
  path_part = "contact"
}

# POST method
resource "aws_api_gateway_method" "post" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
  request_validator_id = aws_api_gateway_request_validator.post_request_validator.id
  request_models = {
    "application/json" = aws_api_gateway_model.contact_email_request_body.name
  }
}

resource "aws_api_gateway_request_validator" "post_request_validator" {
  name                        = "post_request_validator"
  rest_api_id                 = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  validate_request_body       = true
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.contact_email_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"

  # CORS headers
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.post_method_response.status_code

  # CORS
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.post,
    aws_api_gateway_integration.post_integration
  ]
}

# OPTIONS method
resource "aws_api_gateway_method" "options" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_method_response.status_code

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration
  ]
}

# deployment
resource "aws_api_gateway_deployment" "contact_email_lambda_rest_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_integration,
    aws_api_gateway_integration.options_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  stage_name = "prod"
}

# Policy to allow the method integration to invoke the lambda function
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.contact_email_lambda_role.name
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_email_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.contact_email_lambda_rest_api.execution_arn}/*/*/*"
}
