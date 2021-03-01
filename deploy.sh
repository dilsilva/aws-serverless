#!/bin/bash
echo "########################################"
echo 'How do you want to name your AWS SAM stack? (Example: "vw-app")'
read -r STACK_NAME

echo 'How do you want to name the stack s3 bucket name? (Example: "vw-app-bucket")'
read -r S3_BUCKET

echo 'Which region you want to deploy the stack? (Example: "us-east-1")'
read -r REGION

if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
        then echo "Bucket doesn't exists, creating bucket..." && aws s3 mb s3://$S3_BUCKET --region "$REGION"
fi

cd vw-app/

echo "########################################"
echo "########################################"
echo ""
echo "Starting deploy process using AWS SAM"
echo ""
echo "########################################"
echo ""
echo "Building..."
sam build -u
echo ""
echo "Build Finished"
echo ""
echo "########################################"
echo "Deploy..."
echo ""
sam deploy --capabilities CAPABILITY_IAM --template-file template.yaml --region "$REGION" --s3-bucket "$S3_BUCKET" --stack-name "$STACK_NAME" --config-file samconfig.toml
echo "Deploy Finished"