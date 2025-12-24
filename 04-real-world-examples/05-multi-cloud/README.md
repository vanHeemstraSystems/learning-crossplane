# Multi-Cloud Platform

A platform that abstracts cloud provider differences, enabling the same API to work across AWS, Azure, and GCP.

## Overview

This example demonstrates how to build a multi-cloud platform that:

- Provides cloud-agnostic APIs
- Supports multiple cloud providers
- Enables provider selection
- Maintains consistency across clouds

## Architecture

```
Developer creates Resource XR
    ↓
XRD validates input
    ↓
Provider selection logic
    ↓
Cloud-specific Composition selected
    ↓
Resources created in selected cloud
```

## Components

### 1. Provider Selection

Mechanism to select which cloud provider to use:
- Label-based selection
- Annotation-based selection
- Environment-based selection

See [provider-selection.yaml](./provider-selection.yaml)

### 2. Cloud-Specific Compositions

Different compositions for different clouds:
- **AWS Composition**: Creates AWS resources
- **Azure Composition**: Creates Azure resources
- **GCP Composition**: Creates GCP resources

See composition files in this directory.

## Installation

### Step 1: Install XRD

```bash
kubectl apply -f provider-selection.yaml
```

### Step 2: Install Compositions

```bash
kubectl apply -f aws-composition.yaml
kubectl apply -f azure-composition.yaml
kubectl apply -f gcp-composition.yaml
```

### Step 3: Create Multi-Cloud Resource

```yaml
apiVersion: storage.example.org/v1alpha1
kind: Bucket
metadata:
  name: my-bucket
  labels:
    provider: aws  # or azure, gcp
spec:
  name: my-bucket
  region: us-east-1
```

## Usage Examples

### AWS Bucket

```yaml
apiVersion: storage.example.org/v1alpha1
kind: Bucket
metadata:
  name: aws-bucket
  labels:
    provider: aws
spec:
  name: my-aws-bucket
  region: us-east-1
```

### Azure Storage Account

```yaml
apiVersion: storage.example.org/v1alpha1
kind: Bucket
metadata:
  name: azure-storage
  labels:
    provider: azure
spec:
  name: myazurestorage
  location: eastus
```

### GCP Bucket

```yaml
apiVersion: storage.example.org/v1alpha1
kind: Bucket
metadata:
  name: gcp-bucket
  labels:
    provider: gcp
spec:
  name: my-gcp-bucket
  location: us-central1
```

## Features

### Provider Abstraction

Same API works across all clouds:
- Same XRD schema
- Different compositions per cloud
- Provider-specific details hidden

### Provider Selection

Multiple ways to select provider:
- Labels
- Annotations
- Environment variables
- Composition functions

### Consistency

Maintains consistency:
- Same API across clouds
- Similar behavior
- Unified management

## Best Practices Demonstrated

1. **Abstraction**: Hide cloud-specific details
2. **Consistency**: Same API across clouds
3. **Flexibility**: Easy provider switching
4. **Documentation**: Clear provider differences

## Troubleshooting

### Wrong Provider Selected

```bash
# Check labels
kubectl get bucket my-bucket -o yaml | grep labels

# Check available compositions
kubectl get composition
```

### Provider Not Available

```bash
# Check provider health
kubectl get provider

# Check provider config
kubectl get providerconfig
```

## Next Steps

1. **Customize**: Adapt to your multi-cloud needs
2. **Add Providers**: Add more cloud providers
3. **Provider Migration**: Plan cloud migrations
4. **Production**: Deploy in your production environment

## Additional Resources

- [Multi-Cloud Patterns](https://docs.crossplane.io/latest/concepts/composition/)
- [Provider Selection](https://docs.crossplane.io/latest/concepts/composition/#composition-selection)

---

**Congratulations!** You've completed the Real-World Examples section!
