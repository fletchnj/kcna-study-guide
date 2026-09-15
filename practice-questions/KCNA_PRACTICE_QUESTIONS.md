# KCNA Certification Practice Questions: Configuration & Health 📝

This exam simulation contains **25 high-yield practice questions** designed specifically for the **Linux Foundation / CNCF KCNA (Kubernetes and Cloud Native Associate)** certification exam.

Each question features a detailed rationale explaining why the correct choice is right and why the distractors are incorrect.

---

## Question 1: ConfigMap Injection Mechanics
**An application running in a Kubernetes Pod requires an environment variable named `DATABASE_URL` sourced from a ConfigMap named `backend-config`. Which YAML snippet correctly accomplishes this?**

A)
```yaml
env:
  - name: DATABASE_URL
    valueFrom:
      configMapRef:
        name: backend-config
        key: db_url
```

B)
```yaml
env:
  - name: DATABASE_URL
    valueFrom:
      configMapKeyRef:
        name: backend-config
        key: db_url
```

C)
```yaml
envFrom:
  - configMapKeyRef:
      name: backend-config
      key: db_url
```

D)
```yaml
env:
  - name: DATABASE_URL
    configMap:
      name: backend-config
      item: db_url
```

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: In a Pod container spec, single environment variables sourced from a ConfigMap use `env[].valueFrom.configMapKeyRef` with `name` and `key`.
- **A is incorrect**: `configMapRef` is used under `envFrom`, not inside `valueFrom`.
- **C is incorrect**: `envFrom` takes `configMapRef` to inject *all* key-value pairs as environment variables; it does not take `configMapKeyRef`.
- **D is incorrect**: `configMap` is not a valid child field directly under `env[]`.
</details>

---

## Question 2: Secret Storage Security
**What is the default storage mechanism and security characteristic of standard Kubernetes Secrets?**

A) Secrets are encrypted using AES-256 in `etcd` by default.  
B) Secrets are stored in `etcd` as plain base64-encoded strings and are not encrypted at rest by default.  
C) Secrets are hashed using SHA-512 and cannot be read back by `kubectl`.  
D) Secrets are stored exclusively in the kubelet's memory and are never written to `etcd`.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: By default, Kubernetes Secrets are simply Base64-encoded strings (RFC 4648). Base64 is an encoding format, NOT cryptographic encryption. True encryption at rest requires enabling an `EncryptionConfiguration` or integrating a KMS provider.
- **A is incorrect**: AES-256 encryption is only active if explicitly configured via an `EncryptionConfiguration` file.
- **C is incorrect**: Secrets are reversible (encoded, not hashed) so pods can consume the original plaintext values.
- **D is incorrect**: Secrets are Kubernetes API resources persisted in the `etcd` datastore.
</details>

---

## Question 3: Dynamic ConfigMap Propagation
**An engineer updates the data inside a ConfigMap. Which Pod consumption method will automatically reflect the updated values inside running containers without restarting the Pod?**

A) Environment variables injected via `valueFrom.configMapKeyRef`  
B) Environment variables injected via `envFrom.configMapRef`  
C) Projected volume mounts (`volumes[].configMap`)  
D) Container command-line arguments using `$(VAR_NAME)`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: When a ConfigMap is mounted as a volume, the kubelet periodically synchronizes updates to the mounted directory (typically within 60 seconds).
- **A & B are incorrect**: Environment variables are initialized only when the container process starts. Updating the ConfigMap does NOT alter environment variables in running processes without a Pod restart.
- **D is incorrect**: Command-line arguments are fixed at container process startup.
</details>

---

## Question 4: Labels vs. Annotations
**Which of the following describes an appropriate use case for an Annotation rather than a Label?**

A) Identifying all Pods that belong to the `production` environment for a Service selector.  
B) Attaching a JSON string representing a Git commit log and CI/CD audit metadata for a third-party release tool.  
C) Grouping Pods into `tier: frontend` and `tier: backend` for NetworkPolicy isolation.  
D) Constraining a Pod to run only on nodes with SSD storage using `nodeSelector`.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: Annotations are designed to hold non-identifying metadata, structured text (like JSON/YAML), timestamps, and information used by external tooling. Annotations are not queried by selectors.
- **A, C, & D are incorrect**: Services, NetworkPolicies, and `nodeSelector` all require **Labels** to perform grouping and filtering.
</details>

---

## Question 5: Liveness Probe Failure Behavior
**If a container's Liveness Probe consistently fails beyond its `failureThreshold`, what action does Kubernetes take?**

