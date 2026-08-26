# Domain 3: Cloud Native Observability (18%)

Observability is the degree to which the internal state of a system can be inferred from knowledge of its external outputs.

---

## 1. The Three Pillars of Observability (MELT)

```
                       +-------------------+
                       |   OBSERVABILITY   |
                       +---------+---------+
                                 |
         +-----------------------+-----------------------+
         |                       |                       |
  +------v------+         +------v------+         +------v------+
  |   METRICS   |         |    LOGS     |         |   TRACES    |
  | (Prometheus)|         |(Loki/Fluentd)         | (Jaeger/OTel|
  +-------------+         +-------------+         +-------------+
```

1. **Metrics**: Numeric values measured over time (counters, gauges, histograms).
2. **Logs**: Timestamped text records of events that occurred.
3. **Traces**: End-to-end journey of a single request across multiple microservices.

---

## 2. Prometheus Monitoring & Architecture

Prometheus is a CNCF graduated open-source monitoring and alerting toolkit.

### Prometheus Key Features:
- Multi-dimensional data model with time-series data identified by metric name and key/value pairs.
- **PromQL**: Powerful query language for metrics analysis.
- **Pull Model**: Prometheus actively scrapes metrics over HTTP endpoints (`/metrics`).
- **Alertmanager**: Handles alerts sent by Prometheus server.

### Metric Types:
- **Counter**: Cumulative metric that only increases (e.g., `http_requests_total`).
- **Gauge**: Single numerical value that can go up or down (e.g., `memory_usage_bytes`, `cpu_temperature`).
- **Histogram**: Samples observations and counts them in configurable buckets (e.g., `request_duration_seconds`).
- **Summary**: Similar to histogram, calculates configurable quantiles over a sliding time window.

---

## 3. Health Probes in Kubernetes

Kubernetes uses probes to monitor container health and take automated action:

- **`livenessProbe`**: Indicates whether the container is running. If fails, kubelet kills and restarts container.
- **`readinessProbe`**: Indicates whether container is ready to accept network traffic. If fails, Service endpoints controller removes Pod IP from Service endpoint list.
- **`startupProbe`**: Indicates whether application inside container has started. Disables liveness/readiness checks until startup probe succeeds.

---

## 4. OpenTelemetry (OTel)

OpenTelemetry is a vendor-neutral CNCF framework for collecting, generating, and exporting telemetry data (Metrics, Logs, Traces).
