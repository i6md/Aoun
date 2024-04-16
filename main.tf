terraform {
    required_providers {
        aws = "~> 5.0"
    }

}

provider "aws" {
    region     = "eu-north-1"
}

variable "aws_region" {
  description = "The region where AWS operations will take place."
  type        = string
  default     = "eu-north-1"  // replace with your default region
}

resource "aws_iam_user" "root" {
  name = "root"
  path = "/"
}

resource "aws_iam_user_policy_attachment" "user_admin_access" {
  user       = aws_iam_user.root.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "s3_full_access_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "inline_policy" {
    name        = "inline_policy"
    role        = aws_iam_role.lambda_role.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow",
                Action   = [
                    "ec2:DescribeNetworkInterfaces",
                    "ec2:CreateNetworkInterface",
                    "ec2:DeleteNetworkInterface",
                    "ec2:DescribeInstances",
                    "ec2:AttachNetworkInterface"
                ],
                Resource = "*",
            }
        ]
    })
}

resource "aws_dynamodb_table" "user" {
    name           = "user"
    billing_mode   = "PROVISIONED"
    hash_key       = "user_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "user_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "item" {
    name           = "item"
    billing_mode   = "PROVISIONED"
    hash_key       = "item_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "item_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "picture" {
    name           = "picture"
    billing_mode   = "PROVISIONED"
    hash_key       = "pic_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "pic_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "item_order" {
    name           = "item_order"
    billing_mode   = "PROVISIONED"
    hash_key       = "order_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "order_id"
        type = "S"
    }

}

resource "aws_s3_bucket" "aoun_item_pictures" {
  bucket = "aoun-item-pictures"
}

resource "aws_s3_bucket_cors_configuration" "aoun_item_pictures" {
  bucket = aws_s3_bucket.aoun_item_pictures.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_acl" "aoun_item_pictures" {
    bucket = aws_s3_bucket.aoun_item_pictures.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.aoun_item_pictures_ownership]
}

resource "aws_s3_bucket_ownership_controls" "aoun_item_pictures_ownership" {
  bucket = aws_s3_bucket.aoun_item_pictures.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.aoun_item_pictures]
}

# resource "aws_iam_user" "aoun_item_pictures_bucket" {
#   name = "aoun-item-pictures-bucket"
# }

resource "aws_s3_bucket_public_access_block" "aoun_item_pictures" {
  bucket = aws_s3_bucket.aoun_item_pictures.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "aoun_item_pictures_bucket" {
    bucket = aws_s3_bucket.aoun_item_pictures.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::aoun-item-pictures",
          "arn:aws:s3:::aoun-item-pictures/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::aoun-item-pictures",
          "arn:aws:s3:::aoun-item-pictures/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.aoun_item_pictures]
}

data "archive_file" "lambda-functions" {
  type        = "zip"
  source_dir  = "./Lambda-Functions"
  output_path = "./Lambda-Functions.zip"
}

resource "aws_lambda_function" "add_item" {
  function_name    = "add_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "add_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "request_item" {
  function_name    = "request_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "request_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "order_item" {
  function_name    = "order_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "order_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "edit_item" {
  function_name    = "edit_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "edit_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "delete_item" {
  function_name    = "delete_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "list_orders" {
  function_name    = "list_orders"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_orders.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "accept_order" {
  function_name    = "accept_order"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "accept_order.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

resource "aws_lambda_function" "list_items" {
  function_name    = "list_items"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_items.lambda_handler"
  runtime          = "python3.9"
  timeout          = 20

}

# resource "aws_lambda_function" "last_item" {
#   function_name    = "last_item"
#   filename         = data.archive_file.lambda-functions.output_path
#   source_code_hash = data.archive_file.lambda-functions.output_base64sha256
#   role             = aws_iam_role.lambda_role.arn
#   handler          = "last_item.lambda_handler"
#   runtime          = "python3.9"
#   timeout          = 5

# }

resource "aws_apigatewayv2_api" "lambda" {
  name          = "Senior_project"
  protocol_type = "HTTP"
}

// to enable auto deployment (update the deployed function whenever the lambda function is updated)
resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "ver1"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "add_item" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.add_item.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_item" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /add_item"

  target = "integrations/${aws_apigatewayv2_integration.add_item.id}"
}

resource "aws_apigatewayv2_integration" "request_item" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.request_item.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "request_item" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /request_item"

  target = "integrations/${aws_apigatewayv2_integration.request_item.id}"
}

resource "aws_apigatewayv2_integration" "order_item" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.order_item.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "order_item" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /order_item"

  target = "integrations/${aws_apigatewayv2_integration.order_item.id}"
}

resource "aws_apigatewayv2_integration" "edit_item" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.edit_item.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "edit_item" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /edit_item"

  target = "integrations/${aws_apigatewayv2_integration.edit_item.id}"
}

resource "aws_apigatewayv2_integration" "delete_item" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.delete_item.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_item" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /delete_item"

  target = "integrations/${aws_apigatewayv2_integration.delete_item.id}"
}

resource "aws_apigatewayv2_integration" "list_orders" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_orders.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_orders" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_orders"

  target = "integrations/${aws_apigatewayv2_integration.list_orders.id}"
}

resource "aws_apigatewayv2_integration" "accept_order" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.accept_order.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "accept_order" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /accept_order"

  target = "integrations/${aws_apigatewayv2_integration.accept_order.id}"
}

resource "aws_apigatewayv2_integration" "list_items" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_items.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_items" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_items"

  target = "integrations/${aws_apigatewayv2_integration.list_items.id}"
}

# resource "aws_apigatewayv2_integration" "last_item" {
#   api_id            = aws_apigatewayv2_api.lambda.id
#   integration_type  = "AWS_PROXY"
#   integration_uri   = aws_lambda_function.last_item.invoke_arn
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "last_item" {
#   api_id    = aws_apigatewayv2_api.lambda.id
#   route_key = "POST /last"

#   target = "integrations/${aws_apigatewayv2_integration.last_item.id}"
# }

resource "aws_lambda_permission" "add_item_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "request_item_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "order_item_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.order_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "edit_item_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.edit_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_item_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_orders_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_orders.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "accept_order_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.accept_order.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_items_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_items.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# resource "aws_lambda_permission" "last_item_apigw_permision" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.last_item.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
# }