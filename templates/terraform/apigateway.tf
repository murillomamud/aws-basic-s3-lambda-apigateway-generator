#------------------------------------
# API Gateway V2 Resource Creation 
#------------------------------------

resource "aws_apigatewayv2_api" "http2_api" {
  name          = "{project_name}"
  description   = "{description}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_headers = ["*"]
    allow_methods = ["*"]
  }
}


#------------------------------------
# API Gateaway V2 Deployment 
#------------------------------------

resource "aws_apigatewayv2_stage" "http2_deployment" {
  api_id      = aws_apigatewayv2_api.http2_api.id
  name        = "devl"
  auto_deploy = true
}

#------------------------------------
# API Gateway V2 DNS - API GW
#------------------------------------

# resource "aws_apigatewayv2_domain_name" "http2_api" {
#   domain_name = local.route53_domain_name
#   domain_name_configuration {
#     certificate_arn = var.certificate_arn
#     endpoint_type   = "REGIONAL"
#     security_policy = "TLS_1_2"
#   }

# }

#------------------------------------
# API Gateway V2 Mapping
#------------------------------------

# resource "aws_apigatewayv2_api_mapping" "http2_api_map" {
#   api_id      = aws_apigatewayv2_api.http2_api.id
#   domain_name = aws_apigatewayv2_domain_name.http2_api.id
#   stage       = aws_apigatewayv2_stage.http2_deployment.id
# }

#-----------------------
# Authorizer
#-----------------------
# resource "aws_apigatewayv2_authorizer" "authorizer" {
#   api_id           = aws_apigatewayv2_api.http2_api.id
#   authorizer_type  = "JWT"
#   identity_sources = ["$request.header.Authorization"]
#   name             = "jwt-authorizer"

#   jwt_configuration {
#     audience = [var.okta_audience]
#     issuer   = var.okta_issuer
#   }
# }

resource "aws_apigatewayv2_integration" "jd_met_get_private_model_embed_token_http2_api_integration" {
  api_id                 = aws_apigatewayv2_api.http2_api.id
  integration_type       = "AWS_PROXY"
  passthrough_behavior   = "WHEN_NO_MATCH"
  description            = "{description}}"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.{lambda_name}.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "jd_met_get_private_model_embed_token_http2_route" {
  api_id    = aws_apigatewayv2_api.http2_api.id
  route_key = "GET /v1/path"
  target    = "integrations/${aws_apigatewayv2_integration.jd_met_get_private_model_embed_token_http2_api_integration.id}"

#   authorizer_id      = aws_apigatewayv2_authorizer.authorizer.id
#   authorization_type = "JWT"
}

##------------------------------------
## API Gateaway V2 Lambda Permission
##------------------------------------

# Gateway permission to invoke request Lambda 
resource "aws_lambda_permission" "lambda_name" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.{lambda_name}.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.http2_api.id}/*/*/v1/*"
}

output "api_url" {
  value = aws_apigatewayv2_stage.http2_deployment.invoke_url
}