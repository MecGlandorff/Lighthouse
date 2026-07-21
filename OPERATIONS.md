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

## Base Stack Commands

Run Compose commands from the repository root and always name both the env file
and Compose file explicitly:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml config
docker compose --env-file compose/.env -f compose/compose.yaml up -d
docker compose --env-file compose/.env -f compose/compose.yaml ps
docker compose --env-file compose/.env -f compose/compose.yaml logs --tail=100
```

Stop the stack without deleting state:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml down
```

Do not add `--volumes` during routine recovery.

## Base Stack Backup

Back up `compose/data/pihole/` while preserving file ownership. Inspect and back
up the named Grafana volume before upgrades that change Grafana's database
schema. Prometheus and Alertmanager state may be rebuilt unless an incident
requires preserving it.

Container versions are pinned in `compose/compose.yaml`. Upgrade one image at a
time in a reviewed commit, retain the previous tag for rollback, validate the
rendered Compose file, then inspect logs after recreation.

## ntfy Credential Rotation

Update `NTFY_TOPIC` or `NTFY_TOKEN` only in `compose/.env`, then run:

```bash
./compose/render-ntfy-secrets.sh
docker compose --env-file compose/.env -f compose/compose.yaml up -d \
  --force-recreate alertmanager
```

Confirm a firing and resolved test notification after rotation. Generated ntfy
secret files are local deployment state and must not be committed or included
in general repository backups.
