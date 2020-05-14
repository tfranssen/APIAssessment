#!/bin/bash

npm ci

rm getTemp*.zip
zip -r getTemp.zip .
