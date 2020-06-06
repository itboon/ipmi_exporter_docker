# Prometheus IPMI Exporter

This is an example of using Prometheus [IPMI Exporter](https://github.com/soundcloud/ipmi_exporter).

## Docker Compose configuration

`docker-compose.yml`:

``` yaml
version: '3.4'

services:
  ipmi-exporter:
    image: darren00/ipmi-exporter
    ports:
      - "9290:9290"
    volumes:
      - ./ipmi_remote.yml:/config.yml:ro
```

## IPMI exporter configuration

`ipmi_remote.yml`:

``` yaml
modules:
  default:
    # These settings are used if no module is specified, the
    # specified module doesn't exist, or of course if
    # module=default is specified.
    user: "root"
    pass: "YourPassword"
    # The below settings correspond to driver-type, privilege-level, and
    # session-timeout respectively, see `man 5 freeipmi.conf` (and e.g.
    # `man 8 ipmi-sensors` for a list of driver types).
    driver: "LAN_2_0"
    privilege: "user"
    # The session timeout is in milliseconds. Note that a scrape can take up
    # to (session-timeout * #-of-collectors) milliseconds, so set the scrape
    # timeout in Prometheus accordingly.
    timeout: 10000
    # Available collectors are bmc, ipmi, chassis, dcmi, and sel
    # If _not_ specified, bmc, ipmi, chassis, and dcmi are used
    collectors:
    - ipmi
    - sel
```

## Prometheus configuration

``` yaml
scrape_configs:
  - job_name: ipmi
    params:
      module: ["default"]
    scrape_interval: 1m
    metrics_path: /ipmi
    scheme: http
    static_config:
      targets:
        # Remote IPMI hosts.
        - 10.2.0.10
        - 10.2.0.11
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: ipmi-exporter:9290
```
