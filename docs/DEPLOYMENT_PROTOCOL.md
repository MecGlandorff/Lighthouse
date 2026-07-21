# Deployment Protocol

## Scope

This document defines the deployment path for the Raspberry Pi. The base-stack
configuration exists, but a deployment is not complete until the checks below
have been run on the target Pi.

## Base Assumptions

- Raspberry Pi OS Lite 64-bit
- wired Ethernet preferred
- stable IP through router DHCP reservation or static host configuration
- SSH enabled with key-based login
- Docker and the Docker Compose plugin installed

## Secrets

Secrets must stay out of git.

Use local env files or host-level secret storage for:

- Pi-hole admin password
- ntfy topic or credentials if private
- future MaxMind/IPinfo credentials
- router credentials

## Phase 1 Deployment Order

1. Confirm SSH access and stable IP.
2. Start the Compose stack without routing household DNS through the Pi.
3. Confirm Prometheus, Grafana, and Alertmanager are reachable.
4. Confirm Prometheus targets are green.
5. Send a test ntfy alert.
6. Test one client with the Pi as DNS.
7. Move router DHCP DNS to the Pi only after single-client testing works.

## Preflight

Before starting the stack:

1. Confirm the Pi has a stable LAN address and key-based SSH still works.
2. Confirm TCP and UDP port 53 and TCP ports 8080 and 3000 are unused.
3. Copy `compose/.env.example` to `compose/.env`, set distinct strong Pi-hole
   and Grafana passwords, and set mode `0600`.
4. Create `compose/data/pihole/` and include it in the local backup plan.
5. Run `docker compose --env-file compose/.env -f compose/compose.yaml config`.

The stack does not run DHCP. Do not publish UDP port 67 or grant Pi-hole
`NET_ADMIN` for this milestone.

## Validation

For Compose changes:

```bash
docker compose config
```

After deployment, verify:

- Pi-hole serves DNS
- Prometheus can query Pi-hole and host metrics
- Grafana can query Prometheus
- Alertmanager can send an ntfy test alert
- a client can bypass Lighthouse if needed

Prometheus and Alertmanager listen only on the Pi's loopback interface. Use an
SSH tunnel when their web interfaces are needed.

## Rollback

Before DNS changes, know at least one rollback path:

- set a client DNS server manually to a public resolver
- change router DHCP DNS back to the previous resolver
- stop Pi-hole blocking without stopping DNS
- keep SSH access independent of DNS where possible

Do not deploy enforcement until rollback has been tested.

Stopping the stack for rollback must preserve data:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml down
```

Do not use `down --volumes` unless permanent data deletion is explicitly
intended and backups have been checked.
