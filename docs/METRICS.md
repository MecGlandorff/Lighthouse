# Metrics

## Contract

Metric names, units, and labels are public contracts. Changing them requires
updating dashboards, alert rules, docs, and tests where applicable.

## Naming

Use Prometheus naming conventions:

- counters end in `_total`
- durations include a unit, such as `_seconds`
- byte counts use `_bytes`
- ratios use `_ratio`
- anomaly scores use `_score`

## Labels

Labels must have bounded cardinality.

Review before adding labels such as:

- `client`
- `device`
- `domain`
- `destination_ip`
- `asn`

Detailed labels are allowed for local development and early operation, but the
privacy and storage impact must be documented.

## Planned Custom Metrics

Beacon skeleton:

- `lighthouse_beacon_up`
- `lighthouse_beacon_build_info`

Beacon eBPF milestone:

- metric names will be defined with the hook point and visibility scope

Keeper skeleton:

- `lighthouse_keeper_up`
- `lighthouse_anomaly_score{device,signal}`

Lookout skeleton:

- `lighthouse_lookout_up`
- `lighthouse_lookout_cases_total{status}`
- `lighthouse_lookout_llm_requests_total{provider,result}`
- `lighthouse_lookout_triage_duration_seconds`

## Alert Labels

Alert labels should identify the service and severity. Alert annotations should
state the threshold and first check.

Avoid alert text that only says an anomaly occurred without naming the signal.
