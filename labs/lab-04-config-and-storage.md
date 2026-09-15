# Lab 04: ConfigMaps, Secrets & Volumes

## Objective
Decouple application configuration using ConfigMaps and Secrets, and attach persistent storage.

---

## Step 1: Create ConfigMap & Secret

```bash
kubectl create configmap web-config --from-literal=ENVIRONMENT=production --from-literal=DB_HOST=mysql.default.svc
kubectl create secret generic web-secret --from-literal=API_KEY=SecretKeyValue999
```

---

## Step 2: Mount Config into Pod as Environment Variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-test-pod
spec:
  containers:
  - name: test
    image: alpine
    command: ["sh", "-c", "env && sleep 3600"]
    envFrom:
    - configMapRef:
        name: web-config
    env:
    - name: API_KEY
      valueFrom:
        secretKeyRef:
          name: web-secret
          key: API_KEY
```

Apply and inspect environment:
```bash
kubectl apply -f config-test-pod.yaml
kubectl logs config-test-pod | grep -E "ENVIRONMENT|DB_HOST|API_KEY"
```
