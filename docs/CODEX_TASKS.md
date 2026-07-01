# Codex Tasks

Use one task per Codex session.

## General Instruction

Read `AGENTS.md`, `PROJECT.md`, `ROADMAP.md`, `DESIGN.md`, `INVARIANTS.md`,
and the relevant docs before editing.

Before editing, inspect the repo and state a short plan.

Implement the smallest useful version. Do not implement future milestones
unless explicitly asked.

## Acceptance Criteria Template

Each task should end with:

- changed files listed
- checks run and result
- docs updated if contracts or operations changed
- secrets avoided
- limitations or deferred work stated

## Task 0 - Scaffold

Create the initial project scaffold.

Deliverables:

- top-level project docs
- docs directory
- empty planned service/config directories

Acceptance criteria:

- no runtime implementation is added
- roadmap identifies the next milestone

## Task 1 - Base Compose Stack

Add the first Docker Compose stack.

Deliverables:

- Pi-hole
- Prometheus
- Grafana
- Alertmanager
- node_exporter
- pihole-exporter
- example env file

Acceptance criteria:

- `docker compose config` passes
- no secrets are committed
- deployment or operations docs explain startup and DNS recovery

## Task 2 - Prometheus Rules

Add initial scrape config and alert rules.

Deliverables:

- scrape targets
- alert rules for DNS down, disk pressure, and high temperature
- docs explaining thresholds
- metric names and labels recorded in `docs/METRICS.md`

Acceptance criteria:

- Prometheus config validates where practical
- alert labels and annotations are concise

## Task 3 - Beacon Skeleton

Add the first Go collector skeleton.

Deliverables:

- Go module
- `/metrics` endpoint
- build instructions
- tests for any custom aggregation

Acceptance criteria:

- `go test ./...` passes
- Prometheus can scrape the service
- no eBPF code is added unless requested

## Task 4 - eBPF Learning Hook

Add the first eBPF hook only after the skeleton works.

Deliverables:

- minimal C eBPF program
- Go loader
- documented hook point
- metrics from observed events

Acceptance criteria:

- visibility scope is documented
- failure mode is recoverable

## Task 5 - Keeper Skeleton

Add the Python anomaly scorer skeleton.

Deliverables:

- Prometheus query client
- `/metrics` endpoint
- first simple score
- tests

Acceptance criteria:

- tests pass
- score definition is documented
- no auto-blocking is added

## Task 6 - Lookout Triage Skeleton

Add the optional triage skeleton after keeper exists.

Deliverables:

- case bundle schema
- local summary writer
- disabled-by-default config
- tests for redaction and bundle validation

Acceptance criteria:

- no provider secrets are committed
- no raw continuous logs are sent to triage
- no auto-blocking is added
- `docs/TRIAGE_PROTOCOL.md` stays current
