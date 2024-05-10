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

resource "aws_iam_role_policy_attachment" "cognito_power_user_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
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

resource "aws_dynamodb_table" "event" {
    name           = "event"
    billing_mode   = "PROVISIONED"
    hash_key       = "event_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "event_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "event_picture" {
    name           = "event_picture"
    billing_mode   = "PROVISIONED"
    hash_key       = "pic_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "pic_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "ride" {
    name           = "ride"
    billing_mode   = "PROVISIONED"
    hash_key       = "ride_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "ride_id"
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

resource "aws_dynamodb_table" "participant" {
    name           = "participant"
    billing_mode   = "PROVISIONED"
    hash_key       = "order_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "order_id"
        type = "S"
    }

} 

resource "aws_dynamodb_table" "passenger" {
    name           = "passenger"
    billing_mode   = "PROVISIONED"
    hash_key       = "order_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "order_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "report" {
    name           = "report"
    billing_mode   = "PROVISIONED"
    hash_key       = "report_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "report_id"
        type = "S"
    }

}

resource "aws_dynamodb_table" "tech_report" {
    name           = "tech_report"
    billing_mode   = "PROVISIONED"
    hash_key       = "report_id"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = "report_id"
        type = "S"
    }

}

resource "aws_s3_bucket" "aoun_user_pictures" {
  bucket = "aoun-user-pictures"
}

resource "aws_s3_bucket_cors_configuration" "aoun_user_pictures" {
  bucket = aws_s3_bucket.aoun_user_pictures.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_acl" "aoun_user_pictures" {
    bucket = aws_s3_bucket.aoun_user_pictures.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.aoun_user_pictures_ownership]
}

resource "aws_s3_bucket_ownership_controls" "aoun_user_pictures_ownership" {
  bucket = aws_s3_bucket.aoun_user_pictures.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.aoun_user_pictures]
}

resource "aws_s3_bucket_public_access_block" "aoun_user_pictures" {
  bucket = aws_s3_bucket.aoun_user_pictures.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "aoun_user_pictures_bucket" {
    bucket = aws_s3_bucket.aoun_user_pictures.id
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
          "arn:aws:s3:::aoun-user-pictures",
          "arn:aws:s3:::aoun-user-pictures/*"
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
          "arn:aws:s3:::aoun-user-pictures",
          "arn:aws:s3:::aoun-user-pictures/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.aoun_user_pictures]
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

resource "aws_s3_bucket" "aoun_event_pictures" {
  bucket = "aoun-event-pictures"
}

resource "aws_s3_bucket_cors_configuration" "aoun_event_pictures" {
  bucket = aws_s3_bucket.aoun_event_pictures.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_acl" "aoun_event_pictures" {
    bucket = aws_s3_bucket.aoun_event_pictures.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.aoun_event_pictures_ownership]
}

resource "aws_s3_bucket_ownership_controls" "aoun_event_pictures_ownership" {
  bucket = aws_s3_bucket.aoun_event_pictures.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.aoun_event_pictures]
}

