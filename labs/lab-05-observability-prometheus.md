# Lab 05: Observability & Prometheus Monitoring

## Objective
Understand Prometheus metric scraping and inspect Kubernetes metrics.

---

## Step 1: Create Monitoring Namespace & Deploy Exporter

```bash
kubectl create namespace monitoring
kubectl apply -f 03-cloud-native-observability/manifests/prometheus-exporter.yaml
```

---

## Step 2: Verify Metrics Endpoint

Forward port to access node-exporter metrics locally:
```bash
kubectl port-forward -n monitoring deployment/prometheus-node-exporter 9100:9100 &
curl http://localhost:9100/metrics | grep node_cpu_seconds_total
```
