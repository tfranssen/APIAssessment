#!/bin/bash
aws s3 rb s3://$S3_BUCKET_NAME --force

aws cloudformation delete-stack \
  --stack-name=$STACK_NAME