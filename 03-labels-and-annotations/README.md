# Module 03: Labels and Annotations 🏷️

Kubernetes allows you to attach key-value metadata to any resource. However, candidates must clearly understand the fundamental architectural difference between **Labels** and **Annotations**.

---

## 🎯 KCNA Exam Highlights: What You Must Know

### 1. The Definitive Distinction

| Dimension | Labels (`metadata.labels`) | Annotations (`metadata.annotations`) |
| :--- | :--- | :--- |
| **Purpose** | **Identifying** and selecting resources. Organizes and categorizes objects into sets. | **Non-identifying** metadata and directives for external tools, controllers, or human operators. |
| **Queryable?** | **YES** — First-class citizen for querying and filtering with label selectors. | **NO** — Kubernetes API server does **not** index annotations for filtering. |
| **Size & Characters** | Strict: Keys max 63 characters (plus optional DNS subdomain prefix up to 253 chars). Values max 63 alphanumeric chars, `-`, `_`, `.`. | Flexible: Values can be large, unstructured, or contain JSON/YAML string payloads. |
| **Primary Consumers** | `kube-controller-manager`, `kube-scheduler`, `kube-proxy`, `Service` endpoint controller, and human operators via `kubectl -l`. | External tools (Prometheus, Envoy/Istio, Ingress controllers, GitOps/ArgoCD), release managers, audit loggers. |

---

### 2. Label Selectors: Equality-Based vs. Set-Based

Kubernetes supports two selector syntaxes:

#### A. Equality-Based Selectors
Supports `=`, `==` (identical to `=`), and `!=`:
```bash
# Matches pods where env equals 'prod'
kubectl get pods -l env=prod

# Matches pods where tier does NOT equal 'data'
kubectl get pods -l tier!=data
```

#### B. Set-Based Selectors
Supports `in`, `notin`, and key presence (`exists` / `!key`):
```bash
# Matches pods where env is either prod or staging
kubectl get pods -l 'env in (prod, staging)'

# Matches pods where tier is not data
kubectl get pods -l 'tier notin (data)'

# Matches pods that have the label key 'tier', regardless of value
kubectl get pods -l 'tier'

# Matches pods that do NOT have the label key 'tier'
kubectl get pods -l '!tier'
```

---

### 3. Recommended Standard Labels (`app.kubernetes.io/*`)

The CNCF and Kubernetes architecture team recommend standard metadata labels across all manifests:
- `app.kubernetes.io/name`: Name of the application (e.g., `mysql`, `nginx`).
- `app.kubernetes.io/instance`: Unique name identifying this instance (e.g., `mysql-primary`).
- `app.kubernetes.io/version`: Current version of application (e.g., `5.7.21`, `v1.2.0`).
- `app.kubernetes.io/component`: Component within architecture (e.g., `database`, `frontend`).
- `app.kubernetes.io/part-of`: Higher-level application name (e.g., `e-commerce-suite`).
- `app.kubernetes.io/managed-by`: Tool used to manage application (e.g., `helm`, `kubectl`).

---

## 💻 Imperative CLI Commands (KCNA Speed Cheatsheet)

```bash
# 1. View all pods with their labels printed in extra columns
kubectl get pods --show-labels

# 2. Add a new label to a running pod
kubectl label pod pod-frontend-prod owner=dev-team

# 3. Overwrite an existing label (requires --overwrite flag)
kubectl label pod pod-frontend-prod env=staging --overwrite

# 4. Remove a label (suffix with a minus sign '-')
kubectl label pod pod-frontend-prod owner-

# 5. Add an annotation to a pod
kubectl annotate pod pod-frontend-prod release.version="2.1.0"

# 6. Remove an annotation (suffix with a minus sign '-')
kubectl annotate pod pod-frontend-prod release.version-
```

---

## 🧪 Hands-On Lab Walkthrough

### Step 1: Deploy Sample Resources
```bash
kubectl apply -f 01-labeled-pods.yaml
kubectl apply -f 02-service-selector.yaml
kubectl apply -f 03-node-selector-pod.yaml
kubectl apply -f 04-annotated-pod.yaml
```

### Step 2: Test Label Selectors
List all pods with their labels:
```bash
kubectl get pods --show-labels
```

Query backend pods in production:
```bash
kubectl get pods -l app=backend,env=prod
```

Query pods using set-based selector:
```bash
kubectl get pods -l 'tier in (ui, data)'
```

### Step 3: Inspect Service Endpoints
Notice how `backend-production-service` automatically routed only to `pod-backend-prod` because it matched `app: backend` and `env: prod`:
```bash
kubectl get endpoints backend-production-service
```
> **Output shows only the IP of `pod-backend-prod`**, ignoring `pod-backend-dev` and `pod-frontend-prod`.

### Step 4: Verify Annotations
Inspect annotations on `annotated-service-pod`:
```bash
kubectl describe pod annotated-service-pod
```
Notice that attempting to filter by annotation will fail or return nothing:
```bash
# This queries LABELS, not annotations, and will return "No resources found":
kubectl get pods -l prometheus.io/scrape=true
```

### Step 5: Clean Up
```bash
kubectl delete -f 04-annotated-pod.yaml
kubectl delete -f 03-node-selector-pod.yaml
kubectl delete -f 02-service-selector.yaml
kubectl delete -f 01-labeled-pods.yaml
```

---

## ❓ KCNA Quick Check

**Q1: Which of the following is a valid reason to choose an Annotation over a Label?**
- A) You need Kubernetes Services to route traffic to the Pod.
- B) You need to filter resources in `kubectl get` using `--selector`.
- C) You want to store structured JSON configuration for an external logging agent.
- D) You want the Deployment controller to track which ReplicaSet owns the Pod.

*Correct Answer: **C**. Annotations are specifically designed for non-identifying metadata, structured text, and integration with third-party tools, whereas labels are for identification and selection.*
