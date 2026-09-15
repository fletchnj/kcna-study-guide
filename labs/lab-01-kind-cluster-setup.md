# Lab 01: Cluster Setup & Kubectl Basics

## Objective
Set up a local multi-node Kubernetes cluster using `kind` (Kubernetes in Docker) or `minikube` and master `kubectl` basic commands.

---

## Prerequisites
- Docker Desktop or OrbStack running.
- `kind` installed (`brew install kind`) or `minikube` (`brew install minikube`).
- `kubectl` installed (`brew install kubectl`).

---

## Step 1: Create a Multi-Node `kind` Cluster

Save the following cluster config as `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

Run command:
```bash
kind create cluster --name kcna-lab --config kind-config.yaml
```

---

## Step 2: Verify Cluster Nodes & Info

```bash
kubectl cluster-info
kubectl get nodes -o wide
```

Expected output: 3 nodes (1 control-plane, 2 workers) in `Ready` status.

---

## Step 3: Run First Container & Inspect

```bash
kubectl run test-nginx --image=nginx:alpine --port=80
kubectl get pods -o wide
kubectl describe pod test-nginx
kubectl logs test-nginx
kubectl delete pod test-nginx
```

---

## Step 4: Cleanup

```bash
kind delete cluster --name kcna-lab
```
