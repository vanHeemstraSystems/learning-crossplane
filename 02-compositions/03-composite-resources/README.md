# Composite Resources (XRs)

Composite Resources (XRs) are instances of your custom APIs defined by XRDs. They are created by users and transformed by Compositions into managed resources.

## What is a Composite Resource (XR)?

A Composite Resource (XR) is:

- An **instance** of a Composite Resource Definition (XRD)
- Created by **users/developers** to request infrastructure
- **Transformed** by Compositions into managed resources
- Follows the **schema** defined in the XRD

Think of an XR as a "request" for infrastructure that follows your defined pattern.

## XR Types

### Namespaced XRs (v2 Default)

Namespaced XRs exist within a namespace:

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: my-network
  namespace: production  # Namespace-scoped
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
```

**Use when:**
- Resources are namespace-specific
- Teams manage their own infrastructure
- You want namespace isolation

### Cluster-Scoped XRs

Cluster-scoped XRs exist at the cluster level:

```yaml
apiVersion: cluster.example.org/v1alpha1
kind: Cluster
metadata:
  name: production-cluster
  # No namespace - cluster-scoped
spec:
  name: production-k8s
  region: us-east-1
```

**Use when:**
- Resources are shared across namespaces
- Infrastructure is cluster-wide
- You want centralized management

## Creating an XR

### Step 1: Ensure XRD and Composition Exist

```bash
# Check XRD is installed
kubectl get xrd networks.network.example.org

# Check Composition exists
kubectl get composition network-aws
```

### Step 2: Create the XR

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: my-network
  namespace: default
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
  environment: production
```

Apply it:

```bash
kubectl apply -f namespaced-xr.yaml
```

### Step 3: Monitor Creation

```bash
# Watch XR status
kubectl get network my-network -w

# Check detailed status
kubectl describe network my-network

# Check managed resources created
kubectl get managed
```

## XR Status

XRs have status fields that show:

- **Conditions**: Ready, Synced, etc.
- **Resource References**: Which managed resources were created
- **Connection Secrets**: Where connection info is stored
- **Provider-Specific Status**: Custom status from compositions

See `xr-status.yaml` for examples.

### Checking Status

```bash
# Get status summary
kubectl get network my-network

# Get detailed status
kubectl get network my-network -o yaml

# Check conditions
kubectl get network my-network -o jsonpath='{.status.conditions}'
```

## XR Lifecycle

### Creation

1. User creates XR
2. Crossplane validates against XRD schema
3. Crossplane finds matching Composition
4. Composition creates managed resources
5. Providers provision infrastructure
6. Status updates as resources are created

### Updates

1. User modifies XR spec
2. Crossplane detects changes
3. Composition updates managed resources
4. Providers update infrastructure
5. Status reflects updates

### Deletion

1. User deletes XR
2. Composition deletes managed resources
3. Providers remove infrastructure
4. XR is removed from Kubernetes

## Working with XRs

### Listing XRs

```bash
# List all XRs of a type
kubectl get networks

# List across all namespaces
kubectl get networks --all-namespaces

# List with more details
kubectl get networks -o wide
```

### Getting XR Details

```bash
# Describe XR
kubectl describe network my-network

# Get full YAML
kubectl get network my-network -o yaml

# Get JSON
kubectl get network my-network -o json
```

### Updating XRs

```bash
# Edit interactively
kubectl edit network my-network

# Apply updated YAML
kubectl apply -f updated-xr.yaml

# Patch directly
kubectl patch network my-network --type='json' \
  -p='[{"op": "replace", "path": "/spec/region", "value": "us-west-2"}]'
```

### Deleting XRs

```bash
# Delete by name
kubectl delete network my-network

# Delete from file
kubectl delete -f namespaced-xr.yaml

# Delete all in namespace
kubectl delete networks --all -n production
```

## Connection Secrets

XRs can write connection information to secrets:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: network-connection
    namespace: default
```

Access the secret:

```bash
# Get secret
kubectl get secret network-connection -o yaml

# View secret data
kubectl get secret network-connection -o jsonpath='{.data}'
```

## XR Dependencies

XRs can reference other XRs:

```yaml
spec:
  networkRef:
    name: shared-network
    namespace: infrastructure
```

## Best Practices

### 1. Use Namespaces

Organize XRs by namespace:

```yaml
metadata:
  namespace: production
```

### 2. Add Labels

Use labels for organization:

```yaml
metadata:
  labels:
    environment: production
    team: platform
```

### 3. Validate Before Creating

Ensure XR matches XRD schema:

```bash
# Dry-run
kubectl apply --dry-run=client -f xr.yaml
```

### 4. Monitor Status

Regularly check XR status:

```bash
kubectl get networks -w
```

### 5. Use Connection Secrets

Write connection info for applications:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: app-connection
```

## Troubleshooting

### XR Not Creating Resources

```bash
# Check XR status
kubectl describe network my-network

# Check for composition match
kubectl get composition

# Check XRD
kubectl get xrd networks.network.example.org
```

### XR Stuck in Creating

```bash
# Check conditions
kubectl get network my-network -o jsonpath='{.status.conditions}'

# Check managed resources
kubectl get managed

# Check events
kubectl describe network my-network
```

### Schema Validation Errors

```bash
# Check validation errors
kubectl get network my-network -o yaml | grep -A 5 "conditions"

# Verify XR matches XRD schema
kubectl get xrd networks.network.example.org -o yaml | grep -A 20 "schema"
```

## Examples

This directory contains example XRs:

- **namespaced-xr.yaml** - Namespaced XR example
- **cluster-xr.yaml** - Cluster-scoped XR example
- **xr-status.yaml** - XR with status examples

## Next Steps

Now that you understand XRs:

1. **Create Your Own** - Define XRDs and Compositions for your use case
2. **Use Functions** - Learn about Composition Functions for advanced logic
3. **Production Patterns** - Deploy XRs in production environments

## Additional Resources

- [Composite Resources Documentation](https://docs.crossplane.io/latest/concepts/composite-resources/)
- [XR Status Reference](https://docs.crossplane.io/latest/concepts/composite-resources/#status)
- [Working with XRs](https://docs.crossplane.io/latest/concepts/composite-resources/#working-with-xrs)

---

**Ready for migration?** Learn about [v2 Migration](../04-v2-migration/)!
