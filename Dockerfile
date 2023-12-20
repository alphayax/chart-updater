FROM alpine/helm:3.13.3

# Install dependencies
RUN apk add --no-cache jq yq openssh-client

# Install helm-docs
RUN mkdir /tmp/helm-docs/ && \
    wget https://github.com/norwoodj/helm-docs/releases/download/v1.11.3/helm-docs_1.11.3_Linux_x86_64.tar.gz -O /tmp/helm-docs/helm-docs.tar.gz && \
    tar -xvzf /tmp/helm-docs/helm-docs.tar.gz -C /tmp/helm-docs/ && \
    install /tmp/helm-docs/helm-docs /usr/local/bin/  && \
    rm -rf /tmp/helm-docs

# Add script
COPY check-update-chart.sh /usr/local/bin/check-update-chart.sh

ENTRYPOINT ["/usr/local/bin/check-update-chart.sh"]
