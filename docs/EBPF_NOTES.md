# eBPF Notes

## What eBPF Means Here

eBPF lets Lighthouse attach small verified programs to Linux kernel events. For
this project, eBPF is for telemetry, not enforcement.

The kernel program should do little work. The Go userspace collector should load
the program, read events or maps, aggregate data, and expose Prometheus metrics.

## First Principle

Start with easier hooks before XDP.

Initial candidates:

- `kprobe/tcp_connect`
- `kprobe/tcp_close`
- `tracepoint/net/net_dev_xmit`

XDP is a stretch path after the basic collector is reliable.

## Visibility Caveat

An eBPF program running on the Pi sees the Pi's kernel events.

It does not automatically see every packet on the home network. Whole-network
flow visibility requires one of these:

- the Pi is the router/gateway
- traffic is mirrored to the Pi
- the Pi is otherwise in the traffic path

DNS remains the first network-wide signal because clients can be configured to
use Pi-hole.

## Language Split

- C for the eBPF program
- Go for loading, aggregation, and `/metrics`

Avoid FFI between the anomaly model and collector. Use Prometheus instead.
