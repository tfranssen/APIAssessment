#!/bin/bash

echo "Creating Bucket"
aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $S3_BUCKET_REGION --create-bucket-configuration LocationConstraint=$S3_BUCKET_REGION

echo "Upload getTemp function"
cd getTemp

npm ci
rm -f getTemp.zip  && zip -r getTemp.zip .
aws s3 cp getTemp.zip s3://$S3_BUCKET_NAME/getTemp-$version.zip
rm -f getTemp.zip
rm -f -r node_modules
cd ..

echo "Upload getAverage function"
cd getAverage

rm -f getAverage.zip  && zip -r getAverage.zip .
aws s3 cp getAverage.zip s3://$S3_BUCKET_NAME/getAverage-$version.zip
rm -f getAverage.zip
cd ..

echo "Validating stack"
aws cloudformation validate-template --template-body file://cloudformation.yaml

echo "Create stack"
aws cloudformation create-stack \
  --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$version \
  ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB 
