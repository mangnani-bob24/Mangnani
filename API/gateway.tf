resource "aws_api_gateway_rest_api" "api" {
  name        = "VulnerableAPI"
  description = "API Gateway for Mangnani Wargame"
}

# Lambda Permissions for each endpoint
resource "aws_lambda_permission" "root_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default_hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "invalid_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invalid_hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "hint_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "public_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.public.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "admin_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.admin.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

# Root path ("/")
resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.root_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.default_hint.invoke_arn
}

resource "aws_api_gateway_method_response" "root_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = aws_api_gateway_method.root_method.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "root_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.root_method.http_method
  status_code = aws_api_gateway_method_response.root_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.root_integration
  ]
}

# /invalid path
resource "aws_api_gateway_resource" "invalid" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "invalid"
}

resource "aws_api_gateway_method" "invalid_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.invalid.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "invalid_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.invalid.id
  http_method             = aws_api_gateway_method.invalid_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.invalid_hint.invoke_arn
}

resource "aws_api_gateway_method_response" "invalid_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.invalid.id
  http_method   = aws_api_gateway_method.invalid_method.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "invalid_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.invalid.id
  http_method = aws_api_gateway_method.invalid_method.http_method
  status_code = aws_api_gateway_method_response.invalid_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.invalid_integration
  ]
}

# /hint path
resource "aws_api_gateway_resource" "hint" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hint"
}

resource "aws_api_gateway_method" "hint_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.hint.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hint_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.hint.id
  http_method             = aws_api_gateway_method.hint_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hint.invoke_arn
}

resource "aws_api_gateway_method_response" "hint_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.hint.id
  http_method   = aws_api_gateway_method.hint_method.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "hint_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.hint.id
  http_method = aws_api_gateway_method.hint_method.http_method
  status_code = aws_api_gateway_method_response.hint_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.hint_integration
  ]
}

# /public path
resource "aws_api_gateway_resource" "public" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "public"
}

resource "aws_api_gateway_method" "public_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.public.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "public_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.public.id
  http_method             = aws_api_gateway_method.public_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.public.invoke_arn
}

resource "aws_api_gateway_method_response" "public_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.public.id
  http_method   = aws_api_gateway_method.public_method.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "public_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.public.id
  http_method = aws_api_gateway_method.public_method.http_method
  status_code = aws_api_gateway_method_response.public_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.public_integration
  ]
}

# /admin path
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "admin"
}

resource "aws_api_gateway_method" "admin_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.admin.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "admin_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.admin.id
  http_method             = aws_api_gateway_method.admin_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.admin.invoke_arn
}

resource "aws_api_gateway_method_response" "admin_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.admin.id
  http_method   = aws_api_gateway_method.admin_method.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "admin_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.admin.id
  http_method = aws_api_gateway_method.admin_method.http_method
  status_code = aws_api_gateway_method_response.admin_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.admin_integration
  ]
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  description = "Deployed at ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.root_integration,
    aws_api_gateway_integration.invalid_integration,
    aws_api_gateway_integration.hint_integration,
    aws_api_gateway_integration.public_integration,
    aws_api_gateway_integration.admin_integration,
    aws_api_gateway_method_response.root_method_response,
    aws_api_gateway_method_response.invalid_method_response,
    aws_api_gateway_method_response.hint_method_response,
    aws_api_gateway_method_response.public_method_response,
    aws_api_gateway_method_response.admin_method_response
  ]

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}