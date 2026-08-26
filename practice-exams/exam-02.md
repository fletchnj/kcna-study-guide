# Practice Exam 02: Architecture, Observability & Delivery (25 Questions)

---

### Question 1
Which CNCF project provides vendor-neutral APIs, SDKs, and tooling to generate, collect, and export telemetry data (metrics, logs, traces)?
- A) Prometheus
- B) OpenTelemetry (OTel)
- C) Fluentd
- D) Jaeger

**Answer:** **B**
**Explanation:** OpenTelemetry is the CNCF standard framework for generating and collecting metrics, logs, and traces.

---

### Question 2
Which OpenGitOps principle states that the target system's desired state must be stored in a version-controlled repository?
- A) Continuous Reconciliation
- B) Declarative
- C) Versioned and Immutable
- D) Pulled Automatically

**Answer:** **C**
**Explanation:** GitOps requires that the desired state of the system is stored in a versioned and immutable store (such as Git).

---

### Question 3
In Prometheus, what metric type represents a single numerical value that can arbitrarily go up or down?
- A) Counter
- B) Gauge
- C) Histogram
- D) Summary

**Answer:** **B**
**Explanation:** A Gauge is a metric that represents a single numerical value that can go up and down (e.g., current memory usage or CPU temperature).

---

### Question 4
What is the primary function of a Container Network Interface (CNI) plugin in Kubernetes?
- A) Package applications into Helm charts
- B) Provision persistent disk storage
- C) Manage container network connectivity and Pod IP allocation
- D) Collect container log streams

**Answer:** **C**
**Explanation:** CNI plugins (such as Calico, Cilium, or Flannel) handle networking for Pods, assigning IP addresses and enabling Pod-to-Pod communication.

---

### Question 5
What happens when a container's `readinessProbe` fails?
- A) The container is immediately killed and restarted by the kubelet.
- B) The Pod's IP address is removed from matching Service endpoints.
- C) The node is marked as NotReady.
- D) The Deployment rolls back to the previous revision.

**Answer:** **B**
**Explanation:** If a readiness probe fails, Kubernetes stops sending network traffic to that Pod by removing its IP from Service endpoints.
