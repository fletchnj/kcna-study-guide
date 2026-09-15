# Module 02: Secrets 🔐

Kubernetes Secrets let you store and manage sensitive information, such as passwords, OAuth tokens, and SSH keys. Storing this information in a Secret is more secure and flexible than putting it verbatim in a Pod definition or container image.

---

## 🎯 KCNA Exam Highlights: What You Must Know

### 1. The #1 Exam Trap: Base64 Is NOT Encryption!
- By default, Kubernetes Secrets stored in `etcd` are merely **Base64-encoded strings**, not cryptographically encrypted!
- Anyone with API access (`kubectl get secret -o yaml`) or access to the `etcd` datastore can decode the payload instantly using `base64 --decode`.
- **How to achieve real encryption?**
  - Enable **Encryption at Rest** in the API server using an `EncryptionConfiguration` file (using providers like `aescbc` or `secretbox`).
  - Use a **KMS (Key Management Service) Provider** integration (e.g., AWS KMS, Google Cloud KMS, Azure Key Vault, HashiCorp Vault) for envelope encryption.
  - Use external secret controllers such as the **External Secrets Operator (ESO)** or **Vault CSI Provider**.

### 2. Standard Secret Types
Kubernetes classifies Secrets by their `type` field to enable validation:

| Secret Type | Common Keys / Usage | Description |
| :--- | :--- | :--- |
| `Opaque` | Arbitrary user keys | Default type for generic secret data. |
| `kubernetes.io/tls` | `tls.crt`, `tls.key` | Used for TLS/SSL certificates (e.g., Ingress TLS termination). |
| `kubernetes.io/dockerconfigjson` | `.dockerconfigjson` | Credentials for authenticating with private container registries (`imagePullSecrets`). |
| `kubernetes.io/service-account-token` | `token`, `ca.crt`, `namespace` | Automatically managed token for Pods calling the API server. |
| `kubernetes.io/basic-auth` | `username`, `password` | Basic HTTP authentication. |
| `kubernetes.io/ssh-auth` | `ssh-privatekey` | SSH private keys. |

### 3. `data` vs. `stringData`
- `data`: Expects **base64-encoded** strings.
- `stringData`: Convenience write-only field that accepts **plaintext** strings. Kubernetes automatically base64-encodes the content upon writing to `etcd`. When retrieved via `kubectl get secret -o yaml`, it appears under `data`.

### 4. Secret In-Memory Security
When a Secret is mounted as a volume:
- The kubelet mounts it as an **in-memory `tmpfs` volume**.
- The secret is **never written to non-volatile node disk storage**.
- You can enforce file permission isolation using `defaultMode: 0400` (read-only by container user).

---

## 💻 Imperative CLI Commands (KCNA Speed Cheatsheet)

```bash
# 1. Create a generic (Opaque) secret from literal values
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=P@ssw0rd123

# 2. Create a secret from an existing file
kubectl create secret generic ssh-key-secret \
  --from-file=id_rsa=/home/user/.ssh/id_rsa

# 3. Create a TLS secret
kubectl create secret tls web-tls \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key

# 4. Create a docker-registry secret for private image pull
kubectl create secret docker-registry my-registry-key \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=myuser \
  --docker-password=mypass \
  --docker-email=user@example.com

# 5. Decode secret value from terminal in one line
kubectl get secret db-credentials -o jsonpath='{.data.password}' | base64 --decode
```

---

## 🧪 Hands-On Lab Walkthrough

### Step 1: Run the Secret Helper Script
Observe Base64 encoding/decoding mechanics:
```bash
./scripts/secret-helper.sh
```

### Step 2: Apply the Secret Manifests
```bash
kubectl apply -f 01-opaque-secret.yaml
kubectl apply -f 02-tls-secret.yaml
```

Inspect the secret resources:
```bash
kubectl get secrets
kubectl describe secret db-credentials
kubectl describe secret web-tls-cert
```

### Step 3: Run the Consumer Pod
```bash
kubectl apply -f 03-demo-pod.yaml
```

Check the pod logs to verify secret injection and in-memory file permissions:
```bash
kubectl logs secret-demo-pod
```

### Step 4: Clean Up
```bash
kubectl delete -f 03-demo-pod.yaml
kubectl delete -f 02-tls-secret.yaml
kubectl delete -f 01-opaque-secret.yaml
```

---

## ❓ KCNA Quick Check

**Q1: What is the primary security limitation of standard Kubernetes Secrets out of the box?**
- A) They can only store 512 bytes of data.
- B) They are base64 encoded and not encrypted at rest by default.
- C) They cannot be mounted as volumes.
- D) They can only be accessed by cluster administrators.

*Correct Answer: **B**. Kubernetes Secrets are encoded in Base64 for data transport, but require an explicit `EncryptionConfiguration` or KMS plugin to achieve encryption at rest.*
