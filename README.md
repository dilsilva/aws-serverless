# vwdigitalsolutions
#####
#####
#####

TO DO

Description for all resources
Name for all resources
template.yaml LINE 56: adjust dynamical input on Schedule function <<<
Backup Object result with generated datatime (scheduler.py)

documentate
.sh script of creation and cleaning
Functional tests 

#####
#####
#####

Step 1 > Requirements:
aws-cli (doc and download)
use aws sam (doc and how download)
version: python 3.8 (pyenv in case )


sam deploy --resolve-s3 --profile personal --region us-east-1 --stack-name vw-stack --config-file samconfig.toml
aws cloudformation delete-stack --stack-name sam-app --region region

Step 2 >  Challenge and Technologies applied:
 Create an endpoint in AWS where data can be sent in a JSON format
 The endpoint must persist the data to a datastore
 At a weekly interval, a summary file should be generated from the datastore and stored in a S3 bucket

Why:
    AWS SAM?
    DynamoDB?
    S3?
    Python?

Step 3 > Execution

References:
https://v1.cicd.serverlessworkshops.io/
https://docs.aws.amazon.com/index.html

