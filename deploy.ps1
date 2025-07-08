# Elastic Stack Deployment Script for Windows
# Prerequisites: Docker Desktop with Kubernetes enabled

Write-Host "Deploying Elastic Stack on Kubernetes..." -ForegroundColor Green

# Check if kubectl is available
try {
    kubectl version --client
} catch {
    Write-Host "kubectl not found. Please install kubectl first." -ForegroundColor Red
    exit 1
}

# Check if Kubernetes is running
try {
    kubectl cluster-info
} catch {
    Write-Host "Kubernetes cluster not accessible. Please ensure Docker Desktop Kubernetes is enabled." -ForegroundColor Red
    exit 1
}

Write-Host "Kubernetes cluster is accessible" -ForegroundColor Green

# Deploy namespace
Write-Host "Creating namespace ..." -ForegroundColor Yellow
kubectl apply -f elastic-stack-namespace.yaml

# Deploy Elasticsearch
Write-Host "Deploying Elasticsearch ..." -ForegroundColor Yellow
kubectl apply -f elasticsearch-statefulset.yaml
kubectl apply -f elasticsearch-service.yaml

# Wait for Elasticsearch to be ready
Write-Host "Waiting for Elasticsearch to be ready ..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=elasticsearch -n elastic-stack --timeout=300s

# Deploy Kibana
Write-Host "Deploying Kibana ..." -ForegroundColor Yellow
kubectl apply -f kibana-deployment.yaml
kubectl apply -f kibana-service.yaml

# Deploy Filebeat
Write-Host "Deploying Filebeat ..." -ForegroundColor Yellow
kubectl apply -f filebeat-configmap.yaml
kubectl apply -f filebeat-daemonset.yaml

# Deploy Hello World app
Write-Host "Deploying Hello World app ..." -ForegroundColor Yellow
kubectl apply -f hello-world-deployment.yaml
kubectl apply -f hello-world-service.yaml

# Wait for all pods to be ready
Write-Host "Waiting for all pods to be ready ..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=kibana -n elastic-stack --timeout=300s
kubectl wait --for=condition=ready pod -l app=hello-world -n elastic-stack --timeout=300s

# Show status
Write-Host "Deployment Status:" -ForegroundColor Green
kubectl get pods -n elastic-stack
kubectl get svc -n elastic-stack

Write-Host "Deployment completed!" -ForegroundColor Green
Write-Host "Access Kibana at: http://localhost:5601" -ForegroundColor Cyan
Write-Host "Access Hello World app at: http://localhost:5678" -ForegroundColor Cyan

Write-Host "To view logs:" -ForegroundColor Yellow
Write-Host "kubectl logs -f -l app=hello-world -n elastic-stack" -ForegroundColor White 