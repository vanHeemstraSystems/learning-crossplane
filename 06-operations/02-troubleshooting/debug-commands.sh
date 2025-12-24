#!/bin/bash
# Common Crossplane debugging commands

echo "=== Crossplane Pods ==="
kubectl get pods -n crossplane-system

echo -e "\n=== Composition Functions ==="
kubectl get functions

echo -e "\n=== Providers ==="
kubectl get providers

echo -e "\n=== XRDs ==="
kubectl get xrd

echo -e "\n=== Compositions ==="
kubectl get compositions