resource "aws_s3_bucket_public_access_block" "aoun_event_pictures" {
  bucket = aws_s3_bucket.aoun_event_pictures.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "aoun_event_pictures_bucket" {
    bucket = aws_s3_bucket.aoun_event_pictures.id
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
          "arn:aws:s3:::aoun-event-pictures",
          "arn:aws:s3:::aoun-event-pictures/*"
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
          "arn:aws:s3:::aoun-event-pictures",
          "arn:aws:s3:::aoun-event-pictures/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.aoun_event_pictures]
}

data "archive_file" "user-lambda-functions" {
  type        = "zip"
  source_dir  = "./User-Lambda-Functions"
  output_path = "./User-Lambda-Functions.zip"
}

resource "aws_lambda_function" "add_user_info" {
  function_name    = "add_user_info"
  filename         = data.archive_file.user-lambda-functions.output_path
  source_code_hash = data.archive_file.user-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "add_user_info.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_user_info" {
  function_name    = "list_user_info"
  filename         = data.archive_file.user-lambda-functions.output_path
  source_code_hash = data.archive_file.user-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_user_info.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "edit_user_info" {
  function_name    = "edit_user_info"
  filename         = data.archive_file.user-lambda-functions.output_path
  source_code_hash = data.archive_file.user-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "edit_user_info.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

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
  timeout          = 60

}

resource "aws_lambda_function" "request_item" {
  function_name    = "request_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "request_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "order_item" {
  function_name    = "order_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "order_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "edit_item" {
  function_name    = "edit_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "edit_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "delete_item" {
  function_name    = "delete_item"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_item.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_orders" {
  function_name    = "list_orders"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_orders.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "accept_order" {
  function_name    = "accept_order"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "accept_order.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "reject_order" {
  function_name    = "reject_order"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "reject_order.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_items" {
  function_name    = "list_items"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_items.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "report" {
  function_name    = "report"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "report.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_reports" {
  function_name    = "list_reports"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_reports.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "tech_report" {
  function_name    = "tech_report"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "tech_report.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_tech_reports" {
  function_name    = "list_tech_reports"
  filename         = data.archive_file.lambda-functions.output_path
  source_code_hash = data.archive_file.lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_tech_reports.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

data "archive_file" "event-lambda-functions" {
  type        = "zip"
  source_dir  = "./Event-Lambda-Functions"
  output_path = "./Event-Lambda-Functions.zip"
}

resource "aws_lambda_function" "add_event" {
  function_name    = "add_event"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "add_event.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_events" {
  function_name    = "list_events"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_events.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "edit_event" {
  function_name    = "edit_event"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "edit_event.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "delete_event" {
  function_name    = "delete_event"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_event.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "join_event" {
  function_name    = "join_event"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "join_event.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_participations" {
  function_name    = "list_participations"
  filename         = data.archive_file.event-lambda-functions.output_path
  source_code_hash = data.archive_file.event-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_participations.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

data "archive_file" "ride-lambda-functions" {
  type        = "zip"
  source_dir  = "./Ride-Lambda-Functions"
  output_path = "./Ride-Lambda-Functions.zip"
}

resource "aws_lambda_function" "add_ride" {
  function_name    = "add_ride"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "add_ride.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_rides" {
  function_name    = "list_rides"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_rides.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "edit_ride" {
  function_name    = "edit_ride"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "edit_ride.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "delete_ride" {
  function_name    = "delete_ride"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_ride.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "join_ride" {
  function_name    = "join_ride"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "join_ride.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "list_passengers" {
  function_name    = "list_passengers"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "list_passengers.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_lambda_function" "get_token" {
  function_name    = "get_token"
  filename         = data.archive_file.ride-lambda-functions.output_path
  source_code_hash = data.archive_file.ride-lambda-functions.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_token.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

}

resource "aws_cognito_user_pool" "user_pool" {
  name = "user_pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    
    string_attribute_constraints {
      max_length = 256
      min_length = 0
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "phone_number"
    required            = true
    
    string_attribute_constraints {
      max_length = 256
      min_length = 0
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "name"
    required            = true
    
    string_attribute_constraints {
      max_length = 256
      min_length = 0
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "building_number"
    required            = false

    string_attribute_constraints {
      max_length = 256
      min_length = 0
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "room_number"
    required            = false

    string_attribute_constraints {
      max_length = 256
      min_length = 0
    }
  }

  auto_verified_attributes = ["email"]

  // Add this line to allow sign-in with email
  username_attributes = ["email"]

  // Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  // Add these lines to enable verifying attribute changes
  email_verification_message = "Your verification code is {####}."
  email_verification_subject = "Aoun Verification Code"

  // Add this block to enable verifying attribute changes
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
  }

}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

   refresh_token_validity = 150
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name = "identity_pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.user_pool_client.id
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
    server_side_token_check = false
  }
}

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

resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.lambda.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito_authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.user_pool_client.id]
    issuer   = "https://cognito-idp.eu-north-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

resource "aws_apigatewayv2_integration" "add_user_info" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.add_user_info.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_user_info" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /add_user_info"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.add_user_info.id}"
}

resource "aws_apigatewayv2_integration" "list_user_info" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_user_info.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_user_info" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /list_user_info"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_user_info.id}"
}

resource "aws_apigatewayv2_integration" "edit_user_info" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.edit_user_info.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "edit_user_info" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /edit_user_info"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.edit_user_info.id}"
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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.accept_order.id}"
}

resource "aws_apigatewayv2_integration" "reject_order" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.reject_order.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "reject_order" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /reject_order"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.reject_order.id}"
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
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_items.id}"
}

resource "aws_apigatewayv2_integration" "report" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.report.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "report" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /report"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.report.id}"
}

resource "aws_apigatewayv2_integration" "list_reports" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_reports.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_reports" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_reports"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_reports.id}"
}

resource "aws_apigatewayv2_integration" "tech_report" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.tech_report.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "tech_report" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /tech_report"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.tech_report.id}"
}

resource "aws_apigatewayv2_integration" "list_tech_reports" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_tech_reports.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_tech_reports" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /list_tech_reports"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_tech_reports.id}"
}

resource "aws_apigatewayv2_integration" "add_event" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.add_event.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_event" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /add_event"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.add_event.id}"
}

resource "aws_apigatewayv2_integration" "list_events" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_events.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_events" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_events"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_events.id}"
}

resource "aws_apigatewayv2_integration" "edit_event" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.edit_event.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "edit_event" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /edit_event"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.edit_event.id}"
}

resource "aws_apigatewayv2_integration" "delete_event" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.delete_event.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_event" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /delete_event"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.delete_event.id}"
}

