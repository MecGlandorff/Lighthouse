# Lighthouse

## One-Line Description

Lighthouse is a Raspberry Pi based home-network observability and DNS sink
system with optional anomaly scoring.

## Goal

Build a compact, understandable system that provides DNS filtering, local
metrics, dashboards, alerts, and later custom telemetry, anomaly scoring, and
bounded triage.

## Project Character

Lighthouse is a practical homelab service with portfolio-grade
observability/security scope. Keep the implementation concise and the operating
rules strict.

## Non-Goals

Lighthouse is not trying to:

- replace a commercial firewall
- inspect encrypted payloads
- promise full threat detection
- silently block traffic by default
- collect household browsing history without a documented retention policy
- pretend Pi-local eBPF traffic is whole-network visibility

## Core Design Choice

Services communicate through Prometheus metrics and the Prometheus HTTP API.

```text
beacon exposes /metrics -> Prometheus scrapes beacon
keeper queries Prometheus HTTP API
keeper exposes /metrics -> Prometheus scrapes keeper
Grafana queries Prometheus
Prometheus alert rules -> Alertmanager -> ntfy
```

This keeps the Go collector, Python anomaly scorer, dashboards, and alerts
loosely coupled.

## Main Components

- Pi-hole for DNS sinkholing
- Prometheus for metrics storage and queries
- Grafana for dashboards
- Alertmanager for notifications, with ntfy as the first phone-alert path
- node_exporter for host metrics
- pihole-exporter for Pi-hole metrics
- beacon for custom Go/eBPF telemetry
- keeper for Python anomaly scoring
- lookout for optional LLM-assisted triage over bounded case bundles

## Honest Visibility Model

DNS visibility can cover the home network when clients use Pi-hole as DNS.

eBPF flow visibility covers the Pi itself unless the Pi is placed inline as a
router/gateway or receives mirrored traffic from the network.

## Success Standard

Lighthouse is successful if it is useful day to day, clear to recover, honest
about what it observes, reproducible from configuration, and extensible through
small custom services.
