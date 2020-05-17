echo "Validating stack..."
aws cloudformation validate-template --template-body file://cloudformation.yaml

echo "Updating the stack..."
aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$version \
  ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB 
