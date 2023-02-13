locals {
  source_{lambda_name} = "../build/lambdas/{lambda_name}.zip"
}


###########
# S3 Bucket Object creation
###########
resource "aws_s3_bucket_object" "{lambda_name}" {
  key    = "{lambda_name}.zip"
  bucket = aws_s3_bucket.project-bucket.id
  source = local.source_{lambda_name}
  etag   = filebase64sha256(local.source_{lambda_name})
}

###########
# Lambda Function creation
###########
resource "aws_lambda_function" "{lambda_name}" {
  source_code_hash = filebase64sha256(local.source_{lambda_name})
  s3_bucket        = aws_s3_bucket.project-bucket.id
  s3_key           = aws_s3_bucket_object.{lambda_name}.key
  function_name    = "{lambda_name}"
  role             = aws_iam_role.lambda_role.arn
  description      = "{description}"
  handler          = "lambda_function.lambda_handler"
  timeout          = 30
  memory_size      = 128
  runtime          = "python3.8"

  environment {
    variables = {
      PYTHONPATH = "/var/task/lib"
    }
  }
}

resource "aws_cloudwatch_log_group" "{lambda_name}" {
  name = "/aws/lambda/${aws_lambda_function.{lambda_name}.function_name}"
}