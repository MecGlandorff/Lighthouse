# Beacon

Beacon is the planned Go collector/exporter.

Responsibilities:

- expose `/metrics`
- aggregate host or network telemetry
- load eBPF programs only after the exporter skeleton is working

Beacon should not call keeper directly. Prometheus is the boundary.
