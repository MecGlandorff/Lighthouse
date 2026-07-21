# Prometheus

`prometheus.yml` scrapes the base stack every 15 seconds and sends alerts to
Alertmanager. `rules/` contains the alert contract and `tests/` contains
`promtool` rule-unit fixtures.

Validate from the repository root on a host with Docker:

```bash
docker run --rm --entrypoint promtool \
  -v "$PWD/prometheus:/work:ro" -w /work \
  prom/prometheus:v3.13.1 check config prometheus.yml

docker run --rm --entrypoint promtool \
  -v "$PWD/prometheus:/work:ro" -w /work \
  prom/prometheus:v3.13.1 test rules tests/lighthouse-alerts.test.yml
```

The stable base-stack job names are `prometheus`, `alertmanager`, `grafana`,
`node`, and `pihole`.
