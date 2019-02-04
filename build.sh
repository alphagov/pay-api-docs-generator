#!/bin/bash

set -eo pipefail

# Set up term colors
green='\033[1;32m'
red='\033[0;31m'
white='\033[1;37m'
NC='\033[0m' # No Color

# ---- clean up existing directories 
rm -rf swagger
rm -rf shins

if ! command -v node > /dev/null; then \
  echo -e "${red} Nodejs is not available, please install NodeJs (https://nodejs.org) ${NC}"
  exit 1; \
fi

if ! command -v git > /dev/null; then \
  echo -e "${red} git is not available, please install Git (https://git-scm.com) ${NC}"
  exit 1; \
fi

# -- Get shins to build static files --
git clone https://github.com/alphagov/shins.git

# -- Get Swagger file --
if [[ -z "${PUBLIC_API_BRANCH}" ]]; then
    PUBLIC_API_BRANCH="master"
else
    PUBLIC_API_BRANCH="${PUBLIC_API_BRANCH}"
fi;

if [[ -z "${PUBLIC_API_SWAGGER_URL}" ]]; then
    PUBLIC_API_SWAGGER_URL="https://raw.githubusercontent.com/alphagov/pay-publicapi/${PUBLIC_API_BRANCH}/swagger/swagger.json"
else
    PUBLIC_API_SWAGGER_URL="${PUBLIC_API_SWAGGER_URL}"
fi;

echo "Getting Swagger file from location '$PUBLIC_API_SWAGGER_URL'"
if [[ $PUBLIC_API_SWAGGER_URL == http* ]]; then
    wget -P swagger "$PUBLIC_API_SWAGGER_URL"
else
    mkdir swagger
    cp "$PUBLIC_API_SWAGGER_URL" swagger
fi;

# -- Build docs --
echo -e "${white} Converting swagger file to shins compatible markdown...${NC}"
cp source/images/govuk_pay_logo.png shins/source/images/logo.png
npm install && ./node_modules/widdershins/widdershins.js swagger/swagger.json -o shins/source/index.html.md

echo -e "${white} Building static docs...${NC}"
cd shins && npm install && node shins.js --minify

# -- Move static files to 'build' folder --
mkdir -p build/source
cp index.html build/
cp -R pub/ build/pub
cp -R source/* build/source
echo -e "${green}Built pay-api-docs static files...${NC}"
