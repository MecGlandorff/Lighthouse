# Compose

`compose.yaml` defines the Raspberry Pi 4/5 base stack:

- Pi-hole
- Prometheus
- Grafana
- Alertmanager
- node_exporter
- pihole-exporter

## Prepare

Run these commands from the repository root on the Pi:

```bash
cp compose/.env.example compose/.env
chmod 600 compose/.env
mkdir -p compose/data/pihole
chmod +x compose/render-ntfy-secrets.sh
./compose/render-ntfy-secrets.sh
```

Replace both password placeholders and the ntfy placeholders in `compose/.env`
before rendering secrets. Do not commit the env file or generated secrets.

Validate and start the stack:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml config
docker compose --env-file compose/.env -f compose/compose.yaml pull
docker compose --env-file compose/.env -f compose/compose.yaml up -d
docker compose --env-file compose/.env -f compose/compose.yaml ps
```

## Published Interfaces

- DNS: port 53 TCP and UDP on the Pi
- Pi-hole admin: `http://PI_ADDRESS:8080/admin/`
- Grafana: `http://PI_ADDRESS:3000/`
- Prometheus: port 9090 on loopback only
- Alertmanager: port 9093 on loopback only
- exporters: Compose network only

Use SSH forwarding for the loopback-only interfaces:

```bash
ssh -L 9090:127.0.0.1:9090 -L 9093:127.0.0.1:9093 PI_USER@PI_ADDRESS
```

## Persistence

Pi-hole configuration is stored under `compose/data/pihole/` so DNS recovery
does not depend on inspecting a Docker volume. Prometheus, Alertmanager, and
Grafana use Docker-managed named volumes.

Run `docker compose down` without `--volumes` during routine recovery. Removing
volumes deletes local metrics, alert state, and Grafana state.
