# Data Retention

## Sensitive Data

Lighthouse may store:

- client IPs
- device names
- queried domains
- timestamps
- alert history
- anomaly scores
- triage case summaries
- LLM request metadata if lookout is enabled

This data is local but still sensitive.

## Default Policy

Default to detailed local labels during development and early operation.

Do not sync raw DNS logs or Prometheus data to cloud storage by default.

Initial retention targets:

- Prometheus local retention: 30 days
- DNS query history: local only, target 30 days where the installed Pi-hole
  version supports it
- Alert history: local only
- Triage summaries: local only, target 30 days if lookout is enabled
- Grafana dashboards: repository-managed, no exported data snapshots by default

The exact Pi-hole retention setting must be verified against the installed
Pi-hole version during Phase 1.

## Retention Decisions

Before long-running deployment, choose:

- Pi-hole query retention
- Prometheus retention time
- whether per-client labels are kept
- whether domain labels are kept in long-term metrics
- whether triage case summaries are retained
- whether LLM request metadata is retained

Changing retention or exporting raw data requires a docs update in the same
change.

## Label Guidance

Detailed labels are useful for debugging and anomaly scoring, but they increase
privacy impact and cardinality.

Review labels before adding:

- full domain
- client IP
- device name
- destination IP
- ASN

Prefer lower-cardinality labels for dashboards and alerts when possible.
