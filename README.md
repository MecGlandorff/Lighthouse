# Lighthouse

Lighthouse is a Raspberry Pi based home-network observability and DNS sink
project.

Base stack:

- Pi-hole for DNS filtering
- Prometheus for metrics
- Grafana for dashboards
- Alertmanager for alerts, with ntfy as the first phone-alert path
- exporters for Pi-hole and host metrics

Later:

- `beacon`: a Go collector with eBPF C programs
- `keeper`: a Python anomaly scorer that queries Prometheus and exposes scores
  on `/metrics`
- `lookout`: optional LLM-assisted triage over bounded alert bundles
- optional DNS-layer blocking behind an explicit config flag

## Current Status

The pinned base stack, operational dashboard, baseline alerts, and ntfy route
are implemented. Raspberry Pi deployment validation is still required before
household clients use Lighthouse for DNS.

## Design Rule

Prometheus is the service boundary. Custom services expose `/metrics`, and
Prometheus scrapes them. Keeper queries the Prometheus HTTP API and exposes its
own scores on `/metrics`.

## Visibility Caveat

DNS data can cover the home network when clients use Pi-hole as DNS.

eBPF flow data covers the Pi itself unless the Pi is inline as a router/gateway
or receives mirrored traffic.

## Repository Map

- `compose/`: planned Docker Compose files
- `prometheus/`: scrape config and alert rules
- `alertmanager/`: notification routing
- `grafana/`: dashboard provisioning
- `beacon/`: planned Go/eBPF collector
- `keeper/`: planned Python anomaly scorer
- `lookout/`: planned LLM-assisted triage service
- `docs/`: coding, observability, retention, and task docs

## Current Milestone

Milestone 1 builds and validates the base stack with Pi-hole, Prometheus,
Grafana, Alertmanager, node_exporter, and pihole-exporter.

The first alert route is ntfy. The initial local retention target is 30 days for
Prometheus data and DNS query history where supported by the installed Pi-hole
version.
