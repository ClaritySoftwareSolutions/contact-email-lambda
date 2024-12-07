resource "aws_api_gateway_model" "contact_email_request_body" {
  content_type = "application/json"
  description  = "Contact email request body schema model"
  name         = "ContactEmailRequestBody"
  rest_api_id  = aws_api_gateway_rest_api.contact_email_lambda_rest_api.id
  schema       = "{\n  \"$schema\": \"http://json-schema.org/draft-04/schema#\",\n  \"title\": \"Contact Email Request Body\",\n  \"type\": \"object\",\n  \"properties\": {\n    \"from\": {\n      \"type\": \"string\",\n      \"format\": \"email\"\n    },\n    \"message\": {\n      \"type\": \"string\"\n    }\n  },\n  \"required\": [\n    \"from\",\n    \"message\"\n  ]\n}\n"
}
