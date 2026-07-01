# Keeper

Keeper is the planned Python anomaly scorer.

Responsibilities:

- query Prometheus
- compute explainable anomaly scores
- expose scores on `/metrics`

Keeper should start with simple baselines before streaming anomaly models.
