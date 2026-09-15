#!/usr/bin/env bash
# ==============================================================================
# KCNA Lab Setup Script
# Checks local tools (kubectl, kind/minikube/k3d) and assists in cluster readiness
# ==============================================================================

set -euo pipefail

echo "========================================================"
echo "☸️  KCNA Exam Prep: Local Cluster Setup & Health Check"
echo "========================================================"

# 1. Check kubectl
if command -v kubectl >/dev/null 2>&1; then
    KUBECTL_VERSION=$(kubectl version --client -o json 2>/dev/null | grep gitVersion || kubectl version --client 2>/dev/null | head -n 1)
    echo "✅ kubectl is installed: ${KUBECTL_VERSION}"
else
    echo "❌ kubectl is NOT installed. Please install kubectl before continuing:"
    echo "   https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

# 2. Check cluster connectivity
echo "Checking connection to Kubernetes cluster..."
if kubectl cluster-info >/dev/null 2>&1; then
    echo "✅ Successfully connected to Kubernetes cluster:"
    kubectl cluster-info | head -n 2
    echo ""
    echo "Current context: $(kubectl config current-context)"
else
    echo "⚠️  No reachable Kubernetes cluster found."
    echo "Please start a local cluster using one of the following:"
    echo "  - Kind:     kind create cluster --name kcna-lab"
    echo "  - Minikube: minikube start"
    echo "  - k3d:      k3d cluster create kcna-lab"
    exit 1
fi

echo "========================================================"
echo "🎉 Cluster is ready for KCNA Configuration & Health labs!"
echo "========================================================"
