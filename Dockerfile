FROM debian:buster-slim

RUN set -ex; \
    apt-get update; \
    apt-get install -y freeipmi-tools; \
    rm -rf /var/lib/apt/lists/*

# COPY ipmi_exporter /bin/ipmi_exporter
ADD https://nas-ci.oss-cn-hongkong.aliyuncs.com/dl/ipmi_exporter /bin/ipmi_exporter

EXPOSE 9290
ENTRYPOINT ["/bin/ipmi_exporter"]
CMD ["--config.file", "/config.yml"]
