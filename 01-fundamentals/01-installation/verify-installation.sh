#!/bin/bash
# Verify Crossplane installation

echo "Checking Crossplane pods..."
kubectl get pods -n crossplane-system

echo -e "\nChecking Crossplane CRDs..."
kubectl get crds | grep crossplane

echo -e "\nCrossplane version:"
kubectl get deployment crossplane -n crossplane-system -o jsonpath='{.spec.template.spec.containers[0].image}'

echo -e "\n\nInstallation verification complete!"
