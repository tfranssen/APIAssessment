#!/bin/bash

npm ci

rm getTemp*.zip
zip -r getTemp.zip .

aws lambda update-function-code --function-name currentTempInCovilha --zip-file fileb://getTemp.zip --output text 

