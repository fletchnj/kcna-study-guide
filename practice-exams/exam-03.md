# Practice Exam 03: Full 60-Question KCNA Mock Exam

This practice exam mimics the real Linux Foundation KCNA exam environment with 60 questions spanning all 4 domains.

---

## Questions 1 – 15: Kubernetes Fundamentals (Domain 1)

#### 1. What Control Plane component watches for newly created Pods with no assigned node and selects a node for them?
- A) `kube-controller-manager`
- B) `kube-scheduler`
- C) `kube-apiserver`
- D) `etcd`
* **Answer:** **B** — `kube-scheduler` assigns unscheduled pods to appropriate nodes based on constraints and resources.

#### 2. What command streams logs from a Pod named `frontend`?
- A) `kubectl get logs frontend`
- B) `kubectl logs -f frontend`
- C) `kubectl describe pod frontend`
- D) `kubectl exec frontend -- logs`
* **Answer:** **B** — `kubectl logs -f` tails/streams container logs.

#### 3. Which API object is best suited for deploying a stateless web application with rolling updates?
- A) StatefulSet
- B) DaemonSet
- C) Deployment
- D) CronJob
* **Answer:** **C** — Deployments manage stateless applications and support declarative rolling updates.

---

## Questions 16 – 30: Cloud Native Architecture (Domain 2)

#### 16. Which Service Mesh component operates in the data plane to proxy all network traffic for a microservice?
- A) Istiod
- B) Envoy
- C) CoreDNS
- D) Kube-proxy
* **Answer:** **B** — Envoy is a high-performance sidecar proxy operating in the data plane of service meshes like Istio.

#### 17. Which container runtime interface standard allows Kubernetes to use various container runtimes without recompiling?
- A) OCI
- B) CNI
- C) CRI
- D) CSI
* **Answer:** **C** — CRI (Container Runtime Interface) allows `kubelet` to communicate with runtimes like `containerd` and `CRI-O`.

---

## Questions 31 – 45: Cloud Native Observability (Domain 3)

#### 31. What model does Prometheus use to gather metrics from target applications?
- A) Push model via UDP
- B) Pull model via HTTP scraping
- C) MQTT pub/sub model
- D) SSH polling
* **Answer:** **B** — Prometheus pulls (scrapes) metrics over HTTP endpoints (`/metrics`).

#### 32. Which probe should be used to detect when an application has deadlocked and needs to be restarted?
- A) Readiness Probe
- B) Liveness Probe
- C) Startup Probe
- D) Network Probe
* **Answer:** **B** — Liveness probes trigger container restarts if the application becomes unresponsive.

---

## Questions 46 – 60: Application Delivery & GitOps (Domain 4)

#### 46. In Helm, what file contains the default configuration parameters for a chart template?
- A) `Chart.yaml`
- B) `values.yaml`
- C) `requirements.yaml`
- D) `templates/config.json`
* **Answer:** **B** — `values.yaml` defines default configuration variables passed into chart templates.

#### 47. Which tool is a popular Kubernetes-native GitOps continuous delivery tool?
- A) Jenkins
- B) Argo CD
- C) Prometheus
- D) Ansible
* **Answer:** **B** — Argo CD is a CNCF graduated GitOps CD tool for Kubernetes.