A) The kubelet removes the Pod IP from matching Service endpoints without restarting the container.  
B) The kubelet cordons the Node to prevent further pods from scheduling.  
C) The kubelet kills the container and initiates its restart policy.  
D) The Horizontal Pod Autoscaler automatically provisions another replica.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: When a Liveness Probe fails, the kubelet kills the container and restarts it according to the Pod's `restartPolicy` (e.g., `Always`, `OnFailure`).
- **A is incorrect**: Removing the Pod from Service endpoints without restarting is the behavior of a **Readiness Probe**.
- **B is incorrect**: The node is not affected by container probe failures.
- **D is incorrect**: HPA scales based on metrics (CPU, memory, custom metrics), not liveness probe failures.
</details>

---

## Question 6: Readiness Probe Behavior
**A web application pod is experiencing a temporary spike in traffic and its database connection pool is full. Which probe is specifically designed to stop new traffic from reaching this pod until it recovers, without restarting the container?**

A) Liveness Probe  
B) Readiness Probe  
C) Startup Probe  
D) Drain Probe  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: The Readiness Probe signals whether a container is ready to accept requests. If it fails, Kubernetes removes the pod from the endpoints of any matching Services, shielding it from incoming user traffic until it returns healthy, without killing the process.
- **A is incorrect**: A Liveness Probe would restart the container, which often exacerbates overload situations.
- **C is incorrect**: Startup Probes are used only during initial boot-up.
- **D is incorrect**: "Drain Probe" is not a Kubernetes concept.
</details>

---

## Question 7: Startup Probe Purpose
**Why would an engineer configure a Startup Probe alongside a Liveness Probe for a legacy application?**

A) To allow the application up to several minutes to initialize before the Liveness Probe begins checking and prematurely killing it.  
B) To trigger a canary deployment rollout when startup succeeds.  
C) To bypass the container image entrypoint script.  
D) To execute parallel readiness checks across multiple ports.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: A**

**Explanation:**
- **A is correct**: The Startup Probe disables both Liveness and Readiness probes until the Startup Probe succeeds. This gives slow-starting applications ample time to boot without requiring a dangerously high `initialDelaySeconds` on the Liveness Probe.
- **B, C, & D are incorrect**: Startup probes do not control canary deployments, bypass image entrypoints, or provide multi-port readiness checking.
</details>

---

## Question 8: Secret Types
**Which standard Kubernetes Secret type is specifically intended for storing private container registry credentials used in `imagePullSecrets`?**

A) `kubernetes.io/basic-auth`  
B) `kubernetes.io/tls`  
C) `kubernetes.io/dockerconfigjson`  
D) `Opaque`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: `kubernetes.io/dockerconfigjson` is the standard secret type containing Docker auth configurations (`.dockerconfigjson`) for pulling images from private registries.
- **A is incorrect**: `kubernetes.io/basic-auth` is for HTTP basic auth.
- **B is incorrect**: `kubernetes.io/tls` is for TLS server certificates and private keys.
- **D is incorrect**: `Opaque` is generic; while it can hold data, `kubernetes.io/dockerconfigjson` is the specialized type validated for registry credentials.
</details>

---

## Question 9: Immutable ConfigMaps
**What is the primary operational benefit of marking a ConfigMap with `immutable: true`?**

A) It allows the ConfigMap to exceed the default 1 MiB size limitation.  
B) It protects against unauthorized or accidental updates and significantly reduces API server load by discontinuing kubelet watches.  
C) It automatically encrypts the ConfigMap keys using AES-GCM.  
D) It converts the ConfigMap into an Opaque Secret.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: Setting `immutable: true` prevents changes to the ConfigMap data. Because the data cannot change, kubelets do not need to maintain active watches against the API server, which improves cluster scalability in large clusters.
- **A is incorrect**: The 1 MiB `etcd` limit still applies.
- **C & D are incorrect**: Immutability has nothing to do with encryption or converting types to Secrets.
</details>

---

## Question 10: Secret `stringData` vs `data`
**What happens when a Secret manifest containing fields under `stringData` is submitted to the Kubernetes API server?**

A) The API server rejects the manifest because only `data` is valid.  
B) The API server stores the string as plaintext and disables base64 encoding permanently.  
C) The API server automatically base64-encodes the plaintext values and stores them under the `data` field.  
D) The API server creates a ConfigMap with the same contents.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: `stringData` is a convenience write-only field that allows users to supply unencoded strings in manifests. The API server encodes them into base64 and moves them into the `data` field.
- **A is incorrect**: `stringData` is fully supported in standard Secret schemas.
- **B & D are incorrect**: Secrets always store data base64-encoded in `etcd`, and it does not create a ConfigMap.
</details>

