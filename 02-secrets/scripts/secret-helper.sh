#!/usr/bin/env bash
# ==============================================================================
# KCNA Secrets Helper Script
# Demonstrates Base64 encoding/decoding and secret inspection with kubectl
# ==============================================================================

set -euo pipefail

echo "================================================================="
echo "🔐 KCNA Secret Demonstration: Base64 Encoding vs Encryption"
echo "================================================================="

ORIGINAL_PASSWORD="SuperSecretKCNA2026!#"
echo "1. Original Plaintext: ${ORIGINAL_PASSWORD}"

# Base64 encode
ENCODED=$(echo -n "${ORIGINAL_PASSWORD}" | base64)
echo "2. Base64 Encoded:     ${ENCODED}"

# Base64 decode
DECODED=$(echo -n "${ENCODED}" | base64 --decode)
echo "3. Decoded Back:       ${DECODED}"

echo ""
echo "⚠️  CRITICAL KCNA EXAM TIP:"
echo "   Base64 is NOT encryption! Anyone with read access to etcd or"
echo "   kubectl get secret can decode it. To truly encrypt at rest,"
echo "   Kubernetes requires an EncryptionConfiguration provider or KMS plugin."
echo "================================================================="

if kubectl cluster-info >/dev/null 2>&1; then
  echo ""
  echo "Inspecting active cluster secret (db-credentials)..."
  if kubectl get secret db-credentials >/dev/null 2>&1; then
    echo "Decoded DB_USER from active secret:"
    kubectl get secret db-credentials -o jsonpath="{.data.DB_USER}" | base64 --decode
    echo ""
    echo "Decoded DB_PASSWORD from active secret:"
    kubectl get secret db-credentials -o jsonpath="{.data.DB_PASSWORD}" | base64 --decode
    echo ""
  fi
fi
