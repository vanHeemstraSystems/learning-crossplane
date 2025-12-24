# Custom Composition Functions

Learn how to write your own Composition Functions in Python and Go to extend Crossplane's capabilities.

## What are Custom Functions?

Custom functions are:

- **Programs** you write to implement custom logic
- **Composition Functions** that follow the Function Protocol
- **Extensible** - add any logic you need
- **Deployable** - packaged as container images

## Why Write Custom Functions?

Write custom functions when you need:

- **Custom Logic**: Logic not available in built-in functions
- **Domain-Specific**: Business logic specific to your organization
- **Integration**: Connect to external systems
- **Validation**: Custom validation rules
- **Transformation**: Complex data transformations

## Function Protocol

Functions must implement the Function Protocol:

- **Input**: XR spec and composition context
- **Output**: Managed resource configurations
- **Communication**: gRPC or HTTP

## Language Support

### Python

**Pros:**
- Easy to write and understand
- Rich ecosystem
- Quick development

**Cons:**
- Slower than Go
- Larger container images

See [python-function/](./python-function/) for examples.

### Go

**Pros:**
- High performance
- Type-safe
- Small container images

**Cons:**
- Steeper learning curve
- More verbose

See [go-function/](./go-function/) for examples.

## Writing Your First Function

### Python Function

1. Implement the Function Protocol
2. Process XR inputs
3. Generate managed resources
4. Return results

See `python-function/function.py` for a complete example.

### Go Function

1. Implement the Function Protocol
2. Process XR inputs
3. Generate managed resources
4. Return results

See `go-function/main.go` for a complete example.

## Building Functions

### Python Function

```bash
cd python-function
docker build -t my-python-function:latest .
```

### Go Function

```bash
cd go-function
docker build -t my-go-function:latest .
```

## Deploying Functions

### Install Function

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Function
metadata:
  name: my-custom-function
spec:
  package: my-registry/my-custom-function:v1.0.0
```

## Testing Functions

Use the testing utilities in `function-testing/`:

```bash
cd function-testing
./render-tests.sh
```

## Best Practices

1. **Follow Protocol**: Implement Function Protocol correctly
2. **Handle Errors**: Provide clear error messages
3. **Validate Inputs**: Validate XR inputs before processing
4. **Test Thoroughly**: Test with various inputs
5. **Document Logic**: Document complex transformations
6. **Version Functions**: Version your functions
7. **Optimize Performance**: Keep functions fast

## Examples

This directory contains example functions:

- **python-function/** - Python function example
- **go-function/** - Go function example
- **function-testing/** - Testing utilities

## Next Steps

Now that you understand custom functions:

1. **Advanced Patterns** - Use functions in advanced scenarios
2. **Production Patterns** - Deploy functions in production
3. **Function Marketplace** - Share functions with the community

## Additional Resources

- [Function Protocol Specification](https://docs.crossplane.io/latest/concepts/composition-functions/#function-protocol)
- [Writing Functions Guide](https://docs.crossplane.io/latest/concepts/composition-functions/#writing-functions)
- [Function Examples](https://github.com/crossplane/function-examples)

---

**Ready for advanced patterns?** Move to [Advanced Patterns](../05-advanced-patterns/)!
