#!/bin/bash

npm ci

rm getTemp*.zip
zip -r getTemp.zip .

Version=$(md5 -b CurrentTempFunction.zip | awk '{print $1}')

aws lambda update-function-code --function-name currentTempInCovilha --zip-file fileb://getTemp.zip --output text &> /dev/null

echo $Version

