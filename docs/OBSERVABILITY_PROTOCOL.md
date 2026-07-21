# Observability Protocol

## Metrics Boundary

Prometheus is the common interface for Lighthouse services.

Custom services should expose `/metrics` and avoid private service-to-service
APIs.

Prometheus scrapes metrics. Custom services should not push directly into
Prometheus.

## Metric Requirements

Each custom metric should define:

- name
- type
- unit
- labels
- source
- retention/privacy concern

## Initial Metric Sources

- Pi-hole exporter for DNS statistics
- node_exporter for host metrics
- Prometheus, Alertmanager, and Grafana for service health
- beacon for custom telemetry
- keeper for anomaly scores
- lookout for optional triage metrics

## Alert Requirements

Alerts should explain:

- what fired
- which device or service is involved
- what threshold was crossed
- what the operator should check first

Avoid vague alert text such as `network anomaly detected` without context.

## Dashboard Requirements

Dashboards should start with operational health:

- DNS service up/down
- query volume
- blocked query rate
- Pi CPU, memory, disk, and temperature
- alert status

Security-specific panels should be added after the underlying metrics are
stable.

## Base Stack Contract

Prometheus scrapes the base stack every 15 seconds with the stable jobs
`prometheus`, `alertmanager`, `grafana`, `node`, and `pihole`.

The provisioned `Lighthouse Operations` dashboard is read-only in Grafana and
is managed from repository JSON. It shows aggregate service, DNS, and host
health. It must not display full domains, client addresses, or device names.

Initial alert thresholds are conservative: targets and DNS state wait 2
minutes, disk pressure waits 15 minutes below 15% free, and high temperature
waits 10 minutes above 75°C. Changes require matching rule tests and metrics
documentation.
