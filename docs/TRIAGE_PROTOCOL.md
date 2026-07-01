# Triage Protocol

## Scope

Lookout is optional triage, not detection or enforcement.

It receives bounded case bundles from high-confidence alerts or manual requests.
It should not process raw continuous DNS logs by default.

## Case Bundle

A case bundle should include:

- case id
- device or client
- time window
- triggered signals
- severity from deterministic rules or keeper
- bounded evidence
- redaction level

Example:

```json
{
  "case_id": "2026-06-24-kitchen-tablet-nxdomain",
  "device": "kitchen-tablet",
  "signals": ["nxdomain_ratio", "high_entropy_dns"],
  "severity": "medium",
  "time_window": "2026-06-24T02:00:00Z/2026-06-24T03:00:00Z",
  "evidence": [],
  "redaction": "local_detail"
}
```

## Rules

- disabled by default
- no auto-blocking
- no direct calls to beacon or keeper
- no raw continuous log review by default
- no secrets in prompts or case files
- cloud LLM use requires an explicit config choice

## Output

Lookout may write:

- summary
- likely explanations
- confidence notes
- suggested checks
- related dashboard or Prometheus query links

Outputs are advisory. Enforcement stays in a separate, explicit milestone.
