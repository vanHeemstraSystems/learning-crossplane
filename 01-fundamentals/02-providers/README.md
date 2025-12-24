# Crossplane Providers

Providers are Crossplane's way of connecting to external systems like cloud providers, databases, and other services. This guide covers installing and configuring providers.

## What are Providers?

Providers are Kubernetes packages that:
- **Connect** Crossplane to external APIs (AWS, Azure, GCP, etc.)
- **Translate** Crossplane resources to provider-specific API calls
- **Monitor** resource health and status
- **Reconcile** desired state with actual state

Think of providers as "drivers" that enable Crossplane to manage resources in external systems.

## Provider Types

### Infrastructure Providers

Manage cloud infrastructure resources:
- **AWS Provider** (`provider-aws-aws`) - S3, RDS, VPC, EC2, etc.
- **Azure Provider** (`provider-azure-azure`) - Storage, SQL, Virtual Networks, etc.
- **GCP Provider** (`provider-gcp-gcp`) - Cloud Storage, Cloud SQL, VPC, etc.

### Kubernetes Provider

Manages Kubernetes resources within your cluster:
- **Kubernetes Provider** (`provider-kubernetes`) - Deployments, Services, ConfigMaps, etc.

### Other Providers

Many other providers exist for databases, messaging systems, monitoring tools, etc.

## Installing Providers

### Method 1: Using Crossplane CLI (Recommended)

```bash
# Install AWS provider
crossplane providers install provider-aws-aws:v1.0.0

# Install Azure provider
crossplane providers install provider-azure-azure:v1.0.0

# Install GCP provider
crossplane providers install provider-gcp-gcp:v1.0.0

# Install Kubernetes provider
crossplane providers install provider-kubernetes:v1.0.0
```

### Method 2: Using kubectl

Create a Provider resource:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-aws
spec:
  package: xpkg.upbound.io/upbound/provider-aws-aws:v1.0.0
```

Apply it:

```bash
kubectl apply -f provider-aws.yaml
```

## Verifying Provider Installation

### Check Provider Status

```bash
# List all providers
kubectl get providers

# Check provider details
kubectl describe provider provider-aws-aws
```

Expected output:
```
NAME                INSTALLED   HEALTHY   PACKAGE                                           AGE
provider-aws-aws    True        True      xpkg.upbound.io/upbound/provider-aws-aws:v1.0.0   2m
```

### Check Provider Pods

```bash
# List provider pods
kubectl get pods -n crossplane-system | grep provider

# Check provider logs
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=provider-aws-aws
```

## Configuring Provider Credentials

After installing a provider, you need to configure it with credentials to access the external system.

### AWS Provider Configuration

#### Option 1: Using AWS Credentials File

```yaml
apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-creds
      key: credentials
```

Create the secret:

```bash
# Create secret from AWS credentials file
kubectl create secret generic aws-creds \
  -n crossplane-system \
  --from-file=credentials=$HOME/.aws/credentials
```

#### Option 2: Using Environment Variables

```yaml
apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Environment
    env:
      - name: AWS_ACCESS_KEY_ID
        valueFrom:
          secretKeyRef:
            name: aws-creds
            key: access-key-id
      - name: AWS_SECRET_ACCESS_KEY
        valueFrom:
          secretKeyRef:
            name: aws-creds
            key: secret-access-key
```

### Azure Provider Configuration

```yaml
apiVersion: azure.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: azure-creds
      key: credentials
```

Create Azure credentials secret:

```bash
# Create secret with Azure service principal
kubectl create secret generic azure-creds \
  -n crossplane-system \
  --from-literal=credentials="{\"clientId\":\"...\",\"clientSecret\":\"...\",\"tenantId\":\"...\",\"subscriptionId\":\"...\"}"
```

### GCP Provider Configuration

```yaml
apiVersion: gcp.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: my-gcp-project
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: credentials
```

Create GCP credentials secret:

```bash
# Create secret from GCP service account key
kubectl create secret generic gcp-creds \
  -n crossplane-system \
  --from-file=credentials=/path/to/service-account-key.json
