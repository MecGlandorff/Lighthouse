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

## Base Stack Metrics

The first dashboard and alerts depend on these external metric contracts:

| Metric | Type and unit | Labels used | Source | Purpose |
| --- | --- | --- | --- | --- |
| `up` | gauge, boolean | `job`, `instance` | Prometheus | scrape health |
| `pihole_status` | gauge, boolean | `job`, `instance` | pihole-exporter | DNS enabled state |
| `pihole_dns_queries_today` | gauge, queries | `job` | pihole-exporter | daily query count and short-term rate |
| `pihole_ads_blocked_today` | gauge, queries | `job` | pihole-exporter | blocked-query percentage |
| `node_cpu_seconds_total` | counter, seconds | `job`, `mode`, `cpu` | node_exporter | CPU use |
| `node_memory_MemAvailable_bytes` | gauge, bytes | `job`, `instance` | node_exporter | memory use |
| `node_memory_MemTotal_bytes` | gauge, bytes | `job`, `instance` | node_exporter | memory use |
| `node_filesystem_avail_bytes` | gauge, bytes | `job`, `instance`, `mountpoint`, `fstype` | node_exporter | root disk use |
| `node_filesystem_size_bytes` | gauge, bytes | `job`, `instance`, `mountpoint`, `fstype` | node_exporter | root disk use |
| `node_hwmon_temp_celsius` | gauge, degrees Celsius | `job`, `instance`, `chip`, `sensor` | node_exporter | Pi temperature |

The stable base-stack jobs are `prometheus`, `alertmanager`, `grafana`, `node`,
and `pihole`. The target Pi must confirm the actual hwmon labels; an absent
temperature series is treated as no data.

## Base Alerts

| Alert | Condition | Duration | Severity |
| --- | --- | --- | --- |
| `LighthouseTargetDown` | selected `up` series equals 0 | 2 minutes | warning |
| `LighthouseDNSDisabled` | `pihole_status` equals 0 | 2 minutes | critical |
| `LighthouseRootDiskPressure` | root filesystem below 15% available | 15 minutes | warning |
| `LighthouseHighTemperature` | maximum hwmon temperature above 75°C | 10 minutes | warning |

Base alerts use only bounded `service`, `severity`, `job`, `instance`, and host
metric labels. They do not attach domains, clients, or DNS query details.

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
