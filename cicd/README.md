# CICD description

For the CICD sample i would use the idea represented in what would be the definition file for Gitlab CI (famous gitlabci.yml) just for simplification propouses, but it doesn't matter, since all the tools are just manners to implement the same idea.

Explanation in code using comments:

```yaml
variables:
  S3_BUCKET: $S3_BUCKET_VALUE  #Definition of an global pipeline variable in                            
                               #order to reuse when necessary
  
stages:   #Definition of the pipeline stages to guarantee the stop of the execution if
  - build #any one presents errors.
  - test
  - deploy

build:
  image: public.ecr.aws/bitnami/aws-cli 
  stage: build
  variables:
    AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID_VALUE  #Local variables definition
    AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY_VALUE 
    AWS_DEFAULT_REGION: $AWS_REGION_VALUE 
    S3_BUCKET: $S3_BUCKET_VALUE 
  script:
    - if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket' then echo "Bucket doesn't exists, creating bucket..." && aws s3 mb s3://$S3_BUCKET --region "$REGION" fi
    - cd vw-app/
    - sam build -u #Check the bucket existence, then generate build artifact.
    
test:
  image: public.ecr.aws/aws/$some_image_with_aws_sam #It is more efficient to have available images that reduce the number of
                                                     #steps, it optimize time and use, and therefore, money (running in cloud) in 
                                                     #the long term.
  stage: test
  dependencies: #Inherit artifacts
    - build
  script: #Validating template file, since the unit tests are runned in the deploy by AWS SAM cli.
    - sam validate --profile default --config-file samconfig.toml

deploy:
  image: public.ecr.aws/aws/$some_image_with_aws_sam
  stage: deploy
  dependencies: #Inherit artifacts
    - build
  script:
    - sam deploy --capabilities CAPABILITY_IAM --template-file template.yaml --region "$REGION" --s3-bucket "$S3_BUCKET" --stack-name "$STACK_NAME" --config-file samconfig.toml

```

This is the base idea, the simplest way to deploy, that can be incremented depending of how requirements of each enviroment