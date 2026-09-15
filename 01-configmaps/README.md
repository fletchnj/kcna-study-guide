# Module 01: ConfigMaps 🗺️

In cloud native architectures (specifically the **Twelve-Factor App methodology**, Factor III: *Config*), configuration must strictly be decoupled from container images. Kubernetes provides **ConfigMaps** to inject non-confidential configuration into Pods at runtime.

---

## 🎯 KCNA Exam Highlights: What You Must Know

1. **Purpose**: Store non-confidential configuration data as key-value pairs or complete configuration files (e.g., JSON, YAML, `.properties`, `.conf`).
2. **Storage Limit**: Maximum object size is **1 MiB** (due to `etcd` constraints).
3. **Consumption Patterns**:
   - **Environment Variable (single key)**: `valueFrom.configMapKeyRef`
   - **Environment Variables (bulk)**: `envFrom.configMapRef`
   - **Volume Mount (files)**: Projected into files in a directory (`spec.volumes[].configMap`)
   - **Command-line arguments**: Referencing injected environment variables using `$(VAR_NAME)` syntax.
4. **Dynamic Updates & Propagation**:
   - **Mounted Volumes**: Automatically updated by the kubelet periodic sync loop (typically within 60 seconds).
   - **Environment Variables**: **NOT** dynamically updated. Changes to a ConfigMap require restarting the Pod/Deployment to reflect in environment variables.
   - **SubPath Volume Mounts**: Files mounted using `subPath` do **NOT** receive automatic updates.
5. **Immutable ConfigMaps (`immutable: true`)**:
   - Introduced in Kubernetes v1.21.
   - Prevents accidental changes to critical configurations.
   - Drastically improves cluster scalability because the kubelet stops polling/watching the API server for updates to immutable objects.

---

## 💻 Imperative CLI Commands (KCNA Speed Cheatsheet)

Candidates are frequently tested on how to generate ConfigMaps imperatively without writing YAML from scratch:

```bash
# 1. Create from literal key-value pairs
kubectl create configmap app-settings \
  --from-literal=ENV=staging \
  --from-literal=PORT=8080

# 2. Create from a single file (the key defaults to the filename)
kubectl create configmap nginx-config \
  --from-file=/path/to/nginx.conf

# 3. Create from a file with a custom key name
kubectl create configmap custom-config \
  --from-file=server-settings.json=/path/to/data.json

# 4. Create from an env-file (parses KEY=VALUE lines)
kubectl create configmap env-config \
  --from-env-file=.env

# 5. Generate YAML without applying (Dry-run pattern)
kubectl create configmap my-cm --from-literal=tier=frontend --dry-run=client -o yaml
```

---

## 🧪 Hands-On Lab Walkthrough

### Step 1: Apply the ConfigMaps
```bash
# Apply environment ConfigMap, Volume ConfigMap, and Immutable ConfigMap
kubectl apply -f 01-literal-env-configmap.yaml
kubectl apply -f 02-volume-configmap.yaml
kubectl apply -f 03-immutable-configmap.yaml
```

Inspect the created resources:
```bash
kubectl get configmaps
kubectl describe configmap app-env-config
kubectl describe configmap app-volume-config
kubectl describe configmap immutable-security-config
```

### Step 2: Test Immutability
Attempt to modify the immutable ConfigMap:
```bash
# Try to patch an immutable ConfigMap (This will fail with an API error)
kubectl patch configmap immutable-security-config -p '{"data":{"new-key":"value"}}'
```
> **Expected Output**:
> `Error from server (Forbidden): ... ConfigMap "immutable-security-config" is invalid: field is immutable`

### Step 3: Run the Consumer Pod
Deploy the Pod that consumes the ConfigMaps via multiple patterns:
```bash
kubectl apply -f 04-demo-pod.yaml
```

View the logs to verify environment variables and mounted files:
```bash
kubectl logs configmap-demo-pod
```

### Step 4: Clean Up
```bash
kubectl delete -f 04-demo-pod.yaml
kubectl delete -f 03-immutable-configmap.yaml
kubectl delete -f 02-volume-configmap.yaml
kubectl delete -f 01-literal-env-configmap.yaml
```

---

## ❓ KCNA Quick Check

**Q1: If you update a ConfigMap consumed as an environment variable in an active Pod, when does the container see the new value?**
- A) Instantly
- B) Within 60 seconds
- C) Only after the container/pod is restarted
- D) Never

*Correct Answer: **C**. Environment variables are set when the container process starts; only volume mounts update dynamically.*
