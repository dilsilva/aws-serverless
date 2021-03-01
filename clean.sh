#!/bin/bash
echo 'What do you want to name your sam stack?'
read -r STACK_NAME

echo 'What is the region of the stack?'
read -r REGION

echo 'What is the name of the stack s3 bucket name? (Example: "vw-app-bucket")'
read -r BUCKET

echo "########################################"
echo "########################################"
echo ""
echo "Starting cleaning process"
echo ""
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"

echo ""
echo "Stack deleted successful"