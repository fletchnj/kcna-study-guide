# Practice Exam 01: Kubernetes Fundamentals (25 Questions)

---

### Question 1
Which Control Plane component is the primary state store for a Kubernetes cluster?
- A) `kube-apiserver`
- B) `kube-scheduler`
- C) `etcd`
- D) `kube-controller-manager`

**Answer:** **C**
**Explanation:** `etcd` is a consistent, highly-available key-value store used as Kubernetes' backing store for all cluster data.

---

### Question 2
What is the smallest deployable object in Kubernetes?
- A) Container
- B) Pod
- C) Deployment
- D) ReplicaSet

**Answer:** **B**
**Explanation:** A Pod is the smallest deployable unit in Kubernetes that contains one or more co-located containers.

---

### Question 3
Which workload resource ensures that all (or a subset of) nodes run a copy of a Pod?
- A) StatefulSet
- B) ReplicaSet
- C) DaemonSet
- D) Deployment

**Answer:** **C**
**Explanation:** DaemonSets ensure that a copy of a Pod runs on selected or all worker nodes in the cluster (commonly used for monitoring agents and log collectors).

---

### Question 4
Which process running on worker nodes monitors PodSpecs and ensures containers are healthy?
- A) `kube-proxy`
- B) `kubelet`
- C) `containerd`
- D) `kube-scheduler`

**Answer:** **B**
**Explanation:** The `kubelet` is the node agent that registers the node with the apiserver and ensures described containers are running and healthy.

---

### Question 5
What type of Kubernetes Service exposes the application on a static port on each Node's IP address?
- A) ClusterIP
- B) NodePort
- C) LoadBalancer
- D) ExternalName

**Answer:** **B**
**Explanation:** A NodePort Service exposes the Service on each Node's IP at a static port (in range 30000-32767).
