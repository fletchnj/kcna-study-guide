# Module 04: Health Probes 🩺

Kubernetes uses **Probes** (health checks executed periodically by the local `kubelet` agent on each node) to monitor container lifecycle, guarantee high availability, and prevent traffic from being sent to dead or unresponsive applications.

---

## 🎯 KCNA Exam Highlights: What You Must Know

### 1. The Three Health Probe Types

```
Container Created
       │
       ▼
┌───────────────────────────────┐
│        Startup Probe          │ ──(Fails > Threshold)──► Kills & Restarts Container
└───────────────────────────────┘
       │ (Succeeds)
       ▼
   Both Run Periodically in Parallel:
   ┌────────────────────────────┐       ┌────────────────────────────┐
   │       Liveness Probe       │       │      Readiness Probe       │
   └────────────────────────────┘       └────────────────────────────┘
                 │                                     │
       (Fails > Threshold)                   (Fails > Threshold)
                 │                                     │
                 ▼                                     ▼
        Kills & Restarts                     Removes Pod IP from
           Container                          Service Endpoints
                                             (NO container restart)
```

| Probe Type | Primary Question | Action on Failure | Typical Scenario |
| :--- | :--- | :--- | :--- |
| **Startup Probe** | *Has the application initialized yet?* | Kills container & restarts it per `restartPolicy`. | Legacy Java/Python apps that take 30–120 seconds to load datasets or build caches on startup. |
| **Liveness Probe** | *Is the application alive or permanently stuck?* | Kills container & restarts it per `restartPolicy`. | Process deadlock, unhandled thread lock, memory leak where restarting the process restores operation. |
| **Readiness Probe** | *Is the application ready to handle client traffic?* | Removes Pod IP from all matching Service endpoints. Does **NOT** restart the container. | App is temporarily overloaded, warming caches, or temporarily waiting for a backend database to reconnect. |

---

### 2. The Four Probe Handlers

The kubelet can perform health checks using four different mechanisms:

1. **`httpGet`**:
   - Sends an HTTP `GET` request to the specified IP address, port, and path.
   - Any response code `>= 200` and `< 400` is considered **success**. Codes `>= 400` are failures.
2. **`tcpSocket`**:
   - Attempts to establish a TCP connection to the container's specified port.
   - If the connection can be established, the check is considered **success**.
3. **`exec`**:
   - Executes a command inside the container namespace (e.g., `cat /tmp/healthy` or a custom script).
   - If the command exits with status code `0`, it is **success**; any non-zero exit code is failure.
4. **`grpc`**:
   - Performs a remote procedure call using the gRPC Health Checking Protocol.
   - Supported natively in modern Kubernetes versions.

---

### 3. Probe Configuration Parameters

| Parameter | Default | Description |
| :--- | :--- | :--- |
| `initialDelaySeconds` | `0` | Number of seconds after the container has started before probes are initiated. |
| `periodSeconds` | `10` | How often (in seconds) to perform the probe. |
| `timeoutSeconds` | `1` | Number of seconds after which the probe times out. |
| `successThreshold` | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. Must be `1` for liveness and startup. |
| `failureThreshold` | `3` | When a probe fails, Kubernetes will try `failureThreshold` times before giving up and taking action. |

---

## 🧪 Hands-On Lab Walkthrough

### Lab 1: Observe Liveness Restart
Deploy the liveness probe demo:
```bash
kubectl apply -f 01-liveness-exec.yaml
```

Watch the pod status in real time:
```bash
kubectl get pod liveness-exec-demo -w
```
> After ~30 seconds, you will see the pod status change, and the `RESTARTS` count will increment from `0` to `1`!

Inspect the events to see the kubelet kill signal:
```bash
kubectl describe pod liveness-exec-demo
```
Look for events:
`Warning  Unhealthy  Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory`
`Normal   Killing    Container liveness-tester failed liveness probe, will be restarted`

---

### Lab 2: Observe Readiness Endpoint Removal
Deploy the readiness probe demo and service:
```bash
kubectl apply -f 02-readiness-http.yaml
```

Check endpoints while healthy:
```bash
kubectl get endpoints readiness-service
```
> The endpoints list will show the IP of `readiness-http-demo`.

Now simulate a failure by deleting the `/ready.html` file inside the pod:
```bash
kubectl exec readiness-http-demo -- rm /usr/share/nginx/html/ready.html
```

Check the pod status:
```bash
kubectl get pod readiness-http-demo
```
> Notice the `READY` column changes from `1/1` to `0/1`!
> **Crucially, the container is still `Running` and was NOT killed.**

Check the service endpoints again:
```bash
kubectl get endpoints readiness-service
```
> The endpoint IP has been removed! Clients accessing the service will not be routed to this degraded pod.

Restore the file:
```bash
kubectl exec readiness-http-demo -- sh -c 'echo "back online" > /usr/share/nginx/html/ready.html'
```
Wait 5 seconds and observe `READY` return to `1/1` and the endpoint reinstated!

---

### Lab 3: Clean Up
```bash
kubectl delete -f 04-multi-probe-app.yaml --ignore-not-found
kubectl delete -f 03-startup-probe.yaml --ignore-not-found
kubectl delete -f 02-readiness-http.yaml --ignore-not-found
kubectl delete -f 01-liveness-exec.yaml --ignore-not-found
```

---

## ❓ KCNA Quick Check

**Q1: An application is temporarily overloaded with traffic and responding slowly. If an engineer configured a Liveness Probe with a short timeout, what unwanted side effect will occur?**
- A) The pod will automatically scale up additional replicas.
- B) The kubelet will restart the pod, making the traffic overload even worse across remaining pods.
- C) The pod IP will be safely removed from the service endpoints without restarting.
- D) Kubernetes will convert the liveness probe into a readiness probe automatically.

*Correct Answer: **B**. This is the classic "liveness probe death spiral". For temporary traffic overloading or slow responses, a **Readiness Probe** should be used instead of a Liveness Probe.*
