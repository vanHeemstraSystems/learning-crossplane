#!/bin/bash
# Install Crossplane using Helm

set -e

NAMESPACE=${1:-crossplane-system}

echo "Installing Crossplane to namespace: $NAMESPACE"

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane \
  --namespace $NAMESPACE \
  --create-namespace \
  crossplane-stable/crossplane

echo "Waiting for Crossplane to be ready..."
kubectl wait --for=condition=ready pod -l app=crossplane -n $NAMESPACE --timeout=300s

echo "Crossplane installed successfully!"
