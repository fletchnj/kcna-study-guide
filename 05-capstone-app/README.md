# Module 05: Capstone Microservice Application 🚀

This capstone module demonstrates a unified, production-ready microservice that integrates all five KCNA **Configuration & Health** topics into a single cohesive architecture.

---

## 🏗️ Architecture & Component Integration

```
                         ┌──────────────────────────────────────────────┐
                         │   Client / Ingress / Service Mesh Traffic    │
                         └──────────────────────┬───────────────────────┘
                                                │
                                                ▼
                         ┌──────────────────────────────────────────────┐
                         │       Service: kcna-health-service           │
                         │       selector:                              │
                         │         app: kcna-health-demo                │
                         │         tier: backend                        │
                         └──────────────────────┬───────────────────────┘
                                                │ (Only routes to READY pods)
                        ┌───────────────────────┴───────────────────────┐
                        │                                               │
                        ▼                                               ▼
     ┌────────────────────────────────────┐   ┌────────────────────────────────────┐
     │  Pod: kcna-health-demo-xxxx-1      │   │  Pod: kcna-health-demo-xxxx-2      │
     │  Labels:                           │   │  Labels:                           │
     │    app: kcna-health-demo           │   │    app: kcna-health-demo           │
     │    tier: backend                   │   │    tier: backend                   │
     │  Annotations:                      │   │  Annotations:                      │
     │    prometheus.io/scrape: "true"    │   │    prometheus.io/scrape: "true"    │
     │                                    │   │                                    │
     │  ConfigMap (capstone-config)       │   │  ConfigMap (capstone-config)       │
     │    • APP_ENV=production            │   │    • APP_ENV=production            │
     │    • PORT=8080                     │   │    • PORT=8080                     │
     │    • Code volume: /app/app.py      │   │    • Code volume: /app/app.py      │
     │                                    │   │                                    │
     │  Secret (capstone-secrets)         │   │  Secret (capstone-secrets)         │
     │    • DB_USER                       │   │    • DB_USER                       │
     │    • DB_PASSWORD                   │   │    • DB_PASSWORD                   │
     │    • API_KEY                       │   │    • API_KEY                       │
     │                                    │   │                                    │
     │  Probes:                           │   │  Probes:                           │
     │    🩺 Startup:   GET /healthz      │   │    🩺 Startup:   GET /healthz      │
     │    🩺 Liveness:  GET /healthz      │   │    🩺 Liveness:  GET /healthz      │
     │    🩺 Readiness: GET /ready        │   │    🩺 Readiness: GET /ready        │
     └────────────────────────────────────┘   └────────────────────────────────────┘
```

---

## 🧪 Interactive Testing Guide

### Step 1: Deploy the Capstone
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Wait for deployment rollout:
```bash
kubectl rollout status deployment/kcna-health-demo
```

### Step 2: Port-forward to the Service
In a terminal, forward local port `8080` to the service:
```bash
kubectl port-forward svc/kcna-health-service 8080:80
```

In another terminal, test the root endpoint:
```bash
curl http://localhost:8080/
```
> **Sample Response**:
```json
{
  "app": "KCNA Capstone Health & Config Microservice",
  "status": {
    "is_alive": true,
    "is_ready": true
  },
  "config": {
    "env": "production",
    "log_level": "INFO",
    "port": "8080"
  },
  "secrets": {
    "db_user": "cloud_native_user",
    "db_password": "Sup***",
    "has_api_key": true
  }
}
```

---

### Step 3: Trigger a Readiness Failure (Traffic Cutoff)
Simulate an overloaded pod by calling `/fail-ready`:
```bash
curl http://localhost:8080/fail-ready
```

Check the pods:
```bash
kubectl get pods -l app=kcna-health-demo
```
> You will observe one pod transition from `1/1` to `0/1` READY.

Inspect the Service Endpoints:
```bash
kubectl get endpoints kcna-health-service
```
> The unhealthy pod's IP is immediately dropped from the endpoint pool! Any subsequent user requests route exclusively to the healthy replica.

---

### Step 4: Trigger a Liveness Failure (Container Restart)
Simulate a fatal deadlock or crash by calling `/fail-live`:
```bash
curl http://localhost:8080/fail-live
```

Watch the pods:
```bash
kubectl get pods -l app=kcna-health-demo -w
```
> After `failureThreshold * periodSeconds` (~15s), the kubelet kills the container and initiates a restart. The `RESTARTS` counter increments to `1`.

---

### Step 5: Clean Up
```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```
