# GOV.UK Pay API documentation

Preview and publish API browser for internal app APIs which include below.

- [pay-connector](https://github.com/alphagov/pay-connector)
- [pay-adminusers](https://github.com/alphagov/pay-adminusers)
- [pay-products](https://github.com/alphagov/pay-products)
- [pay-publicauth](https://github.com/alphagov/pay-publicauth)
- [pay-ledger](https://github.com/alphagov/pay-ledger)
- [pay-webhooks](https://github.com/alphagov/pay-webhooks)

API can be previewed using tech-docs-template (https://tdt-documentation.london.cloudapps.digital/) or
swagger-editor (https://editor.swagger.io/)

## Prerequisites

Requires

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) to preview docs using tech docs template
- [Docker](https://www.docker.com/) to preview API using swagger-editor
- [cf CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) to deploy
  to [PaaS](https://docs.cloud.service.gov.uk/)

## Preview

To preview API docs of an app, run the below command (which reads Open API specs from the app Github repo)

  ```shell
  ./build.sh [app] [browser]
    app - values supported: adminusers, connector, ledger, products, publicauth, webhooks
    browser - values supported: tech-docs-template, swagger 
  ```

- Example 1: (to preview connector docs using tech-docs-template)
    ```shell
    ./build.sh connector tech-docs-template
    ```
  View docs at http://localhost:4567

- Example 2: (to preview connector docs using swagger editor)
  ```shell
  ./build.sh connector swagger
  ```
  View docs at http://localhost:8080

**To use a specific branch**

- Specify the branch name or commit sha to use using BRANCH variable as below:

  Example:
  ```shell
  BRANCH=726bcbb4257f1ffe55435ee29ed0a0196d92ceb8 ./build.sh connector swagger
  ```

**To preview API docs from a local repo**

- Specify the `LOCATION=local` variable. Note that $WORKSPACE is to be set and should point to the repositories parent
  folder.

  Example:
  ```shell
  LOCATION=local ./build.sh adminusers tech-docs-template
  ```

## Publish

To publish API browser for an app, run below:

```shell
./deploy.sh [app_name]

app_name: Allowed values - adminusers, connector, products, publicauth, ledger, webhooks

```

Docs are published to

**PaaS location** : api.cloud.service.gov.uk <br>
**org** : govuk-pay <br>
**space** : sandbox <br>
**Location**: Publishes docs to URL `govuk-pay-[app_name]-api-browser.cloudapps.digital`

- Example

  ```shell
  ./deploy.sh connector
  ```

Open docs at https://govuk-pay-connector-api-browser.cloudapps.digital

Note below for the deploy:

- Only publishes using tech-docs-template
- Generates tech-docs.yml and manifest.yml required before publishing