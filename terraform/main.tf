resource "random_string" "random" {
  length = 6
  lower = true
  special = false
  numeric = false
  upper = false
}

#========================= Hackathon_s3_resources ------------------------------------------------>
resource "aws_s3_bucket" "hackathon_s3_bucket" {
  bucket = "${var.hack_s3_bucket}-${random_string.random.result}"

  tags = var.hackathon_tags
}

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.hackathon_s3_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.hackathon_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [ aws_lambda_function.hackathon_lambda,aws_s3_bucket.hackathon_s3_bucket ]
}


#========================= Lambda Resources------------------------------------------------------->


#Iam Role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "role_hack_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = "iam_policy_for_lambda_role" 
  role = aws_iam_role.iam_for_lambda.id


  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ses:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Action": [
			"dynamodb:GetItem",
			"dynamodb:PutItem"
        ],
        "Effect": "Allow",
        "Resource": "*"

    }
  ]
}
EOF
}

resource "aws_lambda_permission" "hackathon_lamba_permission_for_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hackathon_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.hackathon_s3_bucket.id}"
}

resource "aws_lambda_function" "hackathon_lambda" {
  filename      = var.lambda_src_code_path
  function_name = var.hack_lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256(var.lambda_src_code_path)

  runtime = "python3.9"

  environment {
    variables = {
      table_name = var.dynamodb_table_name
      s3_bucket =aws_s3_bucket.hackathon_s3_bucket.id
    }
  }
}


#========================= Dynamo_DB Resources ---------------------------------------------------------------->
resource "aws_dynamodb_table" "hackathon-dynamodb-table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = var.dynamodb_table_attb.primary_key
  range_key      = var.dynamodb_table_attb.secondry_key

  attribute {
    name = var.dynamodb_table_attb.primary_key
    type = "N"
  }

  attribute {
    name = var.dynamodb_table_attb.secondry_key
    type = "S"
  }


  tags = var.hackathon_tags
}