---

## Question 11: Label Selector Syntax
**Which `kubectl` command filters and retrieves all Pods that have the label `tier` set to either `frontend` or `backend`?**

A) `kubectl get pods -l 'tier in (frontend, backend)'`  
B) `kubectl get pods --filter 'tier == frontend || tier == backend'`  
C) `kubectl get pods -a tier=frontend,backend`  
D) `kubectl get pods --annotations 'tier=(frontend, backend)'`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: A**

**Explanation:**
- **A is correct**: Set-based label selectors use the `key in (value1, value2)` syntax.
- **B & C are incorrect**: These are not valid `kubectl` selector flags or syntax.
- **D is incorrect**: Selectors query labels, not annotations.
</details>

---

## Question 12: Probe Handlers
**Which of the following is NOT a valid probe handler supported in Kubernetes?**

A) `httpGet`  
B) `tcpSocket`  
C) `exec`  
D) `udpPing`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: D**

**Explanation:**
- **D is correct**: `udpPing` is not a probe handler in Kubernetes. The four supported handlers are `httpGet`, `tcpSocket`, `exec`, and `grpc`.
</details>

---

## Question 13: Probe HTTP Status Codes
**When using an `httpGet` handler for a Liveness Probe, which HTTP response status codes are considered a SUCCESS?**

A) Any status code equal to `200` only.  
B) Any status code greater than or equal to `200` and less than `400` (`200 <= code < 400`).  
C) Any status code less than `500`.  
D) Any status code including redirects (`301`, `302`) and client errors (`404`).  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: In Kubernetes `httpGet` probes, any HTTP response status code in the 2xx and 3xx range (`>= 200` and `< 400`) is treated as healthy.
- **A is incorrect**: 2xx and 3xx codes (e.g. 204, 301) are also considered healthy.
- **C & D are incorrect**: 4xx codes (client errors like 400, 404) are treated as failures.
</details>

---

## Question 14: Volume-Mounted Secrets Storage Media
**When a Secret is mounted as a volume into a Pod container, what filesystem type does Kubernetes use on the host node?**

A) Persistent NFS volume  
B) Local non-volatile HDD/SSD storage  
C) An in-memory `tmpfs` (RAM) filesystem  
D) An encrypted S3 bucket  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: Kubernetes mounts Secrets into Pods using `tmpfs` (RAM-backed in-memory filesystem). This prevents sensitive data from being written to non-volatile node disks.
- **A, B, & D are incorrect**: Standard Secret volume projection never uses NFS, node persistent disk, or cloud object stores.
</details>

---

## Question 15: Exec Probe Exit Code
**When using an `exec` probe handler, what exit code must the executed command return for the probe to be marked successful?**

A) `0`  
B) `1`  
C) `200`  
D) Any positive integer  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: A**

**Explanation:**
- **A is correct**: Standard POSIX convention dictates that an exit code of `0` indicates success. Any non-zero exit code (1–255) indicates failure to the kubelet.
- **C is incorrect**: 200 is an HTTP status code, not a POSIX command exit code.
</details>

---

## Question 16: Size Limit of ConfigMaps & Secrets
**What is the maximum data size limit for a single ConfigMap or Secret in Kubernetes?**

A) 256 KiB  
B) 1 MiB  
C) 10 MiB  
D) 100 MiB  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: `etcd` enforces a default maximum request size of **1 MiB** per object. For larger configurations or datasets, you should use external object storage, databases, or PersistentVolumes.
</details>

---

## Question 17: Service Selector Matching
**A Service defines `spec.selector` with `app: payment` and `env: staging`. There are three Pods in the namespace:**
- **Pod 1:** `app: payment`
- **Pod 2:** `app: payment`, `env: staging`
- **Pod 3:** `app: payment`, `env: staging`, `tier: backend`

**Which Pods will receive traffic from the Service?**

A) Pod 2 only  
B) Pod 1 and Pod 2  
C) Pod 2 and Pod 3  
D) Pod 1, Pod 2, and Pod 3  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: In Kubernetes Service selectors, the matching criteria is an **AND** operation across all specified selector labels. Pods must have *at least* all the labels in the selector. Both Pod 2 and Pod 3 have `app: payment` AND `env: staging` (Pod 3 has an extra label, which does not prevent matching). Pod 1 is missing `env: staging` so it is excluded.
</details>

---

## Question 18: Removing a Label via CLI
**Which imperative `kubectl` command correctly removes the label `environment` from a Pod named `frontend`?**

