# Roadmap

## Milestone Gate

Each milestone should finish with:

- implementation deliverables complete
- relevant checks run
- affected docs updated
- rollback or recovery path documented for risky changes
- limitations stated clearly

## Milestone 0 - Scaffold

Goal: create the project documentation and directory structure.

Deliverables:

- agent instructions
- project, design, security, operations, and roadmap docs
- empty directories for planned services and configs

Exit criteria:

- repo structure exists
- no runtime implementation is added
- next milestone is clear

## Milestone 1 - Base Stack

Goal: run the useful off-the-shelf stack first.

Deliverables:

- Docker Compose stack
- Pi-hole
- Prometheus
- Grafana
- Alertmanager
- node_exporter
- pihole-exporter
- basic scrape config
- basic alert rules
- ntfy notification routing

Exit criteria:

- Pi-hole serves DNS
- Prometheus targets are green
- Grafana can query Prometheus
- a test alert reaches ntfy
- disk, temperature, and service-health alerts exist

## Milestone 2 - Beacon Exporter Skeleton

Goal: add the custom collector/exporter without eBPF first.

Deliverables:

- Go service exposing `/metrics`
- build instructions
- service health metric
- optional static host metadata metric
- Prometheus scrape target
- tests for metric registration or aggregation logic

Exit criteria:

- beacon starts reliably on the Pi
- metrics are visible in Prometheus
- `go test ./...` passes
- no eBPF code is required for this milestone

## Milestone 3 - First eBPF Hook

Goal: attach one simple eBPF hook and expose a derived metric.

Deliverables:

- first eBPF C program
- Go loader using `cilium/ebpf`
- documented hook point
- host-local socket or flow event metric

Exit criteria:

- beacon loads the eBPF program on the Pi
- metrics are visible in Prometheus
- visibility scope is documented
- failure mode is recoverable

## Milestone 4 - Keeper Anomaly Scoring

Goal: score DNS and traffic-derived behavior without deep learning.

Deliverables:

- Python service querying Prometheus
- entropy, NXDOMAIN ratio, new-destination rate, and baseline scoring
- `/metrics` endpoint for anomaly scores
- alert rules over scores

Exit criteria:

- keeper exposes scores per configured device or signal
- thresholds are documented
- false-positive tuning notes exist
- no auto-blocking is enabled by default

## Milestone 5 - Lookout Triage

Goal: add optional triage over high-confidence alerts.

Deliverables:

- bounded case bundle format
- local summary output
- optional LLM provider interface
- redaction and retention notes

Exit criteria:

- lookout is disabled by default
- no secrets are included in prompts or case files
- no auto-blocking is added
- summaries identify evidence and suggested checks

## Milestone 6 - Controlled Enforcement

Goal: add optional DNS-layer blocking.

Deliverables:

- explicit config flag for enforcement
- Pi-hole blocklist update path
- audit log of automated block actions
- unblock/revert procedure

Exit criteria:

- enforcement is disabled by default
- every automatic block is explainable and reversible
- operations docs include recovery steps

## Stretch - Whole-Network Traffic Visibility

Goal: move beyond DNS-first visibility.

Options:

- Pi as router/gateway
- mirrored/SPAN traffic into the Pi
- tc/XDP packet-level collector

Exit criteria:

- network topology is documented
- failure mode is understood before deployment
- DNS service remains recoverable
