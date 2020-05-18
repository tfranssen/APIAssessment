# APIAssessment

Assessment using AWS Lambda + API Gateway + Cloud Formation + MongoDB Atlas + Github Actions. 

## Initialize
Run from terminal:
```
export $(cat config.env | xargs) && sh ./scripts/create.sh
```

This scripts creates S3 bucket, uploads functions and creates stack using Cloud Formation template. 

#### config.env contains veriables:
- `STACK_NAME` Stack name
- `S3_BUCKET_NAME` S3 bucket name
- `S3_BUCKET_REGION`  AWS Region
- `URI_MONGO_DB`  URI of Mongo Atlas

## Update
Updating is done using Git Actions. An update workflow is started after each push to master branch.

## Delete
Run from terminal:
```
export $(cat config.env | xargs) && sh ./scripts/delete.sh
```
# Function description

## getTemp function (/currenttempincovilha)
I chose Yahoo weather service because it doesn't need a key and it shows the publication date. Furthermore I chose to work with the mongoist library because it is more easy to use using async function. The data is written to MongoDB Atlas as:
```
timestamp: 1589468430 \\current timestamp
pubdate: 1589464800 \\timestamp of publication
temp:12 \\temp in c
```
## averageTemp function (/avgtempinsfax)
This function returns static values

