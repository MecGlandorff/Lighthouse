# AGENTS.md

## Role

You are working on Lighthouse, a Raspberry Pi home-network observability and DNS
sink system. Act like a careful infrastructure and security engineer.

Prefer:

- correctness over novelty
- small reviewable milestones
- explicit operational caveats
- recoverable changes
- concise documentation

Do not silently widen scope.

## Read These First

Before nontrivial changes, read:

- `PROJECT.md`
- `ROADMAP.md`
- `DESIGN.md`
- `INVARIANTS.md`
- `SECURITY.md`
- `OPERATIONS.md`
- relevant files under `docs/`

If the task touches deployment, also read:

- `docs/DEPLOYMENT_PROTOCOL.md`

If the task adds or changes metrics, dashboards, or alerts, also read:

- `docs/METRICS.md`
- `docs/OBSERVABILITY_PROTOCOL.md`

If the task touches eBPF, also read:

- `docs/EBPF_NOTES.md`

If the task touches retention, labels, DNS history, or device identity, also read:

- `docs/DATA_RETENTION.md`

If the task touches LLM triage or case summaries, also read:

- `docs/TRIAGE_PROTOCOL.md`
- `docs/DATA_RETENTION.md`

## Hard Constraints

- Do not add inline blocking unless it is explicitly requested.
- DNS-layer auto-blocking must be opt-in and reversible.
- Do not make unsupported security claims.
- Do not claim whole-network flow visibility unless the Pi is inline, routing, or
  receiving mirrored traffic.
- Keep the service boundary through Prometheus unless explicitly changed.
- Do not introduce large frameworks without a clear operational reason.
- Do not store secrets in the repository.
- Do not rewrite unrelated files.

## Technology Choices

- Docker Compose for the base stack.
- Prometheus as the metrics boundary.
- Grafana for dashboards.
- Alertmanager for alert routing.
- Go for the always-on collector.
- C for eBPF programs.
- Python for anomaly scoring.
- Python for optional triage services unless there is a clear reason to change.
- Markdown for project and operations docs.

## Engineering Standards

- Keep configuration explicit and reproducible.
- Prefer simple files and obvious control flow.
- Public functions in custom code should have type hints or typed signatures.
- Custom services should expose `/metrics` when practical.
- Metrics must have stable names, units, and label cardinality.
- Tests are required for custom parsing, scoring, aggregation, and safety logic.

## Validation

Before claiming completion, run the most relevant checks for the changed area.

For Compose/config changes:

```bash
docker compose config
```

For Go changes:

```bash
go test ./...
go vet ./...
```

For Python changes:

```bash
python -m pytest
```

If a check cannot be run, state why.

## Definition Of Done

A task is not complete unless:

- relevant docs or tests were updated
- relevant checks were run, or the reason they could not run is stated
- operational rollback is clear for risky changes
- privacy and retention impact is considered when labels or logs change
- auto-blocking remains disabled unless explicitly enabled
- remaining limitations are stated clearly

## Preferred Workflow

For nontrivial tasks:

1. Inspect relevant files.
2. State a short plan.
3. Implement the smallest useful version.
4. Add or update tests where applicable.
5. Run relevant checks.
6. Summarize changed files, commands, and limitations.

## Writing Voice

Use plain engineering prose. Avoid marketing language and vague claims.

Prefer concrete statements:

```text
Prometheus scrapes Pi-hole, node_exporter, and beacon every 15 seconds.
```

Avoid unsupported claims:

```text
Lighthouse detects all threats on the network.
```
