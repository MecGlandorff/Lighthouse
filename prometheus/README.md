# Prometheus

Prometheus scrape configuration, rule files, and related examples belong here.

Expected files later:

- `prometheus.yml`
- alert rule files
- optional recording rule files

Prometheus should scrape services that expose `/metrics`. Custom services should
not push directly into Prometheus.
