#!/bin/bash

set -euo pipefail

CF=cf
CF_API_URL=api.cloud.service.gov.uk
CF_SPACE=sandbox
CF_ORG=govuk-pay
ALLOWED_APP_NAMES="adminusers, cardid, connector, publicauth, products, webhooks"

# Set up term colors
green='\033[1;32m'
red='\033[0;31m'
white='\033[1;37m'
NC='\033[0m' # No Color

cd "$(dirname "$0")"

if ! command -v ${CF} >/dev/null; then
  echo -e "${red} ${CF} not installed, please install CloudFoundry CLI...${NC}" >&2
  exit 1
fi

if ! [ "$#" -eq 1 ]; then
  echo "##  Missing required params "
  echo "   - Usage : ./deploy.sh [app_name]"
  echo "         app_name - $ALLOWED_APP_NAMES "

  exit 1
fi

APP_NAME="$1"
CF_APP="govuk-pay-${APP_NAME}-api-browser"

./build.sh "$APP_NAME" tech-docs-template --build-only

cat >"manifest.yml" <<EOM
---
applications:
- name: govuk-pay-${APP_NAME}-api-browser
  memory: 64M
  path: ./build
  buildpack: staticfile_buildpack
  instances: 1
EOM

## todo: should change if the script is to be used in CI
"$CF" login \
  -a "$CF_API_URL" \
  -o "$CF_ORG" \
  -s "$CF_SPACE" --sso

echo -e "${green}Successfully logged into CF...${NC}"
echo -e "${white}Pushing application to CF...${NC}"
"$CF" push "$CF_APP"
echo -e "${green}Successful deployed to CF...${NC}"
