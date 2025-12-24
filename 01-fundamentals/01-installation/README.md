# Installing Crossplane

This guide covers installing Crossplane in your Kubernetes cluster using Helm, the recommended installation method.

## Prerequisites

- Kubernetes cluster (v1.25 or later)
- `kubectl` configured to access your cluster
- Helm 3.0 or later installed
- Cluster admin permissions

## Installation Methods

### Method 1: Helm Install (Recommended)

The simplest way to install Crossplane is using Helm:

```bash
# Add the Crossplane Helm repository
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

# Install Crossplane
helm install crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace
```

### Method 2: Helm Install with Custom Values

For production deployments or custom configurations, use a values file:

```bash
helm install crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace \
  --values helm-values.yaml
```

See `helm-values.yaml` for available configuration options.

### Method 3: Using the Installation Script

You can also use the provided installation YAML:

```bash
kubectl apply -f helm-install.yaml
```

## Verification

After installation, verify that Crossplane is running correctly:

### Quick Verification

Run the verification script:

```bash
chmod +x verify-installation.sh
./verify-installation.sh
```

### Manual Verification

Check that all pods are running:

```bash
kubectl get pods -n crossplane-system
```

Expected output:
```
NAME                                       READY   STATUS    RESTARTS   AGE
crossplane-xxxxxxxxxx-xxxxx                1/1     Running   0          2m
crossplane-rbac-manager-xxxxxxxxxx-xxxxx  1/1     Running   0          2m
```

Check Crossplane CRDs:

```bash
kubectl get crds | grep crossplane
```

You should see several CRDs including:
- `providers.pkg.crossplane.io`
- `providerconfigs.*.crossplane.io`
- `compositeresourcedefinitions.apiextensions.crossplane.io`
- And many more...

### Verify Crossplane Version

```bash
kubectl get deployment crossplane -n crossplane-system \
  -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Configuration Options

### Resource Limits

By default, Crossplane requests minimal resources. For production, you may want to increase limits:

```yaml
# helm-values.yaml
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 100m
    memory: 128Mi
```

### Replica Count

For high availability, increase replica count:

```yaml
replicaCount: 3
```

### Image Configuration

Use a specific Crossplane version:

```yaml
image:
  repository: crossplane/crossplane
  tag: "v1.15.0"  # Specify version
  pullPolicy: IfNotPresent
```

### Feature Flags

Enable or disable specific features:

```yaml
args:
  - --enable-external-secret-stores
  - --enable-composition-functions
```

## Post-Installation

### Install Crossplane CLI (Optional but Recommended)

The Crossplane CLI (`crossplane`) provides helpful commands for managing Crossplane:

```bash
# macOS
brew install crossplane/tap/crossplane

# Linux
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/release-1.15/cli/get-crossplane.sh | sh

# Or download from releases
# https://github.com/crossplane/crossplane/releases
```

Verify CLI installation:

```bash
crossplane --version
```

### Common CLI Commands

```bash
# List installed providers
crossplane providers list

# Install a provider
crossplane providers install provider-aws-aws:v1.0.0

# Check provider health
crossplane providers health provider-aws-aws
```

## Troubleshooting

### Pods Not Starting

If pods are stuck in `Pending` state:

```bash
# Check pod events
kubectl describe pod -n crossplane-system <pod-name>

# Check node resources
kubectl top nodes
```

Common issues:
- Insufficient cluster resources
- Node taints preventing scheduling
- Storage class issues

### Pods Crashing

If pods are crashing:

```bash
# Check pod logs
kubectl logs -n crossplane-system <pod-name>

# Check previous logs if pod restarted
kubectl logs -n crossplane-system <pod-name> --previous
```

### CRDs Not Appearing

If CRDs aren't being created:

```bash
# Check Crossplane logs
kubectl logs -n crossplane-system -l app=crossplane

# Verify RBAC permissions
kubectl get clusterrole crossplane -o yaml
```

## Upgrading Crossplane

### Upgrade Using Helm

```bash
# Update Helm repository
helm repo update

# Upgrade Crossplane
helm upgrade crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system
```

### Upgrade to Specific Version

```bash
helm upgrade crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --version <desired-version>
```

### Check Upgrade Status

```bash
# Verify new version
kubectl get deployment crossplane -n crossplane-system \
  -o jsonpath='{.spec.template.spec.containers[0].image}'

# Check rollout status
kubectl rollout status deployment/crossplane -n crossplane-system
```

## Uninstalling Crossplane

⚠️ **Warning**: Uninstalling Crossplane will remove all managed resources and compositions. Ensure you have backups or are ready to lose this data.

### Uninstall with Helm

```bash
helm uninstall crossplane --namespace crossplane-system
```

### Clean Up CRDs (Optional)

If you want to remove all Crossplane CRDs:

```bash
kubectl get crds -o name | grep crossplane | xargs kubectl delete
```

## Next Steps

Now that Crossplane is installed:

1. **Install a Provider** - Move to [02-providers](../02-providers/) to learn how to install and configure providers
2. **Create Your First Resource** - Jump to [03-managed-resources](../03-managed-resources/) to create infrastructure

## Additional Resources

- [Crossplane Installation Docs](https://docs.crossplane.io/latest/software/install/)
- [Helm Chart Values Reference](https://github.com/crossplane/crossplane/blob/master/cluster/charts/crossplane/values.yaml)
- [Crossplane Release Notes](https://github.com/crossplane/crossplane/releases)

---

**Ready for the next step?** Install a provider in [02-providers](../02-providers/)!
