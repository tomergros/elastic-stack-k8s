# Elastic Stack (Elasticsearch, Kibana, Filebeat) on Kubernetes
Task of elastic-stack-k8s &amp; FireBeat Deployment

By: Tomer Grossman


Personal note:
This task was my first time implementing and deploying ELK stack, it was both educating and challenging at the same time.
___

This project deploys Elasticsearch, Kibana, Filebeat, and a 'Hello World' application on Kubernetes using YAML files.

## Prerequisites

### For Windows (Recommended and tested on: Docker Desktop)
1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. Enable Kubernetes in Docker Desktop:
   - Open Docker Desktop
   - Go to Settings → Kubernetes
   - Check "Enable Kubernetes"
   - Click "Apply & Restart"
3. Install [kubectl](https://kubernetes.io/docs/tasks/tools/)


### Verify Setup
```powershell
kubectl cluster-info
```

## Deployment Steps


### Quick Deploy (Windows PowerShell)
in order to run all the commands at once
```powershell
# Run the automated deployment script
.\deploy.ps1
```

### Manual Deploy
1. **Create Namespace**
   ```powershell
   kubectl apply -f elastic-stack-namespace.yaml
   ```

2. **Deploy Elasticsearch**
   ```powershell
   kubectl apply -f elasticsearch-statefulset.yaml
   kubectl apply -f elasticsearch-service.yaml
   ```

3. **Deploy Kibana**
   ```powershell
   kubectl apply -f kibana-deployment.yaml
   kubectl apply -f kibana-service.yaml
   ```

4. **Deploy Filebeat**
   ```powershell
   kubectl apply -f filebeat-configmap.yaml
   kubectl apply -f filebeat-daemonset.yaml
   ```

5. **Deploy Hello World App**
   ```powershell
   kubectl apply -f hello-world-deployment.yaml
   kubectl apply -f hello-world-service.yaml
   ```

## Access Kibana

### For Docker Desktop (Windows)
Kibana will be automatically available at:
```
http://localhost:5601
```

```

### For Other Clusters
1. Get the NodePort for Kibana:
   ```powershell
   kubectl get svc -n elastic-stack kibana
   ```
   Look for the `NODE-PORT` under the `PORT(S)` column (e.g., `5601:32xxx/TCP`).

2. Open Kibana in your browser:
   ```
   http://<NodeIP>:<NodePort>
   ```

## View Hello World Logs in Kibana

1. In Kibana, go to **Discover**.
2. Set up the default index pattern (usually `filebeat-*`).
3. You should see logs from the Hello World app.

---

**Files:**
- `elastic-stack-namespace.yaml` — Namespace definition
- `elasticsearch-statefulset.yaml` — Elasticsearch StatefulSet
- `elasticsearch-service.yaml` — Elasticsearch Service
- `kibana-deployment.yaml` — Kibana Deployment
- `kibana-service.yaml` — Kibana Service
- `filebeat-configmap.yaml` — Filebeat ConfigMap
- `filebeat-daemonset.yaml` — Filebeat DaemonSet
- `hello-world-deployment.yaml` — Hello World Deployment
- `hello-world-service.yaml` — Hello World Service
- `deploy.ps1` — Automated deployment script for Windows

---