A) `kubectl delete label frontend environment`  
B) `kubectl label pod frontend environment-`  
C) `kubectl label pod frontend environment=null`  
D) `kubectl remove-label pod frontend environment`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: In `kubectl`, suffixing a label or annotation key with a minus sign (`-`) removes it from the resource.
- **A, C, & D are incorrect**: None of these are valid commands or syntax.
</details>

---

## Question 19: Probe Parameter Meanings
**Which probe parameter specifies the number of seconds the kubelet waits between successive health check executions?**

A) `initialDelaySeconds`  
B) `timeoutSeconds`  
C) `periodSeconds`  
D) `successThreshold`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: C**

**Explanation:**
- **C is correct**: `periodSeconds` determines the frequency/interval (in seconds) between probe executions (default: 10s).
- **A is incorrect**: `initialDelaySeconds` is the delay before the very first check.
- **B is incorrect**: `timeoutSeconds` is how long to wait for a response before timing out.
- **D is incorrect**: `successThreshold` is the required consecutive successes after failure.
</details>

---

## Question 20: TLS Secret Required Keys
**When creating a Secret of type `kubernetes.io/tls`, which two specific data keys are strictly required?**

A) `cert.pem` and `privkey.pem`  
B) `tls.crt` and `tls.key`  
C) `public.key` and `private.key`  
D) `certificate` and `secret-key`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: The `kubernetes.io/tls` secret specification enforces exactly two keys: `tls.crt` (public certificate) and `tls.key` (private key).
</details>

---

## Question 21: Node Affinity vs `nodeSelector`
**What Kubernetes feature uses key-value labels on nodes to provide the simplest mechanism for scheduling Pods onto specific nodes?**

A) Taints and Tolerations  
B) `nodeSelector`  
C) Pod Topology Spread Constraints  
D) PriorityClasses  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: `nodeSelector` is the simplest mechanism for node selection based on node labels.
- **A is incorrect**: Taints and tolerations repel pods unless tolerated.
- **C is incorrect**: Topology spread constraints distribute pods across failure domains.
- **D is incorrect**: PriorityClasses control scheduling order and preemption.
</details>

---

## Question 22: Secret File Permissions
**When mounting a Secret as a volume, how can an engineer enforce that only the container process owner can read the secret files (read-only mode 0400)?**

A) Set `readOnly: true` on the container spec.  
B) Set `defaultMode: 0400` under `volumes[].secret`.  
C) Set `chmod 400` in the Dockerfile.  
D) Configure an AppArmor profile.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: The `defaultMode` field under `volumes[].secret` sets the POSIX permission mode bits (e.g. `0400` for user read-only).
- **A is incorrect**: `readOnly: true` prevents write operations to the mount point, but does not configure specific POSIX user permissions.
</details>

---

## Question 23: Inactive Liveness Checks During Startup
**What happens to Liveness and Readiness probes while a Startup probe is executing?**

A) They run concurrently at half frequency.  
B) They are disabled and do not run until the Startup probe succeeds.  
C) They immediately fail until the Startup probe finishes.  
D) They are converted to HTTP probes.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: While a Startup probe is active and has not yet succeeded, Liveness and Readiness probes are completely disabled to prevent interference.
</details>

---

## Question 24: Bulk Environment Variable Loading
**An application needs to load 50 configuration keys defined in a single ConfigMap as environment variables without specifying each key manually. What configuration field should be used?**

A) `spec.containers[].envFrom`  
B) `spec.containers[].env.valueFrom`  
C) `spec.containers[].volumeMounts`  
D) `spec.template.metadata.envMap`  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: A**

**Explanation:**
- **A is correct**: `envFrom` with `configMapRef` mounts all key-value pairs from a ConfigMap as environment variables into the container.
- **B is incorrect**: `valueFrom` is for individual key mapping.
</details>

---

## Question 25: Annotations Character Limitations
**Which statement is TRUE regarding Annotations compared to Labels?**

A) Annotations cannot contain punctuation or spaces.  
B) Annotations have much less restrictive syntax and can store large, structured strings like JSON or YAML.  
C) Annotations must be under 63 characters total.  
D) Annotations can be queried in a Service `spec.selector`.  

<details>
<summary><b>View Answer & Explanation</b></summary>

**Correct Answer: B**

**Explanation:**
- **B is correct**: Labels have strict format and character constraints (alphanumeric, max 63 characters) because they are indexed for querying. Annotations are not indexed for querying and can contain arbitrary strings, URLs, and large structured payloads.
</details>
