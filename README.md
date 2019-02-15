# GOV.UK Pay API documentation

## Getting started

To preview or build the website, we need to use the terminal.

Install [Node.js](https://nodejs.org/en/) and in the application folder type the following :

```
./build.sh
```
and browse API documentation generated here
```
./build/index.html
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

You should now be able to view generated API documentation from folder /build/index.html 

### Shins

A fork of [shins](https://github.com/alphagov/shins) is used in the build process. This is to ensure that the compatability is maintained with the widdershins package ([3.6.7](https://www.npmjs.com/package/widdershins/v/3.6.7)) during the build process. For any upgrades to widdershins library / shins repository, ensure to check that the API documentation is rendered correctly before publishing documentation.

## Build

All files are generated as static html pages in `/build` folder.

