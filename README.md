# Code / Cloud Challenge of the CCE Team

![](https://miro.medium.com/max/460/1*Rc1aagS8bZ3Wf0jI8kf3yg.png )

## Motivation 
This repository implements an serverless architecture that:
- Create an endpoint in AWS where data can be sent in a JSON format
- Persist the data to a datastore
- At a weekly interval, a summary file should be generated from the datastore and stored in a S3 bucket

using [AWS Serverless Application Model](https://aws.amazon.com/pt/serverless/sam/ "AWS Serverless Application Model") that deploys a AWS Lambda, API Gateway, S3 bucket and DynamoDB table in order to execute the previously mentioned demands.

## Requirements
In order to implement correctly the code, you will need to following tools, click in each link and follow the installation tutorials:
- [AWS Account 2.0+](https://aws.amazon.com/pt/premiumsupport/knowledge-center/create-and-activate-aws-account/ "AWS Account")
- [AWS CLI ](https://aws.amazon.com/pt/cli/ "AWS CLI ")
- [AWS SAM 1.13.0+](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html "AWS SAM")
- [Docker](https://www.docker.com/get-started "Docker")
- [Python 3.8+](https://www.python.org/downloads/release/python-380/ "Python 3.8+")

## Deploying the solution

### AWS CLI
Since we are working in AWS cloud environment, our first step is to configure our programactic access to the enviroment, you can follow [this tutorial](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html "this tutorial") to create your *ACCESS_KEY_ID* and *SECRET_ACCESS_KEY* that will be used next.
Using any terminal of your choice (our example handle with Unix based ones), follow the given commands to configure your access:

```shell
#Check if you're using the correct AWS CLI version.
➜ ✗ aws --version
aws-cli/2.1.22 Python/3.7.4 Darwin/19.6.0 exe/x86_64 prompt/off

#Fill the following fields with the keys that you just created using AWS console.
➜ ✗ aws configure
AWS Access Key ID [$ACCESS_KEY_ID]:
AWS Secret Access Key [$SECRET_ACCESS_KEY]:
Default region name [us-east-1]: [$REGION]
Default output format [json]: json

#After that, use the following command in order to verify if your programactic access were corretly setup, the output should produce something similar with your data
➜ ✗ aws sts get-caller-identity
{
    "UserId": "$USER_ID",
    "Account": "$ACCOUNT_ID",
    "Arn": "arn:aws:iam::$ACCOUNT_ID:user/$USER_NAME"
}
```

With AWS CLI programactic access setup, we can follow with the our serverless infrastructure implementation using **AWS SAM**

### AWS SAM
The AWS Serverless Application Model (SAM) is an open-source **framework** for building serverless applications, SAM transforms and expands the SAM syntax into AWS CloudFormation syntax, enabling you to build serverless applications faster.

#### Step 1: Template anatomy
You can read more about the template anatomy used by the framework [clicking here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-specification-template-anatomy.html "clicking here")

The directory structure will look like this (for Python implementations):
```shell
 vw-app/
   ├── README.md
   ├── events/
   │   └── event.json
   ├── source/
   │   ├── __init__.py
   │   ├── app.py            #Contains your AWS Lambda handler logic.
   │   └── requirements.txt  #Contains any Python dependencies the application requires, used for sam build
   ├── template.yaml         #Contains the AWS SAM template defining your application's AWS resources.
   └── tests/
       └── unit/
           ├── __init__.py
           └── test_handler.py
        
```
#### Step 2: Deploy your application to the AWS Cloud
This repository have the ***deploy.sh*** and ***clean.sh*** files that are scripts that will help us to quickly deploy (and clean if necessary) our code, to run they, just  anyway, for documentation propouses we will describe the whole proccess next:

```shell
➜  vwdigitalsolutions git:(main) ✗ ./deploy.sh
########################################

## This script you start asking about the name that you be used for the cloudformation stack, s3 Bucket and the region, fill it press enter.

How do you want to name your AWS SAM stack? (Example: "vw-app")
vw-app
How do you want to name the stack s3 bucket name? (Example: "vw-app-bucket")
vw-app-bucket
Which region you want to deploy the stack? (Example: "us-east-1")
us-east-1

## The script will check if the given bucket name already exists, and if not, it you create it:

Bucket doesnt exists, creating bucket...
make_bucket: vw-app-bucket
########################################
########################################

Starting deploy process using AWS SAM

########################################

## Then it will perform the build process, using the source code available in the source/ directory

Building...
Starting Build inside a container
Building codeuri: source/ runtime: python3.8 metadata: {} functions: ['CrudFunction', 'S3DynamoBackup']

Fetching amazon/aws-sam-cli-build-image-python3.8 Docker container image......
Mounting /Users/diego.silva/Documents/personal/vwdigitalsolutions/vw-app/source as /tmp/samcli/source:ro,delegated inside runtime container

Build Succeeded

Built Artifacts  : .aws-sam/build
Built Template   : .aws-sam/build/template.yaml

Commands you can use next
=========================
[*] Invoke Function: sam local invoke
[*] Deploy: sam deploy --guided

Running PythonPipBuilder:ResolveDependencies
Running PythonPipBuilder:CopySource

Build Finished

########################################

## Right after it will continue to the deploy proccess, using the definitions available on the samconfig.toml file.

Deploy...

Uploading to vw-app/05d01ecc743d17f8d01462611bcc855f  3327 / 3327  (100.00%)

	Deploying with following values
	===============================
	Stack name                   : vw-app
	Region                       : us-east-1
	Confirm changeset            : True
	Deployment s3 bucket         : vw-app-bucket
	Capabilities                 : ["CAPABILITY_IAM"]
	Parameter overrides          : {}
	Signing Profiles             : {}

Initiating deployment
=====================
CrudFunction may not have authorization defined.
Uploading to vw-app/a23ae447af24b0d495c612bc5e608e8c.template  3931 / 3931  (100.00%)

Waiting for changeset to be created..

CloudFormation stack changeset
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Operation                                         LogicalResourceId                                 ResourceType                                      Replacement
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+ Add                                             CrudFunctionPostPermissionProd                    AWS::Lambda::Permission                           N/A
+ Add                                             CrudFunctionRole                                  AWS::IAM::Role                                    N/A
+ Add                                             CrudFunction                                      AWS::Lambda::Function                             N/A
+ Add                                             DynamoDBTable                                     AWS::DynamoDB::Table                              N/A
+ Add                                             S3BackupBucket                                    AWS::S3::Bucket                                   N/A
+ Add                                             S3DynamoBackupRole                                AWS::IAM::Role                                    N/A
+ Add                                             S3DynamoBackupS3BackupEventPermission             AWS::Lambda::Permission                           N/A
+ Add                                             S3DynamoBackupS3BackupEvent                       AWS::Events::Rule                                 N/A
+ Add                                             S3DynamoBackup                                    AWS::Lambda::Function                             N/A
+ Add                                             ServerlessRestApiDeployment41175413e9             AWS::ApiGateway::Deployment                       N/A
+ Add                                             ServerlessRestApiProdStage                        AWS::ApiGateway::Stage                            N/A
+ Add                                             ServerlessRestApi                                 AWS::ApiGateway::RestApi                          N/A
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Changeset created successfully. arn:aws:cloudformation:us-east-1:518074792448:changeSet/samcli-deploy1614657326/d1b5ac76-dd61-4eef-9d12-4a0334fdff6e


Previewing CloudFormation changeset before deployment
======================================================
Deploy this changeset? [y/N]: y

2021-03-02 00:55:38 - Waiting for stack create/update to complete

CloudFormation events from changeset
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ResourceStatus                                    ResourceType                                      LogicalResourceId                                 ResourceStatusReason
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE_IN_PROGRESS                                AWS::DynamoDB::Table                              DynamoDBTable                                     -
CREATE_IN_PROGRESS                                AWS::S3::Bucket                                   S3BackupBucket                                    -
CREATE_IN_PROGRESS                                AWS::S3::Bucket                                   S3BackupBucket                                    Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::DynamoDB::Table                              DynamoDBTable                                     Resource creation Initiated
CREATE_COMPLETE                                   AWS::S3::Bucket                                   S3BackupBucket                                    -
CREATE_COMPLETE                                   AWS::DynamoDB::Table                              DynamoDBTable                                     -
CREATE_IN_PROGRESS                                AWS::IAM::Role                                    CrudFunctionRole                                  -
CREATE_IN_PROGRESS                                AWS::IAM::Role                                    S3DynamoBackupRole                                -
CREATE_IN_PROGRESS                                AWS::IAM::Role                                    CrudFunctionRole                                  Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::IAM::Role                                    S3DynamoBackupRole                                Resource creation Initiated
CREATE_COMPLETE                                   AWS::IAM::Role                                    S3DynamoBackupRole                                -
CREATE_COMPLETE                                   AWS::IAM::Role                                    CrudFunctionRole                                  -
CREATE_IN_PROGRESS                                AWS::Lambda::Function                             CrudFunction                                      -
CREATE_COMPLETE                                   AWS::Lambda::Function                             S3DynamoBackup                                    -
CREATE_COMPLETE                                   AWS::Lambda::Function                             CrudFunction                                      -
CREATE_IN_PROGRESS                                AWS::Lambda::Function                             S3DynamoBackup                                    Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::Lambda::Function                             CrudFunction                                      Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::Lambda::Function                             S3DynamoBackup                                    -
CREATE_COMPLETE                                   AWS::ApiGateway::RestApi                          ServerlessRestApi                                 -
CREATE_IN_PROGRESS                                AWS::Events::Rule                                 S3DynamoBackupS3BackupEvent                       Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::ApiGateway::RestApi                          ServerlessRestApi                                 Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::Events::Rule                                 S3DynamoBackupS3BackupEvent                       -
CREATE_IN_PROGRESS                                AWS::ApiGateway::RestApi                          ServerlessRestApi                                 -
CREATE_IN_PROGRESS                                AWS::ApiGateway::Deployment                       ServerlessRestApiDeployment41175413e9             Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::ApiGateway::Deployment                       ServerlessRestApiDeployment41175413e9             -
CREATE_IN_PROGRESS                                AWS::Lambda::Permission                           CrudFunctionPostPermissionProd                    Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::Lambda::Permission                           CrudFunctionPostPermissionProd                    -
CREATE_COMPLETE                                   AWS::ApiGateway::Deployment                       ServerlessRestApiDeployment41175413e9             -
CREATE_IN_PROGRESS                                AWS::ApiGateway::Stage                            ServerlessRestApiProdStage                        -
CREATE_IN_PROGRESS                                AWS::ApiGateway::Stage                            ServerlessRestApiProdStage                        Resource creation Initiated
CREATE_COMPLETE                                   AWS::ApiGateway::Stage                            ServerlessRestApiProdStage                        -
CREATE_COMPLETE                                   AWS::Lambda::Permission                           CrudFunctionPostPermissionProd                    -
CREATE_COMPLETE                                   AWS::Events::Rule                                 S3DynamoBackupS3BackupEvent                       -
CREATE_IN_PROGRESS                                AWS::Lambda::Permission                           S3DynamoBackupS3BackupEventPermission             Resource creation Initiated
CREATE_IN_PROGRESS                                AWS::Lambda::Permission                           S3DynamoBackupS3BackupEventPermission             -
CREATE_COMPLETE                                   AWS::Lambda::Permission                           S3DynamoBackupS3BackupEventPermission             -
CREATE_COMPLETE                                   AWS::CloudFormation::Stack                        vw-app                                            -
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CloudFormation outputs from deployed stack
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Here we can get some output information, between then, the endpoint that can be used to input data, that will be stored by the application in our DynamoDb (and backed up in S3 as well)
Outputs
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Key                 S3DynamoBackupFunction
Description         Backup Lambda Function ARN
Value               arn:aws:lambda:us-east-1:518074792448:function:vw-app-S3DynamoBackup-1SN3H4MGDESZE

Key                 S3DynamoBackupRole
Description         Implicit IAM Role created for Hello World function
Value               arn:aws:lambda:us-east-1:518074792448:function:vw-app-S3DynamoBackup-1SN3H4MGDESZE

Key                 CrudFunctionIamRole
Description         Implicit IAM Role created for Hello World function
Value               arn:aws:iam::518074792448:role/vw-app-CrudFunctionRole-O0XXF3GGIFV9

Key                 CrudFunction
Description         Post Lambda Function ARN
Value               arn:aws:lambda:us-east-1:518074792448:function:vw-app-CrudFunction-1T9BC2C8SSXAO

Key                 CrudFunctionApi
Description         API Gateway endpoint URL for Prod stage for Post function
Value               https://4xhdtr4ulb.execute-api.us-east-1.amazonaws.com/Prod/post/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Successfully created/updated stack - vw-app in us-east-1

Deploy Finished
```

To clean our infrastructure we can also use the ***clean.sh*** file as describe bellow:
```shell
➜  vwdigitalsolutions ✗ ./clean.sh
What do you want to name your sam stack? (Example: "vw-app")
vw-app
What is the region of the stack? (Example: "us-east-1")
us-east-1
What is the name of the stack s3 bucket name? (Example: "vw-app-bucket")
vw-app-bucket
########################################
########################################

Starting cleaning process

##This step will delete both our stack deployment bucket and the s3 backup buckets:
Deleting S3 buckets

delete: s3://datastorebackup-vw/dynamoDbBackupoutput.json20210302035839
delete: s3://datastorebackup-vw/dynamoDbBackupoutput.json20210302035740
delete: s3://datastorebackup-vw/dynamoDbBackupoutput.json20210302040238

##And then trigger the stack deletion to clean the other resources used
Deleting Cloudformation Stack

Stack deleted successful
```

After that, we can check using the AWS Console, for all the resources that were deployed and how they're running and interacting between each other.

All the configuration of the template.yaml file was designed to be fully dynamical, witouth the necessity of manual adjustments, and following the principle of least privilege. Implementing several concepts of **DevSecOps**.


Feel free to experiment and explore the tool using the [getting started guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html "getting started guide")


## References:
¹ aws sam documentation: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/
aws documentation: https://docs.aws.amazon.com/index.html
least privilege principle: https://www.cyberark.com/what-is/least-privilege/#:~:text=The%20principle%20of%20least%20privilege%20(PoLP)%20refers%20to%20an%20information,perform%20his%2Fher%20job%20functions.&text=Least%20privilege%20enforcement%20ensures%20the,access%20needed%20%E2%80%93%20and%20nothing%20more.