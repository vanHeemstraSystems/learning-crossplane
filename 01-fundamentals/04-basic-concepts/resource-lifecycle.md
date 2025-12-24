# Resource Lifecycle

Understanding how Crossplane manages resource lifecycle is essential for effective infrastructure management.

## Overview

Crossplane follows Kubernetes' declarative model where you specify **what** you want, and Crossplane figures out **how** to create it. The lifecycle management ensures that the actual state in the cloud always matches your desired state.

## Lifecycle Stages

### 1. Creation Phase

When you create a managed resource:

```yaml
apiVersion: s3.aws.crossplane.io/v1beta1
kind: Bucket
metadata:
  name: my-bucket
spec:
  forProvider:
    bucket: my-bucket
    region: us-east-1
```

**What happens:**
1. Resource is created in Kubernetes API server
2. Crossplane detects the new resource
3. Provider receives the resource specification
4. Provider calls cloud API to create the resource
5. Status is updated as creation progresses

**Observing creation:**
```bash
# Watch the resource
kubectl get bucket my-bucket -w

# Check status
kubectl describe bucket my-bucket
```

### 2. Reconciliation Phase

After creation, Crossplane continuously reconciles:

**Reconciliation loop:**
1. Crossplane reads desired state from `spec`
2. Provider checks actual state in cloud
3. If different, provider updates cloud resource
4. Status is updated with current state
5. Process repeats (typically every few minutes)

**Reconciliation triggers:**
- Periodic reconciliation (default: every 1 hour)
- Resource changes (spec modifications)
- Provider health checks
- Manual reconciliation (via annotations)

### 3. Update Phase

When you modify a resource:

```bash
# Edit the resource
kubectl edit bucket my-bucket
```

**What happens:**
1. Spec is updated in Kubernetes
2. Crossplane detects the change
3. Provider compares desired vs actual state
4. Provider updates cloud resource if needed
5. Status reflects update progress

**Update policies:**
- **Automatic**: Updates happen automatically
- **Manual**: Updates require manual approval

### 4. Deletion Phase

When you delete a resource:

```bash
kubectl delete bucket my-bucket
```

**What happens:**
1. Resource is marked for deletion
2. Finalizers prevent immediate deletion
3. Provider deletes cloud resource
4. Finalizers are removed
5. Resource is deleted from Kubernetes

**Deletion policies:**
- **Delete**: Remove from cloud (default)
- **Retain**: Keep in cloud
- **Orphan**: Remove Kubernetes resource, keep in cloud

## Status Conditions

Resources use conditions to communicate state:

### Ready Condition

Indicates if resource is ready for use:

```yaml
status:
  conditions:
    - type: Ready
      status: "True"
      reason: Available
      message: "Resource is available"
```

**Possible values:**
- `True`: Resource is ready
- `False`: Resource is not ready (check reason)
- `Unknown`: State is unknown

### Synced Condition

Indicates if resource matches cloud state:

```yaml
status:
  conditions:
    - type: Synced
      status: "True"
      reason: ReconcileSuccess
```

**Possible values:**
- `True`: Resource is in sync
- `False`: Resource is out of sync
- `Unknown`: Sync state is unknown

### ProviderHealthy Condition

Indicates if provider is functioning:

```yaml
status:
  conditions:
    - type: ProviderHealthy
      status: "True"
      reason: ProviderHealthy
```

## Status Fields

### AtProvider

Provider-specific status information:

```yaml
status:
  atProvider:
    arn: "arn:aws:s3:::my-bucket"
    region: "us-east-1"
    creationDate: "2024-12-24T10:00:00Z"
```

### ObservedGeneration

Tracks which generation of the resource has been observed:

```yaml
status:
  observedGeneration: 2
```

This helps detect if reconciliation is up to date.

## Finalizers

Finalizers ensure proper cleanup:

```yaml
metadata:
  finalizers:
    - finalizer.managedresource.crossplane.io
```

**How finalizers work:**
1. Resource deletion is requested
2. Finalizer prevents deletion
3. Provider cleans up cloud resource
4. Finalizer is removed
5. Resource is deleted

