# Design

## System Overview

```text
Home clients
  -> Pi-hole DNS
  -> pihole-exporter
  -> Prometheus

Raspberry Pi host
  -> node_exporter
  -> Prometheus

Custom telemetry
  -> beacon exposes /metrics
  -> Prometheus

Anomaly scoring
  -> keeper queries Prometheus HTTP API
  -> keeper exposes /metrics
  -> Prometheus

Triage
  -> lookout receives bounded alert/case bundles
  -> lookout may query Prometheus HTTP API
  -> lookout writes local summaries

Prometheus
  -> queried by Grafana
  -> sends firing alerts to Alertmanager

Alertmanager
  -> ntfy
```

## Service Boundary

Prometheus is the boundary between custom services.

- beacon exposes metrics on `/metrics`
- Prometheus scrapes beacon
- keeper queries the Prometheus HTTP API
- keeper exposes score metrics on `/metrics`
- Prometheus scrapes keeper
- Grafana queries Prometheus
- Prometheus sends firing alerts to Alertmanager
- Alertmanager routes notifications to ntfy
- lookout receives bounded cases only when explicitly enabled

No custom service should depend on another custom service through direct imports,
FFI, or private APIs unless the design is explicitly changed.

## Base Stack

The base stack is Docker Compose:

- Pi-hole
- Prometheus
- Grafana
- Alertmanager
- node_exporter
- pihole-exporter

This stack should be useful before custom code exists.

## Beacon

Beacon is the custom collector.

- userspace: Go
- kernel programs: eBPF C
- metrics endpoint: `/metrics`
- first scope: Pi-local host/network telemetry

Beacon should start with simple kprobe or tracepoint telemetry before XDP.

## Keeper

Keeper is the anomaly scorer.

- language: Python
- input: Prometheus queries
- output: Prometheus metrics
- first models: rolling median, MAD, entropy, ratio thresholds
- later models: River streaming detectors

Keeper should prefer explainable baselines before more complex models.

## Lookout

Lookout is the optional triage service.

- language: Python unless implementation needs change later
- input: bounded alert or case bundles
- optional input: Prometheus HTTP API context
- output: local incident summaries

Lookout may use an LLM to summarize evidence and suggest checks. It must not
perform enforcement.

## Visibility Caveat

Pi-hole DNS data can be network-wide if clients use the Pi as DNS.

Beacon flow data is Pi-local unless the network topology sends traffic through
or to the Pi.

## Enforcement

Lighthouse is detect-only by default.

DNS-layer auto-blocking may be added later, but only behind an explicit config
flag and with an audit log and unblock procedure.
