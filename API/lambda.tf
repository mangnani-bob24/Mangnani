# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "LambdaExecRole-New" # 이름 변경
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM policies for Lambda (Basic execution and CloudWatch logging)
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Additional IAM policies for Lambda (DynamoDB and CloudWatch)
resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_exec.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs" {
  role       = aws_iam_role.lambda_exec.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# DefaultHintFunction
resource "aws_lambda_function" "default_hint" {
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy]
  function_name    = "DefaultHintFunction-New" # 이름 변경
  handler          = "default_hint.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "${path.module}/lambda_code/default_hint.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/default_hint.zip")
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      REGION    = "ap-northeast-1"
    }
  }
  timeout     = 10  # 초 단위
  memory_size = 256 # MB
  tags = {
    Environment = "Production"
    Project     = "Mangnani Wargame"
  }
}

# InvalidPathHintFunction
resource "aws_lambda_function" "invalid_hint" {
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy]
  function_name    = "InvalidHintFunction-New" # 이름 변경
  handler          = "invalid_hint.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "${path.module}/lambda_code/invalid_hint.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/invalid_hint.zip")
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      REGION    = "ap-northeast-1"
    }
  }
  timeout     = 10  # 초 단위
  memory_size = 256 # MB
  tags = {
    Environment = "Production"
    Project     = "Mangnani Wargame"
  }
}

# HintFunction
resource "aws_lambda_function" "hint" {
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy]
  function_name    = "HintFunction-New" # 이름 변경
  handler          = "hint.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "${path.module}/lambda_code/hint.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/hint.zip")
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      REGION    = "ap-northeast-1"
    }
  }
  timeout     = 10  # 초 단위
  memory_size = 256 # MB
  tags = {
    Environment = "Production"
    Project     = "Mangnani Wargame"
  }
}

# PublicFlagFunction
resource "aws_lambda_function" "public" {
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy]
  function_name    = "PublicFlagFunction-New" # 이름 변경
  handler          = "public.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "${path.module}/lambda_code/public.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/public.zip")
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      REGION    = "ap-northeast-1"
    }
  }
  timeout     = 10  # 초 단위
  memory_size = 256 # MB
  tags = {
    Environment = "Production"
    Project     = "Mangnani Wargame"
  }
}

# AdminFlagFunction
resource "aws_lambda_function" "admin" {
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy]
  function_name    = "AdminFlagFunction-New" # 이름 변경
  handler          = "admin.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "${path.module}/lambda_code/admin.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/admin.zip")
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      REGION    = "ap-northeast-1"
    }
  }
  timeout     = 10  # 초 단위
  memory_size = 256 # MB
  tags = {
    Environment = "Production"
    Project     = "Mangnani Wargame"
  }
}

# Adding API Gateway permissions for each Lambda function
resource "aws_lambda_permission" "default_hint_permission" {
  statement_id  = "AllowAPIGatewayInvokeDefaultHint"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default_hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "invalid_hint_permission" {
  statement_id  = "AllowAPIGatewayInvokeInvalidHint"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invalid_hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "hint_permission" {
  statement_id  = "AllowAPIGatewayInvokeHint"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "public_permission" {
  statement_id  = "AllowAPIGatewayInvokePublic"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.public.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "admin_permission" {
  statement_id  = "AllowAPIGatewayInvokeAdmin"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.admin.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
