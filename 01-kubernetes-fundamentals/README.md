# Domain 1: Kubernetes Fundamentals (46%)

Kubernetes is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications.

---

## 1. Kubernetes Architecture & Components

Kubernetes follows a master/worker architecture consisting of the **Control Plane** and **Worker Nodes**.

```
+-------------------------------------------------------------------+
|                        CONTROL PLANE                              |
|  +-------------------+  +------------------+  +-----------------+ |
|  |  kube-apiserver   |  |       etcd       |  | kube-scheduler  | |
|  +-------------------+  +------------------+  +-----------------+ |
|  +--------------------------------------------------------------+ |
|  |                kube-controller-manager                       | |
|  +--------------------------------------------------------------+ |
+-------------------------------------------------------------------+
                                 |
        +------------------------+------------------------+
        |                                                 |
+-------v-------------------------+     +-----------------v---------------+
|          WORKER NODE 1          |     |          WORKER NODE 2          |
| +----------+ +--------+ +-----+ |     | +----------+ +--------+ +-----+ |
| | kubelet  | |kube-pxy| | CRI | |     | | kubelet  | |kube-pxy| | CRI | |
| +----------+ +--------+ +-----+ |     | +----------+ +--------+ +-----+ |
| +-----------------------------+ |     | +-----------------------------+ |
| | Pod 1 [App]   Pod 2 [DB]    | |     | | Pod 3 [App]   Pod 4 [Cache] | |
| +-----------------------------+ |     | +-----------------------------+ |
+---------------------------------+     +---------------------------------+
```

### Control Plane Components
- **`kube-apiserver`**: The front end for the control plane. Exposes the Kubernetes API (REST API). All communications pass through the API server.
- **`etcd`**: Consistent, highly-available key-value store used as Kubernetes' backing store for all cluster data (state of truth).
- **`kube-scheduler`**: Watches for newly created Pods with no assigned node, and selects a worker node for them to run on based on resource requirements, constraints, and affinity.
- **`kube-controller-manager`**: Runs controller processes in a single binary. Key controllers:
  - Node Controller: Monitors node health.
  - ReplicaSet Controller: Maintains correct number of pods.
  - Endpoints Controller: Populates Service endpoints.
  - ServiceAccount Controller: Creates default accounts/tokens.
- **`cloud-controller-manager`**: Integrates underlying cloud provider APIs (AWS, GCP, Azure) for load balancers, storage, and routes.

### Worker Node Components
- **`kubelet`**: An agent that runs on each node in the cluster. Ensures containers described in PodSpecs are running and healthy.
- **`kube-proxy`**: Network proxy running on each node. Maintains network rules on nodes allowing network communication to Pods from inside or outside cluster.
- **`Container Runtime`**: Software responsible for running containers (e.g., `containerd`, `CRI-O`).

---

## 2. Core Kubernetes Workload Resources

| Resource | Purpose | Abstraction Level |
| :--- | :--- | :--- |
| **Pod** | Smallest deployable unit in K8s; encapsulates one or more co-located containers. | Single / Multi-Container |
| **ReplicaSet** | Ensures a specified number of identical Pod replicas are running at any time. | Pod Grouping |
| **Deployment** | Provides declarative updates for Pods and ReplicaSets (supports rolling updates & rollbacks). | Stateless Apps |
| **StatefulSet** | Manages deployment and scaling of a set of Pods with unique network identities & persistent storage. | Stateful Apps (Databases) |
| **DaemonSet** | Ensures all (or some) nodes run a copy of a Pod (e.g., log collectors, monitoring agents). | Per-Node Agents |
| **Job / CronJob** | Runs finite tasks to completion (Job = one-time, CronJob = scheduled recurring). | Batch / Scheduled Tasks |

---

## 3. Storage & Configuration Resources

- **`ConfigMap`**: Stores non-confidential configuration data in key-value pairs (injected as env vars, CLI flags, or mounted volume files).
- **`Secret`**: Stores sensitive data (passwords, tokens, SSH keys) encoded in Base64.
- **`PersistentVolume (PV)`**: A piece of storage in the cluster provisioned by an administrator or dynamically via StorageClass.
- **`PersistentVolumeClaim (PVC)`**: A request for storage by a user/Pod.
- **`StorageClass`**: Describes the "classes" of storage offered (e.g., fast SSD vs standard HDD) and enables dynamic provisioning via CSI.

---

## 4. Manifest Examples

Find complete working YAML examples in the [`manifests/`](./manifests/) directory:
- [01-pod.yaml](./manifests/01-pod.yaml)
- [02-deployment.yaml](./manifests/02-deployment.yaml)
- [03-service.yaml](./manifests/03-service.yaml)
- [04-configmap-secret.yaml](./manifests/04-configmap-secret.yaml)
- [05-pvc-pv.yaml](./manifests/05-pvc-pv.yaml)
