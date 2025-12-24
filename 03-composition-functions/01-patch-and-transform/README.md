# Patch and Transform Function

The Patch and Transform (P&T) function is the most commonly used Composition Function. It provides advanced patching capabilities beyond basic patch and transform in compositions.

## What is the Patch and Transform Function?

The Patch and Transform function is a Composition Function that:

- **Extends** basic patch and transform capabilities
- **Provides** advanced patching patterns
- **Enables** conditional logic and transformations
- **Supports** complex data manipulation

## Why Use the P&T Function?

While basic compositions support patch and transform, the P&T function provides:

- **Conditional Patching**: Create resources conditionally
- **Advanced Transforms**: Complex data transformations
- **Validation**: Input validation before patching
- **Better Error Handling**: Clear error messages

## Installation

### Step 1: Install the Function

```bash
kubectl apply -f function-install.yaml
```

### Step 2: Verify Installation

```bash
# Check function is installed
kubectl get function patch-and-transform

# Check function pod
kubectl get pods -n crossplane-system | grep patch-and-transform
```

## Basic Usage

### Simple Composition with P&T Function

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: network-aws
spec:
  compositeTypeRef:
    apiVersion: network.example.org/v1alpha1
    kind: Network
  mode: Pipeline
  pipeline:
    - step: patch-and-transform
      functionRef:
        name: function-patch-and-transform
      input:
        patches:
          - type: FromCompositeFieldPath
            fromFieldPath: spec.cidr
            toFieldPath: spec.forProvider.cidrBlock
```

See `simple-transform.yaml` for complete examples.

## Advanced Patterns

### Conditional Patching

Create resources conditionally based on XR values:

```yaml
pipeline:
  - step: conditional-resources
    functionRef:
      name: function-patch-and-transform
    input:
      resources:
        - name: vpc
          base:
            apiVersion: ec2.aws.crossplane.io/v1beta1
            kind: VPC
          patches:
            - type: FromCompositeFieldPath
              fromFieldPath: spec.cidr
              toFieldPath: spec.forProvider.cidrBlock
        - name: subnet
          base:
            apiVersion: ec2.aws.crossplane.io/v1beta1
            kind: Subnet
          patches:
            - type: FromCompositeFieldPath
              fromFieldPath: spec.createSubnet
              toFieldPath: metadata.annotations[crossplane.io/optional]
```

See `conditional-patching.yaml` for examples.

## Patch Types

The P&T function supports all standard patch types:

### FromCompositeFieldPath

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.cidr
    toFieldPath: spec.forProvider.cidrBlock
```

### CombineFromComposite

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

### ToCompositeFieldPath

```yaml
patches:
  - type: ToCompositeFieldPath
    fromFieldPath: status.atProvider.vpcId
    toFieldPath: status.atProvider.vpcId
```

## Best Practices

1. **Use for Complex Logic**: When basic patches aren't enough
2. **Validate Inputs**: Add validation before patching
3. **Handle Errors**: Provide clear error messages
4. **Document Patches**: Document complex patch logic
5. **Test Thoroughly**: Test with various inputs

## Examples

This directory contains example compositions:

- **function-install.yaml** - Function installation
- **simple-transform.yaml** - Basic transformation examples
- **conditional-patching.yaml** - Conditional patching examples
- **examples/** - Additional examples

## Troubleshooting

### Function Not Running

```bash
# Check function is installed
kubectl get function patch-and-transform

# Check function pod
kubectl get pods -n crossplane-system | grep patch-and-transform

# Check function logs
kubectl logs -n crossplane-system -l function=patch-and-transform
```

### Patch Errors

```bash
# Check XR status
kubectl describe network my-network

# Check for patch errors in status
kubectl get network my-network -o yaml | grep -A 10 "conditions"
```

## Next Steps

Now that you understand the P&T function:

1. **Function Pipelines** - Learn to chain functions together
2. **Templating Functions** - Use templating for dynamic generation
3. **Custom Functions** - Write your own functions

## Additional Resources

- [Patch and Transform Documentation](https://docs.crossplane.io/latest/concepts/patch-and-transform/)
- [Function Reference](https://docs.crossplane.io/latest/concepts/composition-functions/)

---

**Ready for pipelines?** Move to [Function Pipelines](../02-function-pipeline/)!
