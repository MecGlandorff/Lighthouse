# Coding Standard

Lighthouse should read like a small infrastructure project: simple files,
explicit contracts, recoverable changes.

## Principles

- Prefer boring interfaces.
- Keep services loosely coupled through Prometheus.
- Keep code paths direct and testable.
- Make privilege and retention choices explicit.
- Avoid broad rewrites.

## Go

Use Go for long-running collectors and exporters.

Expected style:

- small packages
- explicit errors
- context-aware service loops
- tests for aggregation and metric behavior
- stable Prometheus metric names

## C / eBPF

Use C only for eBPF programs.

Expected style:

- minimal kernel-side logic
- bounded data structures
- userspace aggregation where practical
- documented hook points and visibility scope

## Python

Use Python for anomaly scoring, triage, and fast model iteration.

Expected style:

- typed public functions
- small modules
- tests for signal calculations and scoring
- explainable baselines before complex models
- tests for case-bundle validation and redaction when triage is added

## Config

Configuration should be explicit and reproducible.

Do not commit secrets. Provide examples with placeholder values instead.

## Metrics

Metric names and labels are contracts. Keep label cardinality bounded and
document privacy-sensitive labels.
