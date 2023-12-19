FROM alpine/helm:3.13.3

RUN apk add --no-cache jq yq openssh-client

COPY check-update-chart.sh /usr/local/bin/check-update-chart.sh

ENTRYPOINT ["/usr/local/bin/check-update-chart.sh"]
