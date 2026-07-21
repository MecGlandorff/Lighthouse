# Alertmanager

Alertmanager groups Lighthouse alerts and sends firing and resolved
notifications to hosted ntfy.sh.

## Configure ntfy

Create a private ntfy topic and an access token with publish permission for that
topic. Set `NTFY_TOPIC` and `NTFY_TOKEN` in `compose/.env`, then render the
file-backed Compose secrets:

```bash
./compose/render-ntfy-secrets.sh
```

The helper writes only under the ignored `compose/secrets/` directory. It does
not print the topic or token. The directory is mode `0700`; its files are mode
`0644` because local Compose bind-mounts them into Alertmanager, which runs as a
non-root user. Do not copy or back up these files with repository data.

Validate the loaded configuration after the stack starts:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml exec \
  alertmanager amtool check-config /etc/alertmanager/alertmanager.yml
```

## Test notification

Add a synthetic alert with an explicit two-minute expiry:

```bash
docker compose --env-file compose/.env -f compose/compose.yaml exec \
  alertmanager amtool alert add \
  alertname=LighthouseNtfyTest service=test severity=warning \
  --end="$(date -u -d '+2 minutes' '+%Y-%m-%dT%H:%M:%SZ')" \
  --annotation=summary="Lighthouse ntfy test" \
  --annotation=description="Synthetic deployment validation alert"
```

Confirm the firing notification reaches the subscribed phone, then confirm a
resolved notification follows after the explicit expiry.
The route groups by `alertname`, `service`, and `severity`, waits 30 seconds,
regroups after 5 minutes, and repeats a still-firing group every 4 hours.

## Rotate or disable

To rotate credentials, update `compose/.env`, rerun the renderer, and recreate
Alertmanager. To disable external delivery while retaining local alert state,
replace the receiver with a local discard receiver in a reviewed change; do not
delete Prometheus rules as an emergency workaround.

Telegram and Pushover remain out of scope. Never commit notification tokens,
private topics, or generated secret files.
