# Command Cheat Sheet

## Installation
```bash
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
```

## Common Commands
```bash
# List XRDs
kubectl get xrd

# List Compositions
kubectl get compositions

# List Providers
kubectl get providers

# Check composition
crossplane render xr.yaml composition.yaml functions.yaml
```

## Coming Soon
Complete command reference.
