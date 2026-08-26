# ☸️ Kubernetes and Cloud Native Associate (KCNA) Study Guide & Practice Resources

Welcome to the ultimate **Kubernetes and Cloud Native Associate (KCNA)** preparation repository! This repository provides comprehensive study notes, hands-on lab exercises, YAML manifests, and full-length practice exams aligned directly with the official [Linux Foundation / CNCF KCNA Curriculum](https://github.com/cncf/curriculum/blob/master/KCNA_Curriculum_v1.0.pdf).

---

## 📊 KCNA Exam Overview

- **Exam Format:** 60 Multiple-Choice Questions
- **Time Limit:** 90 Minutes
- **Passing Score:** 75%
- **Certification Validity:** 2 Years
- **Administered By:** Linux Foundation & Cloud Native Computing Foundation (CNCF)

### 🎯 Official Curriculum Breakdown

| Domain | Weight | Topics Covered |
| :--- | :---: | :--- |
| [**1. Kubernetes Fundamentals**](./01-kubernetes-fundamentals/) | **46%** | Architecture, Pods, Deployments, Services, Storage, ConfigMaps, Secrets, Ingress |
| [**2. Cloud Native Architecture**](./02-cloud-native-architecture/) | **22%** | Microservices, Serverless, Storage (CSI), Networking (CNI), Service Mesh |
| [**3. Cloud Native Observability**](./03-cloud-native-observability/) | **18%** | Telemetry, Prometheus, Metrics, Logging (Fluentd/Loki), Tracing (OpenTelemetry) |
| [**4. Cloud Native Application Delivery**](./04-cloud-native-application-delivery/) | **14%** | CI/CD, GitOps (ArgoCD/Flux), Helm, Container Packaging & OCI Registries |

---

## 🚀 Quick Start & Study Roadmap

```mermaid
graph TD
    A[Step 1: Read Domain 1 - K8s Fundamentals] --> B[Complete Hands-on Labs 01-04]
    B --> C[Step 2: Read Domain 2 - Architecture & Networking]
    C --> D[Step 3: Read Domain 3 - Observability]
    D --> E[Complete Lab 05 - Prometheus & Metrics]
    E --> F[Step 4: Read Domain 4 - Application Delivery & GitOps]
    F --> G[Practice Exams 01, 02, and Full 60-Q Mock Exam 03]
```

---

## 🛠️ Hands-On Labs

Get practical experience running a local Kubernetes cluster (`kind` or `minikube`):

1. 🧪 [**Lab 01: Cluster Setup & Kubectl Basics**](./labs/lab-01-kind-cluster-setup.md)
2. 🧪 [**Lab 02: Deployments, Scaling & Health Probes**](./labs/lab-02-deploying-workloads.md)
3. 🧪 [**Lab 03: Networking, Services & Ingress**](./labs/lab-03-networking-and-services.md)
4. 🧪 [**Lab 04: ConfigMaps, Secrets & Persistent Volumes**](./labs/lab-04-config-and-storage.md)
5. 🧪 [**Lab 05: Observability with Prometheus & Metrics**](./labs/lab-05-observability-prometheus.md)

---

## 📝 Practice Exams & Quizzes

Test your knowledge before taking the real exam:

- ✍️ [**Exam 01: Kubernetes Fundamentals (25 Questions)**](./practice-exams/exam-01.md)
- ✍️ [**Exam 02: Architecture, Observability & Delivery (25 Questions)**](./practice-exams/exam-02.md)
- ✍️ [**Exam 03: Full 60-Question KCNA Mock Exam with Explanations**](./practice-exams/exam-03.md)

---

## ⚡ Essential `kubectl` Cheat Sheet

```bash
# Cluster Info & Nodes
kubectl cluster-info
kubectl get nodes -o wide

# Workloads
kubectl get pods --all-namespaces
kubectl run nginx --image=nginx:alpine --port=80
kubectl create deployment web --image=nginx:alpine --replicas=3
kubectl scale deployment web --replicas=5
kubectl rollout status deployment/web
kubectl rollout undo deployment/web

# Exposing Applications
kubectl expose deployment web --type=ClusterIP --port=80 --target-port=80
kubectl expose deployment web --type=NodePort --port=80

# Debugging & Inspection
kubectl describe pod <pod-name>
kubectl logs -f <pod-name>
kubectl exec -it <pod-name> -- /bin/sh
kubectl top nodes
kubectl top pods
```
