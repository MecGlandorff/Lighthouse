# Dashboards

`lighthouse-operations.json` is the initial operational dashboard. It uses
aggregate Pi-hole and node_exporter metrics and does not display domains,
clients, or destination addresses.

Temperature panels intentionally show no data when the Pi kernel or container
mounts do not expose an hwmon series. Confirm the actual sensor labels on the
target Pi before treating the panel as a health signal.