```

### Kubernetes Provider Configuration

The Kubernetes provider uses the cluster's service account:

```yaml
apiVersion: kubernetes.crossplane.io/v1alpha1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: InjectedIdentity
```

## Provider Health

### Check Provider Health

```bash
# Using kubectl
kubectl get provider provider-aws-aws -o jsonpath='{.status.conditions[?(@.type=="Healthy")].status}'

# Using Crossplane CLI
crossplane providers health provider-aws-aws
```

### Common Health Issues

**Provider Not Ready:**
- Check provider pod logs
- Verify credentials are correct
- Ensure network connectivity to external APIs

**Provider Unhealthy:**
- Review provider logs for errors
- Check provider configuration
- Verify IAM/service account permissions

## Using Multiple Provider Configs

You can create multiple provider configurations for different accounts/regions:

```yaml
apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: production
spec:
  credentials:
    source: Secret
    secretRef:
      name: aws-prod-creds
---
apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: development
spec:
  credentials:
    source: Secret
    secretRef:
      name: aws-dev-creds
```

Reference in managed resources:

```yaml
apiVersion: s3.aws.crossplane.io/v1beta1
kind: Bucket
metadata:
  name: my-bucket
spec:
  providerConfigRef:
    name: production  # Use production config
  # ... bucket spec
```

## Updating Providers

### Update Provider Version

```bash
# Using Crossplane CLI
crossplane providers update provider-aws-aws:v1.1.0

# Or update the Provider resource
kubectl patch provider provider-aws-aws --type='json' \
  -p='[{"op": "replace", "path": "/spec/package", "value": "xpkg.upbound.io/upbound/provider-aws-aws:v1.1.0"}]'
```

## Uninstalling Providers

⚠️ **Warning**: Uninstalling a provider will prevent management of resources created by that provider.

```bash
# Using kubectl
kubectl delete provider provider-aws-aws

# Using Crossplane CLI
crossplane providers uninstall provider-aws-aws
```

## Provider Examples

See the example files in this directory:
- `provider-aws.yaml` - AWS provider installation
- `provider-azure.yaml` - Azure provider installation
- `provider-gcp.yaml` - GCP provider installation
- `provider-kubernetes.yaml` - Kubernetes provider installation
- `provider-config.yaml` - Example provider configuration

## Best Practices

1. **Use Specific Versions**: Pin provider versions in production
2. **Separate Credentials**: Use different provider configs for different environments
3. **Monitor Health**: Set up alerts for provider health status
4. **Least Privilege**: Grant providers only the permissions they need
5. **Regular Updates**: Keep providers updated for security and new features

## Troubleshooting

### Provider Installation Fails

```bash
# Check provider package
kubectl describe provider provider-aws-aws

# Check package pull secrets if using private registry
kubectl get secrets -n crossplane-system
```

### Provider Not Connecting

```bash
# Verify credentials
kubectl get secret aws-creds -n crossplane-system -o yaml

# Check provider logs
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=provider-aws-aws
```

### Resources Not Creating

- Verify provider is healthy
- Check provider configuration is correct
- Review IAM permissions for the provider
- Check managed resource events: `kubectl describe <resource-type> <resource-name>`

## Next Steps

Now that you have providers installed:

1. **Create Managed Resources** - Move to [03-managed-resources](../03-managed-resources/) to create your first infrastructure resources
2. **Learn Basic Concepts** - Review [04-basic-concepts](../04-basic-concepts/) to understand how Crossplane works

## Additional Resources

- [Provider Documentation](https://docs.crossplane.io/latest/concepts/providers/)
- [AWS Provider Reference](https://marketplace.upbound.io/providers/upbound/provider-aws-aws/)
- [Azure Provider Reference](https://marketplace.upbound.io/providers/upbound/provider-azure-azure/)
- [GCP Provider Reference](https://marketplace.upbound.io/providers/upbound/provider-gcp-gcp/)

---

**Ready to create resources?** Move to [03-managed-resources](../03-managed-resources/)!
