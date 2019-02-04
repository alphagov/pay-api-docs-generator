#!/bin/bash

set -eo pipefail

CF="cf"
APP_NAME="govukpay-api-browser-test"

# Set up term colors
white='\033[1;37m'
green='\033[1;32m'
red='\033[0;31m'

if ! command -v ${CF} > /dev/null; then \
  echo -e "${red} ${CF} not installed, please install CloudFoundry CLI...${NC}"
  exit 1; \
fi

echo -e "${white}Pushing application to CF...${NC}"
${CF} push ${APP_NAME}
echo -e "${green}Successful deploy CF...${NC}"
