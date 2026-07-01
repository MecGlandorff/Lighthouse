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