**Common finalizers:**
- `finalizer.managedresource.crossplane.io`: Standard managed resource finalizer
- Custom finalizers for complex cleanup

## Reconciliation

### Automatic Reconciliation

Crossplane automatically reconciles resources:

- **Default interval**: 1 hour
- **Configurable**: Via provider configuration
- **Event-driven**: Immediate reconciliation on changes

### Manual Reconciliation

Force immediate reconciliation:

```bash
# Add annotation to trigger reconciliation
kubectl annotate bucket my-bucket \
  crossplane.io/paused=false \
  --overwrite
```

### Pausing Reconciliation

Temporarily pause reconciliation:

```bash
# Pause reconciliation
kubectl annotate bucket my-bucket \
  crossplane.io/paused=true
```

## Resource Dependencies

### Dependency Management

Resources can depend on other resources:

```yaml
# Subnet depends on VPC
spec:
  forProvider:
    vpcIdRef:
      name: my-vpc
```

**Dependency resolution:**
1. Crossplane identifies dependencies
2. Creates resources in dependency order
3. Waits for dependencies to be ready
4. Creates dependent resources

### Dependency Errors

If a dependency fails:

```yaml
status:
  conditions:
    - type: Ready
      status: "False"
      reason: DependencyNotReady
      message: "VPC my-vpc is not ready"
```

## Error Handling

### Common Errors

**Provider Not Ready:**
```yaml
status:
  conditions:
    - type: Ready
      status: "False"
      reason: ProviderNotReady
```

**Invalid Configuration:**
```yaml
status:
  conditions:
    - type: Ready
      status: "False"
      reason: InvalidConfiguration
      message: "Bucket name is invalid"
```

**API Error:**
```yaml
status:
  conditions:
    - type: Ready
      status: "False"
      reason: APIError
      message: "Access denied"
```

### Error Recovery

Most errors are recoverable:

1. Fix the issue (e.g., correct configuration)
2. Resource will reconcile automatically
3. Status will update when fixed

## Best Practices

### 1. Monitor Status

Regularly check resource status:

```bash
# Watch resources
kubectl get <resource-type> -w

# Check conditions
kubectl get <resource-type> -o jsonpath='{.items[*].status.conditions}'
```

### 2. Set Appropriate Deletion Policies

```yaml
# For production databases
spec:
  deletionPolicy: Retain

# For development resources
spec:
  deletionPolicy: Delete
```

### 3. Use Finalizers Appropriately

Finalizers are added automatically. Don't remove them unless necessary.

### 4. Handle Dependencies

Ensure dependencies are created first:

```yaml
# Create VPC first
kubectl apply -f vpc.yaml

# Wait for VPC to be ready
kubectl wait --for=condition=Ready vpc/my-vpc

# Then create dependent resources
kubectl apply -f subnet.yaml
```

### 5. Monitor Reconciliation

Set up alerts for:
- Resources stuck in "Creating"
- Resources with failed conditions
- Provider health issues

## Troubleshooting Lifecycle Issues

### Resource Stuck in Creating

```bash
# Check events
kubectl describe <resource> <name>

# Check provider logs
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=<provider>

# Check for errors
kubectl get <resource> <name> -o yaml | grep -A 10 "conditions:"
```

### Resource Not Updating

```bash
# Check if update is blocked
kubectl get <resource> <name> -o jsonpath='{.spec.updatePolicy}'

# Force reconciliation
kubectl annotate <resource> <name> crossplane.io/paused=false --overwrite
```

### Resource Not Deleting

```bash
# Check finalizers
kubectl get <resource> <name> -o jsonpath='{.metadata.finalizers}'

# Check deletion errors
kubectl describe <resource> <name> | grep -A 5 "Events:"

# If stuck, remove finalizer (use with caution)
kubectl patch <resource> <name> -p '{"metadata":{"finalizers":[]}}' --type=merge
```

## Summary

Understanding resource lifecycle helps you:

- ✅ Know what to expect during resource operations
- ✅ Troubleshoot issues effectively
- ✅ Design reliable infrastructure
- ✅ Monitor resource health

---

**Next:** Learn about [Custom Resource Definitions](./crds.yaml) and [Custom Resources](./custom-resources.yaml)
