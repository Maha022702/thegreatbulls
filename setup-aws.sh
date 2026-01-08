#!/bin/bash

# AWS Configuration
REGION="ap-south-1"
FUNCTION_NAME="thegreatbulls-ticks-api"
TABLE_NAME="thegreatbulls-ticks"
CANDLES_TABLE="thegreatbulls-candles"
ROLE_NAME="thegreatbulls-lambda-role"
API_NAME="thegreatbulls-api"

echo "=== Setting up AWS Infrastructure for TheGreatBulls ==="

# 1. Create DynamoDB Tables
echo "Creating DynamoDB tables..."

# Ticks table - stores raw tick data
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions \
    AttributeName=token,AttributeType=N \
    AttributeName=timestamp,AttributeType=N \
  --key-schema \
    AttributeName=token,KeyType=HASH \
    AttributeName=timestamp,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION \
  2>/dev/null || echo "Table $TABLE_NAME may already exist"

# Enable TTL on ticks table
aws dynamodb update-time-to-live \
  --table-name $TABLE_NAME \
  --time-to-live-specification "Enabled=true, AttributeName=ttl" \
  --region $REGION \
  2>/dev/null || echo "TTL may already be enabled"

# Candles table - stores aggregated OHLC data
aws dynamodb create-table \
  --table-name $CANDLES_TABLE \
  --attribute-definitions \
    AttributeName=token_interval,AttributeType=S \
    AttributeName=timestamp,AttributeType=N \
  --key-schema \
    AttributeName=token_interval,KeyType=HASH \
    AttributeName=timestamp,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION \
  2>/dev/null || echo "Table $CANDLES_TABLE may already exist"

# Enable TTL on candles table
aws dynamodb update-time-to-live \
  --table-name $CANDLES_TABLE \
  --time-to-live-specification "Enabled=true, AttributeName=ttl" \
  --region $REGION \
  2>/dev/null || echo "TTL may already be enabled"

echo "Waiting for tables to be active..."
aws dynamodb wait table-exists --table-name $TABLE_NAME --region $REGION
aws dynamodb wait table-exists --table-name $CANDLES_TABLE --region $REGION

# 2. Create IAM Role for Lambda
echo "Creating IAM role..."

TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}'

aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document "$TRUST_POLICY" \
  2>/dev/null || echo "Role may already exist"

# Attach policies
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Create DynamoDB policy
DYNAMODB_POLICY='{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:BatchWriteItem",
      "dynamodb:Scan"
    ],
    "Resource": [
      "arn:aws:dynamodb:'$REGION':*:table/'$TABLE_NAME'",
      "arn:aws:dynamodb:'$REGION':*:table/'$CANDLES_TABLE'"
    ]
  }]
}'

aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name DynamoDBAccess \
  --policy-document "$DYNAMODB_POLICY"

echo "Waiting for role to propagate..."
sleep 10

# 3. Package and deploy Lambda
echo "Packaging Lambda function..."
cd aws-lambda
npm install --production
zip -r ../lambda.zip .
cd ..

# Get role ARN
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text)

echo "Deploying Lambda function..."
aws lambda create-function \
  --function-name $FUNCTION_NAME \
  --runtime nodejs20.x \
  --role $ROLE_ARN \
  --handler index.handler \
  --zip-file fileb://lambda.zip \
  --timeout 30 \
  --memory-size 256 \
  --region $REGION \
  2>/dev/null || aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://lambda.zip \
    --region $REGION

# 4. Create API Gateway
echo "Creating API Gateway..."

# Create HTTP API
API_ID=$(aws apigatewayv2 create-api \
  --name $API_NAME \
  --protocol-type HTTP \
  --cors-configuration AllowOrigins='*',AllowMethods='*',AllowHeaders='*' \
  --region $REGION \
  --query 'ApiId' --output text 2>/dev/null)

if [ -z "$API_ID" ]; then
  API_ID=$(aws apigatewayv2 get-apis --region $REGION \
    --query "Items[?Name=='$API_NAME'].ApiId" --output text)
fi

echo "API ID: $API_ID"

# Create Lambda integration
LAMBDA_ARN=$(aws lambda get-function --function-name $FUNCTION_NAME --region $REGION \
  --query 'Configuration.FunctionArn' --output text)

INTEGRATION_ID=$(aws apigatewayv2 create-integration \
  --api-id $API_ID \
  --integration-type AWS_PROXY \
  --integration-uri $LAMBDA_ARN \
  --payload-format-version 2.0 \
  --region $REGION \
  --query 'IntegrationId' --output text 2>/dev/null)

# Create routes
aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key "GET /health" \
  --target "integrations/$INTEGRATION_ID" \
  --region $REGION 2>/dev/null

aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key "POST /ticks" \
  --target "integrations/$INTEGRATION_ID" \
  --region $REGION 2>/dev/null

aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key "GET /ticks/{token}" \
  --target "integrations/$INTEGRATION_ID" \
  --region $REGION 2>/dev/null

aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key "POST /candles" \
  --target "integrations/$INTEGRATION_ID" \
  --region $REGION 2>/dev/null

aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key "GET /candles/{token}" \
  --target "integrations/$INTEGRATION_ID" \
  --region $REGION 2>/dev/null

# Create stage and deploy
aws apigatewayv2 create-stage \
  --api-id $API_ID \
  --stage-name prod \
  --auto-deploy \
  --region $REGION 2>/dev/null

# Add Lambda permission
aws lambda add-permission \
  --function-name $FUNCTION_NAME \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:$REGION:*:$API_ID/*" \
  --region $REGION 2>/dev/null

# Get API endpoint
API_ENDPOINT="https://$API_ID.execute-api.$REGION.amazonaws.com/prod"

echo ""
echo "=== Setup Complete ==="
echo "API Endpoint: $API_ENDPOINT"
echo ""
echo "Save this endpoint for your Flutter app!"
echo "Update lib/live_market_data_widget.dart with:"
echo "const API_URL = '$API_ENDPOINT';"

# Clean up
rm -f lambda.zip
