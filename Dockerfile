# Download binary file
FROM busybox:1.31 AS builder

ENV version="v1.2.0"

#ENV dlSRC="https://nas-ci.oss-cn-hongkong.aliyuncs.com/dl/ipmi_exporter-v1.2.0.linux-amd64.tar.gz"
ENV dlSRC="https://github.com/soundcloud/ipmi_exporter/releases/download/${version}/ipmi_exporter-${version}.linux-amd64.tar.gz"

RUN set -ex; \
    wget -O /tmp/exporter.tar.gz ${dlSRC}; \
    tar xf /tmp/exporter.tar.gz -C /tmp; \
    cp /tmp/ipmi_exporter*/ipmi_exporter /bin/ipmi_exporter

# Container image
FROM debian:buster-slim

RUN set -ex; \
    apt-get update; \
    apt-get install -y freeipmi-tools; \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /bin/ipmi_exporter /bin/ipmi_exporter

EXPOSE 9290
ENTRYPOINT ["/bin/ipmi_exporter"]
CMD ["--config.file", "/config.yml"]
