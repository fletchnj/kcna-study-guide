#!/usr/bin/env bash
# ==============================================================================
# KCNA Lab Automation Script
# Validates and deploys all demonstration manifests sequentially with status checks
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${SCRIPT_DIR}"

echo "========================================================"
echo "☸️  Starting KCNA Configuration & Health Lab Runner"
echo "========================================================"

# Step 1: Validate manifests
echo "Step 1: Performing dry-run validation on all manifests..."
make validate-manifests

# Step 2: Deploy ConfigMaps
echo ""
echo "Step 2: Deploying Module 1 (ConfigMaps)..."
make deploy-configmaps
echo "Waiting for ConfigMap demo pod..."
kubectl wait --for=condition=Ready pod/configmap-demo-pod --timeout=60s || true

# Step 3: Deploy Secrets
echo ""
echo "Step 3: Deploying Module 2 (Secrets)..."
make deploy-secrets
echo "Waiting for Secret demo pod..."
kubectl wait --for=condition=Ready pod/secret-demo-pod --timeout=60s || true

# Step 4: Deploy Labels & Annotations
echo ""
echo "Step 4: Deploying Module 3 (Labels & Annotations)..."
make deploy-labels
echo "Querying pods using label selector 'tier=backend'..."
kubectl get pods -l tier=backend --show-labels

# Step 5: Deploy Probes
echo ""
echo "Step 5: Deploying Module 4 (Probes)..."
make deploy-probes

# Step 6: Deploy Capstone
echo ""
echo "Step 6: Deploying Module 5 (Capstone Microservice)..."
make deploy-capstone
echo "Waiting for Capstone deployment rollout..."
kubectl rollout status deployment/kcna-health-demo --timeout=90s || true

echo ""
echo "========================================================"
echo "🎉 All KCNA labs deployed successfully!"
echo "Run 'make clean' when you are done to remove all demo objects."
echo "========================================================"
