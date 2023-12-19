#!/usr/bin/env bash

# Initialize parameters
HELM_REPO=${HELM_REPO:-""}
GITHUB_REPO=${GITHUB_REPO:-""}
CHART_PATH=${CHART_PATH:-"."}

# Parse command-line arguments
while (( "$#" )); do
  case "$1" in
    --helm-repo)
      HELM_REPO="$2"
      shift 2
      ;;
    --github-repo)
      GITHUB_REPO="$2"
      shift 2
      ;;
    --chart)
      CHART_PATH="$2"
      shift 2
      ;;
    *)
      echo "Error: Invalid argument: ${1}"
      exit 1
  esac
done

# Check if both arguments are provided
if [ -z "$HELM_REPO" ] || [ -z "$GITHUB_REPO" ]; then
    echo "Usage: $0 --chart <HELM_REPO> --repo <GITHUB_REPO>"
    exit 1
fi

echo "> Parameters:"
echo "HELM_REPO   : ${HELM_REPO}"
echo "GITHUB_REPO : ${GITHUB_REPO}"
echo " "

#HELM_REPO="oci://registry-1.docker.io/alphayax/medusa"
#GITHUB_REPO="linuxserver/docker-medusa"

CURRENT_APP_VERSION=$(helm show chart "${HELM_REPO}"  2>/dev/null | yq .appVersion)
LAST_APP_VERSION=$(curl "https://api.github.com/repos/${GITHUB_REPO}/tags" 2>/dev/null | jq -r '.[0].name')

echo "> Versions:"
echo "Current app version: ${CURRENT_APP_VERSION}"
echo "Latest app version : ${LAST_APP_VERSION}"
echo " "

# Check if app version is up to date
if [ "${CURRENT_APP_VERSION}" == "${LAST_APP_VERSION}" ]; then
  echo "App version is up to date ! Nothing to do."
  exit 0
fi


if [ ! -f "${CHART_PATH}/Chart.yaml" ]; then
  echo "FATAL: Unable to find Chart.yaml (path: ${CHART_PATH}/Chart.yaml)"
  exit 1
fi


echo "> Updating ${CHART_PATH}/Chart.yaml..."

echo "- Updating app version from ${CURRENT_APP_VERSION} to ${LAST_APP_VERSION}..."
sed -i "s/appVersion: ${CURRENT_APP_VERSION}/appVersion: ${LAST_APP_VERSION}/g" "${CHART_PATH}/Chart.yaml"

CURRENT_CHART_VERSION=$(helm show chart "${HELM_REPO}"  2>/dev/null | yq .version)
IFS=. read -r version minor patch <<EOF
${CURRENT_CHART_VERSION}
EOF

NEW_CHART_VERSION="$version.$minor.$((patch+1))"

echo "- Updating chart version from ${CURRENT_CHART_VERSION} to ${NEW_CHART_VERSION}..."
sed -i "s/version: ${CURRENT_CHART_VERSION}/version: ${NEW_CHART_VERSION}/g" "${CHART_PATH}/Chart.yaml"

echo "Done !"