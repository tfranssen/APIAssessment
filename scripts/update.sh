#!/bin/bash
echo "Current version"
cat version.env | grep version 
version=$(cat version.env | grep version | awk -F "=" '{print $2}' | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
rm version.env
echo "version="$version >> version.env

echo "New version"
echo "Current version"
cat version.env | grep version 

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

echo "Updating the stack"
aws cloudformation update-stack \
  --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$version \
  ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB 
