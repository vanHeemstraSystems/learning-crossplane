# Function Pipelines

Function pipelines allow you to chain multiple Composition Functions together to build complex transformations. Each function in the pipeline processes the output of the previous function.

## What are Function Pipelines?

Function pipelines are:

- **Sequences** of functions that run in order
- **Transformations** where each function processes the previous output
- **Composable** - combine different function types
- **Powerful** - enable complex logic by chaining simple functions

## Pipeline Flow

```
XR Input → Function 1 → Function 2 → Function 3 → Managed Resources
```

Each function:
1. Receives input from previous function (or XR for first function)
2. Processes and transforms the data
3. Passes output to next function (or final output)

## Basic Pipeline

### Simple Two-Step Pipeline

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: network-pipeline
spec:
  compositeTypeRef:
    apiVersion: network.example.org/v1alpha1
    kind: Network
  mode: Pipeline
  pipeline:
    - step: validate
      functionRef:
        name: function-validate
      input:
        # Validation configuration
    - step: patch-and-transform
      functionRef:
        name: function-patch-and-transform
      input:
        # Patching configuration
```

See `pipeline-composition.yaml` for complete examples.

## Multi-Function Pipelines

### Example: Validate → Transform → Template

```yaml
pipeline:
  - step: validate-inputs
    functionRef:
      name: function-validate
    input:
      # Validate XR inputs
  - step: patch-resources
    functionRef:
      name: function-patch-and-transform
    input:
      # Patch and transform
  - step: apply-templates
    functionRef:
      name: function-go-templating
    input:
      # Apply Go templates
```

See `multi-function.yaml` for examples.

## Function Chaining

Functions can be chained to build complex logic:

```yaml
pipeline:
  - step: fetch-external-data
    functionRef:
      name: function-external-data
  - step: transform-data
    functionRef:
      name: function-patch-and-transform
  - step: generate-resources
    functionRef:
      name: function-go-templating
```

See `function-chaining.yaml` for examples.

## Best Practices

1. **Order Matters**: Functions run sequentially
2. **Keep Functions Focused**: Each function should do one thing well
3. **Handle Errors**: Each function should handle errors gracefully
4. **Test Incrementally**: Test each function individually
5. **Document Pipeline**: Document what each step does

## Common Patterns

### Pattern 1: Validate → Transform

```yaml
pipeline:
  - step: validate
    functionRef:
      name: function-validate
  - step: transform
    functionRef:
      name: function-patch-and-transform
```

### Pattern 2: Fetch → Transform → Generate

```yaml
pipeline:
  - step: fetch
    functionRef:
      name: function-external-data
  - step: transform
    functionRef:
      name: function-patch-and-transform
  - step: generate
    functionRef:
      name: function-go-templating
```

### Pattern 3: Multiple Transforms

```yaml
pipeline:
  - step: transform-1
    functionRef:
      name: function-patch-and-transform
  - step: transform-2
    functionRef:
      name: function-patch-and-transform
```

## Troubleshooting

### Pipeline Not Running

```bash
# Check all functions are installed
kubectl get function

# Check function pods
kubectl get pods -n crossplane-system | grep function

# Check composition mode
kubectl get composition network-pipeline -o jsonpath='{.spec.mode}'
```

### Function Errors in Pipeline

```bash
# Check XR status
kubectl describe network my-network

# Check which step failed
kubectl get network my-network -o yaml | grep -A 10 "conditions"

# Check function logs
kubectl logs -n crossplane-system <function-pod>
```

## Examples

This directory contains example pipelines:

- **pipeline-composition.yaml** - Basic pipeline examples
- **multi-function.yaml** - Multi-function pipeline examples
- **function-chaining.yaml** - Function chaining examples

## Next Steps

Now that you understand pipelines:

1. **Templating Functions** - Use templating functions in pipelines
2. **Custom Functions** - Write custom functions for your pipelines
3. **Advanced Patterns** - Learn advanced pipeline patterns

## Additional Resources

- [Function Pipelines Documentation](https://docs.crossplane.io/latest/concepts/composition-functions/#function-pipelines)
- [Function Protocol](https://docs.crossplane.io/latest/concepts/composition-functions/#function-protocol)

---

**Ready for templating?** Move to [Templating Functions](../03-templating-functions/)!
