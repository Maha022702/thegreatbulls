#!/bin/bash
# Deploy OpenSearch Query Lambda Function

set -e

echo "🚀 Deploying OpenSearch Query Lambda..."

# Configuration
FUNCTION_NAME="opensearch-query-function"
REGION="us-east-1"
OPENSEARCH_ENDPOINT="search-kite-stock-data-4phbzwci5cfo6jla7vs7yrjkcu.us-east-1.es.amazonaws.com"

# Create deployment package
echo "📦 Creating deployment package..."
cd aws-lambda
rm -f opensearch-lambda.zip
cp opensearch-package.json package.json
npm install --production
zip -r opensearch-lambda.zip opensearch-query.js node_modules package.json
rm package.json

# Create IAM role if it doesn't exist
echo "🔐 Setting up IAM role..."
ROLE_NAME="opensearch-lambda-role"
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text 2>/dev/null || echo "")

if [ -z "$ROLE_ARN" ]; then
  echo "Creating IAM role..."
  ROLE_ARN=$(aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "lambda.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }' \
    --query 'Role.Arn' \
    --output text)
  
  # Attach policies
  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
  
  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::955223516342:policy/kite-opensearch-policy
  
  echo "Waiting for role to be ready..."
  sleep 10
fi

# Create or update Lambda function
FUNCTION_EXISTS=$(aws lambda get-function --function-name $FUNCTION_NAME --region $REGION 2>/dev/null || echo "")

if [ -z "$FUNCTION_EXISTS" ]; then
  echo "📝 Creating Lambda function..."
  aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime nodejs18.x \
    --role $ROLE_ARN \
    --handler opensearch-query.handler \
    --zip-file fileb://opensearch-lambda.zip \
    --timeout 30 \
    --memory-size 512 \
    --environment Variables="{OPENSEARCH_ENDPOINT=$OPENSEARCH_ENDPOINT}" \
    --region $REGION
else
  echo "🔄 Updating Lambda function..."
  aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://opensearch-lambda.zip \
    --region $REGION
  
  aws lambda update-function-configuration \
    --function-name $FUNCTION_NAME \
    --environment Variables="{OPENSEARCH_ENDPOINT=$OPENSEARCH_ENDPOINT}" \
    --region $REGION
fi

# Create API Gateway
echo "🌐 Setting up API Gateway..."
API_NAME="opensearch-data-api"
API_ID=$(aws apigatewayv2 get-apis --region $REGION --query "Items[?Name=='$API_NAME'].ApiId" --output text)

if [ -z "$API_ID" ]; then
  echo "Creating API Gateway..."
  API_ID=$(aws apigatewayv2 create-api \
    --name $API_NAME \
    --protocol-type HTTP \
    --cors-configuration AllowOrigins="*",AllowMethods="GET,POST,OPTIONS",AllowHeaders="*" \
    --region $REGION \
    --query 'ApiId' \
    --output text)
fi

# Create integration
INTEGRATION_ID=$(aws apigatewayv2 create-integration \
  --api-id $API_ID \
  --integration-type AWS_PROXY \
  --integration-uri arn:aws:lambda:$REGION:955223516342:function:$FUNCTION_NAME \
  --payload-format-version 2.0 \
  --region $REGION \
  --query 'IntegrationId' \
  --output text 2>/dev/null || \
  aws apigatewayv2 get-integrations --api-id $API_ID --region $REGION --query 'Items[0].IntegrationId' --output text)

# Create route
aws apigatewayv2 create-route \
  --api-id $API_ID \
  --route-key 'GET /data' \
  --target integrations/$INTEGRATION_ID \
  --region $REGION 2>/dev/null || echo "Route already exists"

# Create stage
aws apigatewayv2 create-stage \
  --api-id $API_ID \
  --stage-name prod \
  --auto-deploy \
  --region $REGION 2>/dev/null || echo "Stage already exists"

# Add Lambda permission for API Gateway
aws lambda add-permission \
  --function-name $FUNCTION_NAME \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:$REGION:955223516342:$API_ID/*" \
  --region $REGION 2>/dev/null || echo "Permission already exists"

# Get API endpoint
API_ENDPOINT="https://$API_ID.execute-api.$REGION.amazonaws.com/prod/data"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "API Endpoint: $API_ENDPOINT"
echo ""
echo "Example usage:"
echo "  Recent data: $API_ENDPOINT?action=recent&limit=100"
echo "  Historical:  $API_ENDPOINT?action=historical&instrument=256265&limit=500"
echo "  Stats:       $API_ENDPOINT?action=stats"
echo ""
