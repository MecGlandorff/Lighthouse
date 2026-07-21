# Security

## Security Posture

Lighthouse is a home-network visibility and DNS filtering system. It is not a
complete firewall or intrusion-prevention system.

## Sensitive Data

DNS logs can reveal household behavior. Treat client names, IP addresses,
domains, and timestamps as sensitive local data.

Default posture:

- store data locally
- document retention
- do not sync logs to cloud storage by default
- do not commit logs, database files, secrets, or generated metrics snapshots

The initial retention target is 30 days for local Prometheus data and local DNS
query history where supported by the installed Pi-hole version.

## Privileges

Pi-hole needs DNS ports.

Beacon may need elevated privileges for eBPF loading. Keep those privileges as
narrow as the platform allows and document the chosen deployment mode before
enabling it on the Pi.

## Enforcement

Lighthouse starts detect-only.

DNS-layer blocking is the only planned enforcement path before any inline
gateway work. It must be:

- opt-in
- logged
- explainable
- reversible

Lookout triage is advisory and must not perform enforcement.

## LLM Triage

Lookout is disabled by default.

If enabled, it receives bounded alert or case bundles. Do not send secrets, raw
continuous logs, or private host inventory to a cloud LLM by default.

## Alerting

The first supported phone-alert path is ntfy through Alertmanager.

The hosted ntfy route sends alert labels and annotations outside the home
network. Base alerts contain service and aggregate host-health context only.
Do not add client addresses, domains, DNS queries, device names, secrets, or
private inventory to alert labels or annotations.

The ntfy topic, publish token, and rendered webhook URL are secrets. Keep their
source values in the ignored local env file and generated values under the
ignored `compose/secrets/` directory.

Telegram and Pushover are optional later integrations. Do not add them until
ntfy is working or there is a clear reason to choose a different route.

## Secrets

Do not commit:

- Pi-hole admin passwords
- ntfy, Telegram, or Pushover credentials
- MaxMind/IPinfo keys
- LLM provider keys
- router credentials
- private host inventory
