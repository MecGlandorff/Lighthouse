# Deployment Protocol

## Scope

This document defines the deployment path for the Raspberry Pi. It is a protocol
for future implementation, not a completed setup.

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

## Rollback

Before DNS changes, know at least one rollback path:

- set a client DNS server manually to a public resolver
- change router DHCP DNS back to the previous resolver
- stop Pi-hole blocking without stopping DNS
- keep SSH access independent of DNS where possible

Do not deploy enforcement until rollback has been tested.
