#!/bin/bash
echo 'What do you want to name your sam stack? (Example: "vw-app")'
read -r STACK_NAME

echo 'What is the region of the stack? (Example: "us-east-1")'
read -r REGION

echo 'What is the name of the stack s3 bucket name? (Example: "vw-app-bucket")'
read -r S3_BUCKET

echo "########################################"
echo "########################################"
echo ""
echo "Starting cleaning process"
echo ""
echo ""
echo "Deleting S3 buckets"
echo ""
aws s3 rm s3://datastorebackup-vw --recursive
aws s3 rm s3://$S3_BUCKET --recursive
echo ""
echo "Deleting Cloudformation Stack"
echo ""
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"
echo ""
echo ""
echo "Stack deleted successful"