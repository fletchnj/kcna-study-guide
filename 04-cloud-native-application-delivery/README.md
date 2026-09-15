# Domain 4: Cloud Native Application Delivery (14%)

Application delivery covers how cloud-native software is built, packaged, configured, and deployed onto Kubernetes clusters.

---

## 1. CI/CD & Pipeline Fundamentals

- **Continuous Integration (CI)**: Automates building, testing, and linting code every time a developer commits changes.
- **Continuous Delivery / Deployment (CD)**: Automates releasing approved code into production environments.
- **Cloud-Native CI/CD Tools**: GitHub Actions, Tekton (Kubernetes-native pipelines), GitLab CI, Jenkins X.

---

## 2. GitOps Principles & Architecture

**GitOps** is an operational framework that uses Git repositories as the single source of truth for infrastructure and application code.

```
+------------------+          Git Push          +--------------------+
|  Developer Code  | -------------------------> |   Git Repository   |
+------------------+                            | (Desired State)    |
                                                +---------+----------+
                                                          |
                                                  Pull & Reconcile
                                                          |
+---------------------------------------------------------v----------+
|  KUBERNETES CLUSTER                                                |
|  +------------------+   Sync State   +--------------------------+  |
|  |  GitOps Operator | -------------> |  Running Workloads       |  |
|  | (Argo CD / Flux) |                |  (Actual State)          |  |
|  +------------------+                +--------------------------+  |
+--------------------------------------------------------------------+
```

### The 4 OpenGitOps Principles:
1. **Declarative**: The target system state is expressed declaratively (YAML/Helm).
2. **Versioned & Immutable**: Desired state is stored in Git with full audit history.
3. **Pulled Automatically**: Software agents automatically pull desired state from Git.
4. **Continuously Reconciled**: Agents continuously observe actual state and reconcile drift.

### Major GitOps Tools:
- **Argo CD**: Declarative, GitOps continuous delivery tool for Kubernetes.
- **Flux**: Set of continuous and progressive delivery solutions for Kubernetes.

---

## 3. Package Management with Helm

**Helm** is the package manager for Kubernetes.

### Key Concepts:
- **Chart**: A bundle of pre-configured Kubernetes resource manifests.
- **Release**: An instance of a Chart running in a Kubernetes cluster.
- **Repository**: A location where packaged charts can be published and shared.
- **`values.yaml`**: Configuration parameters passed to customize chart templates.

### Common Helm Commands:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-release bitnami/nginx
helm list
helm upgrade my-release bitnami/nginx --set replicaCount=3
helm rollback my-release 1
helm uninstall my-release
```
