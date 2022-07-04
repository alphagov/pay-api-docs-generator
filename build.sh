#!/bin/bash
set -eu

ALLOWED_APP_NAMES="adminusers, connector, ledger, publicauth, products, webhooks"

cd "$(dirname "$0")"

if [ "$#" -lt 2 ]; then
  echo "##  Missing required params "
  echo "   - Usage : ./build.sh [app_name] [browser] --build-only"
  echo "         app_name - $ALLOWED_APP_NAMES "
  echo "         browser  - tech-docs-template, swagger "
  echo "         --build-only  - use to build tech docs "

  exit 1
fi

# ---- clean up existing directories
rm -rf build config

APP_NAME="$1"
BROWSER="$2"

if [ "${LOCATION-''}" = "local" ]; then

  APP_PATH="$WORKSPACE/pay-${APP_NAME}"
  APP_API_SPEC_PATH="$WORKSPACE/pay-${APP_NAME}/openapi/${APP_NAME}_spec.yaml"

  if ! [ -f "$APP_API_SPEC_PATH" ]; then
    echo "OpenAPI specs file does not exist locally. Check that you have \$WORKSPACE configured to projects and the repository cloned to \$WORKSPACE"
    exit 1
  fi
else
  APP_API_SPEC_PATH="https://raw.githubusercontent.com/alphagov/pay-${APP_NAME}/${BRANCH:-master}/openapi/${APP_NAME}_spec.yaml"
fi

echo "Using open API specs path - $APP_API_SPEC_PATH"

if ! [[ "${APP_NAME}" = "adminusers" || "${APP_NAME}" = "connector" || "${APP_NAME}" = "ledger" ||
  "${APP_NAME}" = "publicauth" || "${APP_NAME}" = "products" || "${APP_NAME}" = "webhooks" ]]; then
  echo "## Invalid app name."
  echo "     - Use one of ($ALLOWED_APP_NAMES) "
  exit 1
fi

if ! [[ "${BROWSER}" = "tech-docs-template" || "${BROWSER}" = "swagger" ]]; then
  echo "## Invalid browser "
  echo "     - Invalid browser. Use one of tech-docs-template, swagger"
  exit 1
fi

# ------------ tech-docs-template -----------------

if [[ "${BROWSER}" = "tech-docs-template" ]]; then

  TECH_DOCS_CONFIG_FILE=config/tech-docs.yml
  mkdir "config"

  cat >"$TECH_DOCS_CONFIG_FILE" <<EOM
host: govuk-pay-${APP_NAME}-api-browser

show_govuk_logo: true
service_name: Pay ${APP_NAME} API
service_link: /
header_links:
  API reference: index.html
enable_search: false
multipage_nav: true
collapsible_nav: true
max_toc_heading_level: 3
prevent_indexing: false

show_contribution_banner: false
github_repo: alphagov/pay-${APP_NAME}

api_path: ${APP_API_SPEC_PATH}

EOM

  if [[ "$#" -eq 3 && "$3" = "--build-only" ]]; then
    bundle install && bundle exec middleman build
  else
    bundle install && bundle exec middleman server
  fi
fi

# ------------ swagger -----------------
# image sha - 13Jun22

if [[ "${BROWSER}" = "swagger" ]]; then
  if ! command -v docker >/dev/null; then
    echo -e "## Docker is not installed. Install Docker - (https://www.docker.com/) ${NC}" >&2
    exit 1
  fi

  if docker ps | awk -v app="swagger_editor" 'NR > 1 && $NF == app{ret=1; exit} END{exit !ret}'; then
    docker rm -f swagger_editor >/dev/null
  fi

  echo "Starting swagger editor on port 8080"

  if [ "${LOCATION:-}" = "local" ]; then
    echo "Using local file"
    docker run -d --name swagger_editor -p 8080:8080 -v ${APP_PATH}:/tmp -e SWAGGER_FILE="/tmp/openapi/${APP_NAME}_spec.yaml" swaggerapi/swagger-editor@sha256:c2170406e1be1d2939eaaf678737552e349782a64a28bd01ee55cf129c5bd749
  else
    docker run -d --name swagger_editor -p 8080:8080 -e URL="${APP_API_SPEC_PATH}" swaggerapi/swagger-editor@sha256:c2170406e1be1d2939eaaf678737552e349782a64a28bd01ee55cf129c5bd749
  fi
  echo "Open swagger editor at http://localhost:8080"
fi
