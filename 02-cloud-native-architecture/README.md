# Domain 2: Cloud Native Architecture (22%)

Cloud Native is an approach to building and running applications that exploits the advantages of the cloud computing delivery model.

---

## 1. Cloud Native Pillars & 12-Factor App

Cloud Native applications are designed to be scale-out, resilient, manageable, and dynamically orchestrated.

### The 12-Factor App Principles
1. **Codebase**: One codebase tracked in revision control, many deploys.
2. **Dependencies**: Explicitly declare and isolate dependencies.
3. **Config**: Store configuration in the environment (ConfigMaps/Secrets).
4. **Backing services**: Treat backing services (databases, caches) as attached resources.
5. **Build, release, run**: Strictly separate build and run stages.
6. **Processes**: Execute the app as one or more stateless processes.
7. **Port binding**: Export services via port binding.
8. **Concurrency**: Scale out via the process model.
9. **Disposability**: Maximize robustness with fast startup and graceful shutdown.
10. **Dev/prod parity**: Keep development, staging, and production as similar as possible.
11. **Logs**: Treat logs as event streams.
12. **Admin processes**: Run admin/management tasks as one-off processes.

---

## 2. Microservices vs. Monoliths

| Feature | Monolithic Architecture | Microservices Architecture |
| :--- | :--- | :--- |
| **Structure** | Single unified codebase & process | Decoupled, independently deployable services |
| **Scaling** | Scale entire application together | Scale individual services based on load |
| **Fault Isolation**| Single fault can bring down entire app | Failures isolated to individual microservices |
| **Technology Stack**| Single technology stack | Polyglot (choose right tool per service) |

---

## 3. Container Networking (CNI)

Kubernetes networking assumes that every Pod gets its own IP address.

### Kubernetes Networking Model Requirements:
- All Pods can communicate with all other Pods without NAT.
- All Nodes can communicate with all Pods (and vice-versa) without NAT.
- The IP that a Pod sees itself as is the same IP that others see it as.

### Container Network Interface (CNI) Plugins:
- **Calico**: Provides BGP-based routing and strong NetworkPolicies.
- **Cilium**: Uses eBPF for high-performance networking, security, and observability.
- **Flannel**: Simple overlay network using VXLAN.

---

## 4. Service Mesh Architecture

A **Service Mesh** is a dedicated infrastructure layer for handling service-to-service communication, security, and observability.

```
       +---------------------------------------------+
       |             CONTROL PLANE                   |
       |  (Config distribution, CA / mTLS certs)     |
       +---------------------------------------------+
                              |
       +----------------------v----------------------+
       |               DATA PLANE                    |
       |  +-------------------+  +-----------------+ |
       |  |  App A | Proxy A  |<->| Proxy B | App B | |
       |  +-------------------+  +-----------------+ |
       +---------------------------------------------+
```

### Key Capabilities:
- **Traffic Management**: Canary deployments, traffic splitting, retries, circuit breaking.
- **Security**: Mutual TLS (mTLS) encryption, authorization policies.
- **Observability**: Distributed tracing, golden metrics (latency, traffic, errors, saturation).
- **Popular Service Meshes**: Istio, Linkerd, Envoy (data plane proxy).

---

## 5. Serverless & Event-Driven Architecture

- **Serverless**: Developer writes code, infrastructure auto-scales from zero to N based on demand. Pay only for execution time.
- **Knative**: Kubernetes-based platform to build, deploy, and manage modern serverless workloads.
