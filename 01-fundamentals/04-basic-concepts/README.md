# Basic Concepts

This section covers the fundamental concepts that form the foundation of Crossplane. Understanding these concepts is essential for working effectively with Crossplane and building advanced compositions.

## Core Concepts

### Custom Resource Definitions (CRDs)

Crossplane extends Kubernetes using Custom Resource Definitions (CRDs). CRDs allow Crossplane to:

- Define new resource types (like `Bucket`, `DBInstance`, `VPC`)
- Store desired state in etcd (Kubernetes' database)
- Use Kubernetes' API server for resource management
- Leverage Kubernetes' reconciliation loops

### Managed Resources

Managed resources are Kubernetes Custom Resources that represent infrastructure in external systems:

- They follow Kubernetes resource patterns
- They have `spec` (desired state) and `status` (actual state)
- They are reconciled continuously by providers
- They support standard Kubernetes operations (create, read, update, delete)

### Providers

Providers are packages that:

- Connect Crossplane to external APIs
- Translate managed resources to API calls
- Monitor resource health
- Handle authentication and authorization

### Reconciliation

Reconciliation is the process of ensuring actual state matches desired state:

1. You declare desired state (in `spec`)
2. Crossplane detects changes
3. Provider creates/updates/deletes resources
4. Status is updated to reflect actual state
5. Process repeats continuously

## Resource Lifecycle

Understanding resource lifecycle is crucial for working with Crossplane effectively.

### Lifecycle Stages

1. **Pending**: Resource is being created
2. **Creating**: Provider is provisioning the resource
3. **Ready**: Resource is created and ready for use
4. **Updating**: Resource is being modified
5. **Deleting**: Resource is being removed
6. **Deleted**: Resource has been removed

### Status Conditions

Resources use conditions to communicate state:

- **Synced**: Whether resource matches cloud state
- **Ready**: Whether resource is ready for use
- **ProviderHealthy**: Whether provider is functioning

See [resource-lifecycle.md](./resource-lifecycle.md) for detailed information.

## Custom Resource Definitions

CRDs define the schema for managed resources. They specify:

- What fields are required
- What fields are optional
- Field types and validation rules
- Status fields

See [crds.yaml](./crds.yaml) for examples.

## Custom Resources

Custom resources are instances of CRDs. They:

- Store your desired configuration
- Are managed by Kubernetes API server
- Trigger reconciliation when changed
- Support standard Kubernetes operations

See [custom-resources.yaml](./custom-resources.yaml) for examples.

## Resource Status

### Understanding Status Fields

```yaml
status:
  atProvider:
    # Provider-specific status information
    arn: "arn:aws:s3:::my-bucket"
    region: "us-east-1"
  
  conditions:
    - type: Ready
      status: "True"
      reason: Available
    - type: Synced
      status: "True"
      reason: ReconcileSuccess
```

### Status Conditions

Conditions provide detailed state information:

```yaml
conditions:
  - type: Ready
    status: "True"  # or "False", "Unknown"
    reason: Available
    message: "Resource is available"
    lastTransitionTime: "2024-12-24T10:00:00Z"
```

Common condition types:
- **Ready**: Resource is ready for use
- **Synced**: Resource matches cloud state
- **ProviderHealthy**: Provider is functioning

## Finalizers

Finalizers ensure proper cleanup:

```yaml
metadata:
  finalizers:
    - finalizer.managedresource.crossplane.io
```

Finalizers:
- Prevent resource deletion until cleanup is complete
- Ensure cloud resources are properly removed
- Handle deletion order dependencies

## Resource References

### Provider Config References

```yaml
spec:
  providerConfigRef:
    name: default
```

### Secret References

```yaml
spec:
  masterUserPasswordSecretRef:
    namespace: default
    name: my-secret
    key: password
```

### Resource References

```yaml
spec:
  vpcIdRef:
    name: my-vpc
```

## Deletion Policies

Control what happens when resources are deleted:

- **Delete**: Remove from cloud (default)
- **Retain**: Keep in cloud
- **Orphan**: Remove Kubernetes resource but keep in cloud

```yaml
spec:
  deletionPolicy: Retain  # For production databases
```

## Resource Selectors

Selectors allow referencing resources by labels:

```yaml
spec:
  vpcIdSelector:
    matchLabels:
      environment: production
```

## External Name

External name maps Kubernetes resource name to cloud resource name:

```yaml
metadata:
  annotations:
    crossplane.io/external-name: my-cloud-resource-name
```

## Connection Secrets

Resources can write connection information to secrets:

```yaml
spec:
  writeConnectionSecretToRef:
    name: my-connection-secret
    namespace: default
```

## Best Practices

### 1. Use Namespaces

Organize resources by namespace:

```yaml
metadata:
  namespace: production
```

### 2. Add Labels

Use labels for organization and selection:

```yaml
metadata:
  labels:
    environment: production
    team: platform
```

### 3. Set Deletion Policies

Protect critical resources:

```yaml
spec:
  deletionPolicy: Retain
```

### 4. Monitor Status

Regularly check resource status:

```bash
kubectl get <resource-type> -o wide
kubectl describe <resource-type> <name>
```

### 5. Use Selectors

Reference resources using selectors for flexibility:

```yaml
spec:
  vpcIdSelector:
    matchLabels:
      environment: production
```

## Troubleshooting

### Resource Not Ready

```bash
# Check conditions
kubectl get <resource> <name> -o jsonpath='{.status.conditions}'

# Check events
kubectl describe <resource> <name>
```

### Resource Not Syncing

```bash
# Check provider health
kubectl get provider <provider-name>

# Check provider logs
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=<provider-name>
```

### Resource Stuck

```bash
# Check finalizers
kubectl get <resource> <name> -o jsonpath='{.metadata.finalizers}'

# Check for errors
kubectl describe <resource> <name> | grep -i error
```

## Next Steps

Now that you understand the basic concepts:

1. **Create Compositions** - Learn to combine resources into reusable patterns
2. **Build Composite Resources** - Create custom APIs for your platform
3. **Use Composition Functions** - Add advanced logic with Python, Go, or KCL

## Additional Resources

- [Crossplane Concepts](https://docs.crossplane.io/latest/concepts/)
- [Kubernetes CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [Resource Lifecycle](https://docs.crossplane.io/latest/concepts/managed-resources/#resource-lifecycle)

---

**Ready for advanced topics?** Move on to [Compositions](../../02-compositions/)!
