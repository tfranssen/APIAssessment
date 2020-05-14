#!/bin/bash

rm -r node_modules/

npm ci

rm getTemp*.zip
zip -r getTemp.zip .
