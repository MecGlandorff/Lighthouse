# Grafana

Grafana is provisioned with the internal Prometheus datasource and the
repository-managed `Lighthouse Operations` dashboard.

Keep dashboards focused on operational health first:

- DNS status
- query volume
- blocked query rate
- Pi CPU, memory, disk, and temperature
- alert status

Dashboard changes should be made in the repository JSON, not saved only in the
Grafana database. Provisioned dashboards are read-only in the UI.
