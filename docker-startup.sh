#!/usr/bin/env bash

set -eu

white='\033[1;37m'
green='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${white} Converting swagger file to shins compatible markdown...${NC}"
npm install
./node_modules/widdershins/widdershins.js swagger/swagger.json -o shins/source/index.html.md


echo -e "${white} Building static docs...${NC}"
cd shins
npm install
node shins.js --minify

# -- Move static files to 'build' folder --
mkdir -p build
cp -R index.html pub source build/

echo -e "${green}Built pay-api-docs static files...${NC}"