resource "aws_apigatewayv2_integration" "join_event" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.join_event.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "join_event" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /join_event"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.join_event.id}"
}

resource "aws_apigatewayv2_integration" "list_participations" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_participations.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_participations" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_participations"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_participations.id}"
}

resource "aws_apigatewayv2_integration" "add_ride" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.add_ride.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_ride" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /add_ride"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.add_ride.id}"
}

resource "aws_apigatewayv2_integration" "list_rides" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_rides.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_rides" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_rides"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_rides.id}"
}

resource "aws_apigatewayv2_integration" "edit_ride" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.edit_ride.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "edit_ride" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /edit_ride"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.edit_ride.id}"
}

resource "aws_apigatewayv2_integration" "delete_ride" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.delete_ride.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_ride" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /delete_ride"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.delete_ride.id}"
}

resource "aws_apigatewayv2_integration" "join_ride" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.join_ride.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "join_ride" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /join_ride"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.join_ride.id}"
}

resource "aws_apigatewayv2_integration" "list_passengers" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.list_passengers.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "list_passengers" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /list_passengers"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"

  target = "integrations/${aws_apigatewayv2_integration.list_passengers.id}"
}

resource "aws_apigatewayv2_integration" "get_token" {
  api_id            = aws_apigatewayv2_api.lambda.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.get_token.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_token" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /get_token"

  target = "integrations/${aws_apigatewayv2_integration.get_token.id}"
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

resource "aws_lambda_permission" "add_user_info_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_user_info.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_user_info_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_user_info.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "edit_user_info_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.edit_user_info.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

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

resource "aws_lambda_permission" "reject_order_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reject_order.function_name
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

resource "aws_lambda_permission" "report_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.report.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_reports_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_reports.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "tech_report_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tech_report.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_tech_reports_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_tech_reports.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "add_event_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_event.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_events_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_events.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "edit_event_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.edit_event.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_event_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_event.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "join_event_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.join_event.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_participations_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_participations.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "add_ride_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_ride.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_rides_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_rides.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "edit_ride_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.edit_ride.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_ride_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_ride.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "join_ride_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.join_ride.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_passengers_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_passengers.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_token_apigw_permision" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_token.function_name
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

