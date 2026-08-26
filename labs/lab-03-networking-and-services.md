# Lab 03: Networking, Services & ClusterIP

## Objective
Expose Kubernetes deployments using ClusterIP and NodePort Services, and understand internal DNS resolution.

---

## Step 1: Deploy Backend & Frontend Apps

```bash
kubectl create deployment nginx-backend --image=nginx:alpine --replicas=2
kubectl expose deployment nginx-backend --port=80 --target-port=80 --type=ClusterIP
```

Verify service creation:
```bash
kubectl get svc nginx-backend
```

---

## Step 2: Test Internal Pod DNS & Connectivity

Run a curl test pod:
```bash
kubectl run curl-test --image=curlimages/curl --rm -it -- restart=Never -- curl http://nginx-backend.default.svc.cluster.local
```

---

## Step 3: Expose via NodePort Service

```bash
kubectl expose deployment nginx-backend --name=nginx-nodeport --port=80 --type=NodePort
kubectl get svc nginx-nodeport
```
