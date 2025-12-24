# Managed Resources

Managed resources are the building blocks of infrastructure in Crossplane. They represent actual cloud resources (like S3 buckets, databases, networks) that Crossplane creates and manages in your cloud provider.

## What are Managed Resources?

Managed resources are:
- **Kubernetes Custom Resources** that represent infrastructure
- **Declarative** - you specify what you want, not how to create it
- **Reconciled** - Crossplane continuously ensures actual state matches desired state
- **Cloud-agnostic** - same patterns work across different providers (with provider-specific details)

## Understanding Managed Resources

### Resource Structure

Every managed resource follows this pattern:

```yaml
apiVersion: <provider>.<group>/v1beta1
kind: <ResourceType>
metadata:
  name: my-resource
spec:
  # Resource-specific configuration
  forProvider:
    # Provider-specific fields
  providerConfigRef:
    name: default  # Which provider config to use
```

### Resource Lifecycle

1. **Creation**: You create a managed resource YAML and apply it
2. **Reconciliation**: Crossplane detects the resource and calls the provider
3. **Provisioning**: The provider creates the resource in the cloud
4. **Monitoring**: Crossplane continuously monitors and reconciles
5. **Deletion**: When you delete the resource, Crossplane deletes it from the cloud

## Creating Your First Managed Resource

### Example: S3 Bucket

Let's create an S3 bucket:

```bash
kubectl apply -f s3-bucket.yaml
```

Check the status:

```bash
kubectl get bucket my-bucket
kubectl describe bucket my-bucket
```

Watch the creation process:

```bash
kubectl get bucket my-bucket -w
```

### Example: RDS Instance

Create a database:

```bash
kubectl apply -f rds-instance.yaml
```

Monitor the creation (RDS takes several minutes):

```bash
kubectl get rdsinstance my-database -w
```

### Example: VPC

Create a network:

```bash
kubectl apply -f vpc.yaml
```

VPCs typically create quickly:

```bash
kubectl get vpc my-vpc
```

## Resource Status

### Checking Resource Status

```bash
# Get resource status
kubectl get <resource-type> <resource-name>

# Detailed status
kubectl describe <resource-type> <resource-name>

# Status in JSON format
kubectl get <resource-type> <resource-name> -o jsonpath='{.status}'
```

### Status Conditions

Managed resources have status conditions:

- **Synced**: Whether the resource is in sync with the cloud
- **Ready**: Whether the resource is ready for use
- **ProviderHealthy**: Whether the provider is healthy

```bash
# Check specific condition
kubectl get bucket my-bucket -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}'
```

## Resource Updates

### Updating a Resource

Simply modify the YAML and reapply:

```bash
# Edit the resource
kubectl edit bucket my-bucket

# Or modify the file and reapply
kubectl apply -f s3-bucket.yaml
```

Crossplane will detect changes and update the cloud resource accordingly.

### Update Policies

Some resources support update policies:

```yaml
spec:
  updatePolicy:
    type: Automatic  # or Manual
```

## Resource Deletion

### Deleting a Resource

```bash
# Delete using kubectl
kubectl delete bucket my-bucket

# Or delete from file
kubectl delete -f s3-bucket.yaml
```

### Deletion Protection

Some resources support deletion protection:

```yaml
spec:
  deletionPolicy: Delete  # or Retain, Orphan
```

- **Delete**: Remove from cloud when Kubernetes resource is deleted
- **Retain**: Keep in cloud even if Kubernetes resource is deleted
- **Orphan**: Remove Kubernetes resource but keep in cloud

## Provider-Specific Resources

### AWS Resources

Common AWS managed resources:
- `Bucket` (S3)
- `DBInstance` (RDS)
- `VPC` (Networking)
- `Subnet` (Networking)
- `SecurityGroup` (EC2)
- `IAMRole` (IAM)

### Azure Resources

Common Azure managed resources:
- `Account` (Storage Account)
- `PostgreSQLServer` (Azure Database)
- `VirtualNetwork` (Networking)
- `ResourceGroup` (Resource Management)

### GCP Resources

Common GCP managed resources:
- `Bucket` (Cloud Storage)
- `DatabaseInstance` (Cloud SQL)
- `Network` (VPC)
- `Subnetwork` (VPC)

## Best Practices

### 1. Use Namespaces

Organize resources by namespace:

```yaml
metadata:
  name: my-bucket
  namespace: production
```

### 2. Add Labels

Use labels for organization:

```yaml
metadata:
  labels:
    environment: production
    team: platform
    managed-by: crossplane
```

### 3. Use Provider Config References

Reference specific provider configs:

```yaml
spec:
  providerConfigRef:
    name: production-aws
```

### 4. Set Deletion Policies

Protect critical resources:

```yaml
spec:
  deletionPolicy: Retain  # For production databases
```

### 5. Monitor Resource Status

Set up monitoring for resource health:

```bash
# Watch all buckets
kubectl get buckets -w

# Check for errors
kubectl get buckets -o json | jq '.items[] | select(.status.conditions[].status=="False")'
```

## Troubleshooting

### Resource Stuck in "Creating"

```bash
# Check resource events
kubectl describe bucket my-bucket

# Check provider logs
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=provider-aws-aws

# Check for errors in status
kubectl get bucket my-bucket -o yaml | grep -A 10 "conditions:"
```

Common issues:
- Insufficient IAM permissions
- Invalid resource configuration
- Provider not healthy
- Network connectivity issues

### Resource Not Updating

```bash
# Check if update is in progress
kubectl get bucket my-bucket -o jsonpath='{.status.conditions}'

# Force reconciliation (if supported)
kubectl annotate bucket my-bucket crossplane.io/paused=false
```

### Resource Deletion Fails

```bash
# Check finalizers
kubectl get bucket my-bucket -o jsonpath='{.metadata.finalizers}'

# Check deletion errors
kubectl describe bucket my-bucket | grep -A 5 "Events:"
```

## Examples

This directory contains example managed resources:

- **s3-bucket.yaml** - Simple S3 bucket
- **rds-instance.yaml** - RDS database instance
- **vpc.yaml** - VPC network

Try applying these examples (after configuring your provider):

```bash
# Apply all examples
kubectl apply -f .

# Check status
kubectl get bucket,rdsinstance,vpc

# Clean up
kubectl delete -f .
```

## Next Steps

Now that you understand managed resources:

1. **Learn Basic Concepts** - Move to [04-basic-concepts](../04-basic-concepts/) to understand resource lifecycle and reconciliation
2. **Create Compositions** - Learn to combine multiple resources into reusable patterns
3. **Build Composite Resources** - Create custom APIs for your platform

## Additional Resources

- [Managed Resource Reference](https://docs.crossplane.io/latest/concepts/managed-resources/)
- [AWS Provider Resources](https://marketplace.upbound.io/providers/upbound/provider-aws-aws/)
- [Resource Status Conditions](https://docs.crossplane.io/latest/concepts/managed-resources/#status-conditions)

---

**Ready to dive deeper?** Learn about [Basic Concepts](../04-basic-concepts/)!
