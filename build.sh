#!/bin/bash
echo "Current version"
cat version.env | grep version 
version=$(cat version.env | grep version | awk -F "=" '{print $2}' | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
rm version.env
echo "version="$version >> version.env

echo "New version"
echo "Current version"
cat version.env | grep version 


echo "Validating stack..."
aws cloudformation validate-template --template-body file://cloudformation.yaml

echo "Updating the stack..."
aws cloudformation update-stack \
  --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$version \
  ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB \

echo "Updating..."

aws cloudformation wait stack-update-complete --stack-name $STACK_NAME