# GOV.UK Pay API documentation

## Getting started

To preview or build the website, we need to use the terminal.

Install [Node.js](https://nodejs.org/en/) and in the application folder type the following :

```
./build.sh
```
and browse API documentation generated here
```
./shins/build/index.html
```

The API documentation is generated through the use of 
 - widdershins [npm module](https://www.npmjs.com/package/widdershins) to convert the
 [swagger.json](https://github.com/alphagov/pay-publicapi/blob/master/swagger/swagger.json) 
 to Markdown.
 - and a fork of [shins](https://github.com/alphagov/shins) to generate static html pages

[swagger.json](https://github.com/alphagov/pay-publicapi/blob/master/swagger/swagger.json)
file is generated from annotated classes in [publicapi](https://github.com/alphagov/pay-publicapi). 

## Making changes

To make changes, raise a 
[pull request](https://github.com/alphagov/pay-publicapi/blob/master/.github/PULL_REQUEST_TEMPLATE.md) 
with code changes that updates swagger file. 

Changes can also be previewed locally (own computer) by either passing a swagger file or http(s) url 
for raw swagger file via `PUBLIC_API_SWAGGER_SRC` envionment variable as follows:

```
PUBLIC_API_SWAGGER_SRC=[PATH_TO_LOCAL_FILE OR HTTP_URL_FOR_RAW_SWAGGER_FILE] ./build.sh
```

*Examples*
```
PUBLIC_API_SWAGGER_SRC=https://raw.githubusercontent.com/alphagov/pay-publicapi/master/swagger/swagger.json ./build.sh
PUBLIC_API_SWAGGER_SRC=/home/projects/pay-publicapi/swagger/swagger.json ./build.sh
```

You should now be able to view generated API documentation from folder /shins/build/index.html 

## Build

All files are generated as static html pages in `shins/build` folder.

