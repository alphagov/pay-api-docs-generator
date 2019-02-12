#!/bin/bash

set -euo pipefail

# Set up term colors
red='\033[0;31m'
NC='\033[0m' # No Color

cd "$(dirname "$0")"

# ---- clean up existing directories 
rm -rf swagger

if ! command -v docker > /dev/null; then
  echo -e "${red} Docker is not available, please install Docker (https://www.docker.com/) ${NC}" >&2
  exit 1
fi

if ! command -v git > /dev/null; then
  echo -e "${red} git is not available, please install Git (https://git-scm.com) ${NC}" >&2
  exit 1
fi

# -- Get shins to build static files --
rm -rf shins && git clone https://github.com/alphagov/shins.git

# -- Get Swagger file --
: "${PUBLIC_API_SWAGGER_SRC:=https://raw.githubusercontent.com/alphagov/pay-publicapi/${PUBLIC_API_BRANCH:-master}/swagger/swagger.json}"

echo "Getting Swagger file from location '$PUBLIC_API_SWAGGER_SRC'"
if [ "${PUBLIC_API_SWAGGER_SRC:0:4}" == http ]; then
    wget -P swagger "$PUBLIC_API_SWAGGER_SRC"
else
    mkdir -p swagger
    cp "$PUBLIC_API_SWAGGER_SRC" swagger/
fi

cp source/images/govuk_pay_logo.png shins/source/images/logo.png

# -- Build docs inside docker container --
IMAGE_ID=$(docker build . 2>/dev/null | awk '/Successfully built/{print $NF}')
echo "Built docker image (ID ${IMAGE_ID})"
docker run --rm -v "$(pwd)":/app "$IMAGE_ID"
docker image rm "$IMAGE_ID"
