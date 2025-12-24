# Basic Compositions

Compositions define how to create infrastructure from Composite Resources (XRs). They specify which managed resources to create and how to configure them based on XR inputs.

## What is a Composition?

A Composition is a Kubernetes resource that:

- **Maps** XR inputs to managed resource configurations
- **Defines** which managed resources to create
- **Transforms** XR spec into provider-specific configurations
- **Combines** multiple resources into reusable patterns

Think of a Composition as the "implementation" that turns an XR into actual infrastructure.

## Composition Structure

A basic Composition has these components:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: <name>
spec:
  writeConnectionSecretsToRef:
    name: <secret-name>
  compositeTypeRef:
    apiVersion: <xrd-api-version>
    kind: <xrd-kind>
  resources:
    - name: <resource-name>
      base:
        apiVersion: <provider-api>
        kind: <resource-kind>
        spec:
          # Base resource configuration
      patches:
        # Transformations from XR to resource
```

## Simple Composition Example

Let's create a Composition that creates a VPC from a Network XR:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: network-aws
spec:
  compositeTypeRef:
    apiVersion: network.example.org/v1alpha1
    kind: Network
  resources:
    - name: vpc
      base:
        apiVersion: ec2.aws.crossplane.io/v1beta1
        kind: VPC
        spec:
          forProvider:
            enableDnsHostnames: true
            enableDnsSupport: true
      patches:
        - type: FromCompositeFieldPath
          fromFieldPath: spec.cidr
          toFieldPath: spec.forProvider.cidrBlock
        - type: FromCompositeFieldPath
          fromFieldPath: spec.region
          toFieldPath: spec.forProvider.region
```

See `patch-and-transform.yaml` for complete examples.

## Resource Templates

Resource templates define the base configuration for managed resources:

```yaml
resources:
  - name: vpc
    base:
      apiVersion: ec2.aws.crossplane.io/v1beta1
      kind: VPC
      spec:
        forProvider:
          enableDnsHostnames: true
          enableDnsSupport: true
        providerConfigRef:
          name: default
```

See `resource-templates.yaml` for examples.

## Patch and Transform

Patches transform XR values into managed resource configurations.

### Patch Types

#### 1. FromCompositeFieldPath

Copy a value from XR to resource:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.cidr
    toFieldPath: spec.forProvider.cidrBlock
```

#### 2. ToCompositeFieldPath

Copy a value from resource to XR:

```yaml
patches:
  - type: ToCompositeFieldPath
    fromFieldPath: status.atProvider.vpcId
    toFieldPath: status.atProvider.vpcId
```

#### 3. CombineFromComposite

Combine multiple XR fields:

```yaml
patches:
  - type: CombineFromComposite
    combine:
      strategy: string
      string:
        fmt: "%s-%s"
    toFieldPath: metadata.name
    fromFieldPath:
      - spec.environment
      - spec.name
```

#### 4. CombineToComposite

Combine multiple resource fields:

```yaml
patches:
  - type: CombineToComposite
    combine:
      strategy: string
      string:
        fmt: "arn:aws:s3:::%s"
    fromFieldPath:
      - status.atProvider.bucket
    toFieldPath: status.atProvider.bucketArn
```

See `patch-and-transform.yaml` for comprehensive examples.

## Composition Metadata

Compositions can include metadata for organization:

```yaml
metadata:
  name: network-aws-production
  labels:
    provider: aws
    environment: production
  annotations:
    description: "Production network composition for AWS"
```

See `composition-metadata.yaml` for examples.

## Multi-Resource Compositions

Compositions can create multiple resources:

```yaml
resources:
  - name: vpc
    base:
      apiVersion: ec2.aws.crossplane.io/v1beta1
      kind: VPC
      # ... VPC configuration
  - name: subnet
    base:
      apiVersion: ec2.aws.crossplane.io/v1beta1
      kind: Subnet
      # ... Subnet configuration
    patches:
      - type: FromCompositeFieldPath
        fromFieldPath: status.atProvider.vpcId
        toFieldPath: spec.forProvider.vpcId
```

## Resource Dependencies

Resources can depend on each other:

```yaml
resources:
  - name: vpc
    # VPC created first
  - name: subnet
    # Subnet depends on VPC
    patches:
      - type: FromCompositeFieldPath
        fromFieldPath: status.resources[0].resourceRef.name
        toFieldPath: spec.forProvider.vpcId
```

## Connection Secrets

Compositions can write connection information to secrets:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: network-connection
    namespace: default
```

## Creating a Composition

### Step 1: Define the Composition

Create a YAML file with your Composition:

```bash
kubectl apply -f patch-and-transform.yaml
```

### Step 2: Verify Installation

```bash
# Check Composition is installed
kubectl get composition

# View Composition details
kubectl describe composition network-aws
```

### Step 3: Test with an XR

Create an XR that uses this Composition:

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: my-network
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
```

## Best Practices

### 1. Use Descriptive Names

```yaml
metadata:
  name: network-aws-production  # Clear and specific
```

### 2. Add Labels

```yaml
metadata:
  labels:
    provider: aws
    environment: production
```

### 3. Document Patches

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.cidr
    toFieldPath: spec.forProvider.cidrBlock
    # Maps Network.cidr to VPC.cidrBlock
```

### 4. Handle Dependencies

Ensure resources are created in the right order:

```yaml
resources:
  - name: vpc      # Created first
  - name: subnet   # Created after VPC
```

### 5. Use Connection Secrets

Write connection info for users:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: network-connection
```

## Common Patterns

### Pattern 1: Simple Mapping

Map XR fields directly to resource fields:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.cidr
    toFieldPath: spec.forProvider.cidrBlock
```

### Pattern 2: Conditional Resources

Create resources conditionally (requires Composition Functions):

```yaml
resources:
  - name: subnet
    # Only created if condition is met
```

### Pattern 3: Environment-Specific

Different compositions for different environments:

```yaml
# Development composition
metadata:
  name: network-aws-dev

# Production composition
metadata:
  name: network-aws-prod
```

## Troubleshooting

### Composition Not Matching XR

```bash
# Check compositeTypeRef matches XRD
kubectl get composition network-aws -o yaml | grep compositeTypeRef

# Verify XRD exists
kubectl get xrd networks.network.example.org
```

### Resources Not Creating

```bash
# Check XR status
kubectl describe network my-network

# Check for patch errors
kubectl get network my-network -o yaml | grep -A 10 "conditions"
```

### Patch Errors

```bash
# Verify field paths exist
kubectl get network my-network -o jsonpath='{.spec}'

# Check patch syntax
kubectl get composition network-aws -o yaml | grep -A 5 "patches"
```

## Examples

This directory contains example Compositions:

- **patch-and-transform.yaml** - Comprehensive patch examples
- **resource-templates.yaml** - Resource template examples
- **composition-metadata.yaml** - Metadata and organization examples

## Next Steps

Now that you understand Compositions:

1. **Create XRs** - Move to [03-composite-resources](../03-composite-resources/) to create instances
2. **Use Functions** - Learn about Composition Functions for advanced logic
3. **Build Pipelines** - Chain multiple functions together

## Additional Resources

- [Composition Documentation](https://docs.crossplane.io/latest/concepts/composition/)
- [Patch and Transform Guide](https://docs.crossplane.io/latest/concepts/patch-and-transform/)
- [Resource Templates](https://docs.crossplane.io/latest/concepts/composition/#resource-templates)

---

**Ready to create XRs?** Move to [Composite Resources](../03-composite-resources/)!
