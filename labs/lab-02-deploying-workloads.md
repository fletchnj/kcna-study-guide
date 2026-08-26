# Lab 02: Deployments, Scaling & Health Probes

## Objective
Create a Kubernetes Deployment, perform rolling updates, scale replicas, and configure liveness/readiness probes.

---

## Step 1: Apply Deployment Manifest

Create file `app-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo-web
  template:
    metadata:
      labels:
        app: demo-web
    spec:
      containers:
      - name: web
        image: nginx:1.24-alpine
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
```

Apply manifest:
```bash
kubectl apply -f app-deployment.yaml
kubectl get deployments
kubectl get pods -l app=demo-web
```

---

## Step 2: Scale Deployment Replicas

```bash
kubectl scale deployment demo-web --replicas=5
kubectl get pods -w
```

---

## Step 3: Perform Rolling Update & Rollback

Update image to `nginx:1.25-alpine`:
```bash
kubectl set image deployment/demo-web web=nginx:1.25-alpine
kubectl rollout status deployment/demo-web
```

Check rollout history and rollback if needed:
```bash
kubectl rollout history deployment/demo-web
kubectl rollout undo deployment/demo-web
```
