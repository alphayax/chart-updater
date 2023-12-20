# Helm Chart Update Script
![GitHub tag (with filter)](https://img.shields.io/github/v/tag/alphayax/chart-updater)
![Docker Image](https://img.shields.io/badge/docker_image-alphayax%2Fchart--updater-blue)
![Docker Pulls](https://img.shields.io/docker/pulls/alphayax/chart-updater)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/alphayax/chart-updater/latest)


This script is used to check and update the version of a Helm chart regarding a given GitHub repository.

## Basic usage

```bash
./check-update-chart.sh       \
  --helm-repo <HELM_REPO>     \
  --github-repo <GITHUB_REPO> \
  --chart <CHART_PATH>
```

### Description

The script first checks the current application version of the chart from a given Helm repository
and the latest application version from a given GitHub repository. If the current application version
is not up-to-date, the script updates the `appVersion` and `version` fields in the `Chart.yaml` file.

### Dependencies

- [Helm](https://helm.sh)
- `jq`
- `yq`

### Parameters

  | Parameter       | Description                                                          | Required |
  |-----------------|----------------------------------------------------------------------|----------|
  | `--helm-repo`   | The Helm repository where the chart is hosted.                       | **Yes**  |
  | `--github-repo` | The GitHub repository where the Docker image is hosted.              | **Yes**  |
  | `--chart`       | The path to the local copy of the chart to check. (Default: `/apps`) | No       |

> Parameters can be omitted by using environment variables:
> - `HELM_REPO` for `--helm-repo`
> - `GITHUB_REPO` for `--github-repo`
> - `CHART_PATH` for `--chart`
 

## Docker

A Dockerfile is provided to run the script in a Docker container. The Docker image is based 
on `alpine/helm:3.13.3` and adds `jq` and `yq`.

### Docker example (with scripts parameters)

```bash
docker run alphayax/chart-updater                           \
  --helm-repo "oci://registry-1.docker.io/alphayax/medusa"  \
  --github-repo "linuxserver/docker-medusa"                 \
  --chart "/"
```

### Docker example (with environment variables)

```bash
docker run \
  -e HELM_REPO="oci://registry-1.docker.io/alphayax/medusa" \
  -e GITHUB_REPO="linuxserver/docker-medusa"                \
  -e CHART_PATH="/"                                         \
  alphayax/chart-updater
```
