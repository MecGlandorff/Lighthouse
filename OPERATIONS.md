# Operations

## Operating Model

Lighthouse should run as a small always-on Raspberry Pi service.

The system should be understandable enough to recover without reading custom
code first.

## Basic Recovery Priorities

1. Keep SSH access.
2. Restore DNS service.
3. Restore Prometheus and dashboards.
4. Restore Alertmanager and ntfy alerts.
5. Restart custom services.

## DNS Recovery

Before making DNS changes, know how to bypass Lighthouse:

- set a client manually to a public resolver
- change the router DHCP DNS setting back
- stop Pi-hole blocking if needed

## Backup Targets

Back up:

- Compose files
- Prometheus config and alert rules
- Grafana dashboards and provisioning
- Pi-hole configuration
- local secrets separately from git

Prometheus time-series data may be treated as rebuildable unless a milestone
explicitly requires preserving history.

The initial local retention target is 30 days.

## Upgrade Discipline

Change one layer at a time:

1. configs
2. base stack
3. beacon
4. keeper
5. enforcement

For risky changes, write the rollback command or manual recovery step before
deployment.
