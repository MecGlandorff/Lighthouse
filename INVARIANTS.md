# Invariants

This file records contracts that should not drift silently.

If one changes, update implementation, tests, and docs in the same change.

## Service Boundary

- Prometheus is the integration boundary between beacon, keeper, dashboards,
  and alerts.
- Custom services expose `/metrics` rather than calling each other directly.
- Prometheus scrapes custom service metrics.
- Keeper may query the Prometheus HTTP API and must expose its own scores on
  `/metrics`.
- Lookout may query Prometheus for triage context but must not call beacon or
  keeper directly.

## Visibility

- DNS metrics may be described as network-wide only when clients use Pi-hole as
  DNS.
- eBPF flow metrics may be described as whole-network only when the Pi is
  inline, routing, or receiving mirrored traffic.

## Enforcement

- Auto-blocking is disabled by default.
- Auto-blocking requires an explicit config flag.
- Every automated block action must be logged and reversible.
- Lookout must not perform enforcement.

## Triage

- Lookout is disabled by default.
- Lookout receives bounded alert or case bundles, not raw continuous logs.
- Cloud LLM use requires an explicit config choice.
- Triage output is advisory.

## Metrics

- Metric names, units, and labels are part of the public contract.
- Label cardinality must be considered before adding labels.
- Device, client, domain, and IP labels affect privacy and retention.

## Secrets

- Secrets must not be committed.
- Tokens, passwords, API keys, and notification credentials belong in local env
  files or secret stores excluded from git.

## Operations

- The Pi must remain reachable after configuration changes.
- DNS recovery steps must be documented before risky changes.
- Custom code failure must not make Pi-hole unrecoverable.
