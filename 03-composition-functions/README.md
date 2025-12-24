# Composition Functions

Welcome to the Composition Functions section! This module teaches you how to use Composition Functions to add advanced logic, templating, and custom behavior to your Crossplane compositions.

## Overview

Composition Functions are programs that run during the composition process to transform and validate XR inputs into managed resources. They enable you to add complex logic, templating, and custom transformations that go beyond basic patch and transform.

### What You'll Learn

By completing this composition functions section, you will:

- ✅ Understand what Composition Functions are and when to use them
- ✅ Use the Patch and Transform function for advanced patching
- ✅ Chain multiple functions together in pipelines
- ✅ Use templating functions (Go templates, KCL, Helm)
- ✅ Write custom functions in Python and Go
- ✅ Implement advanced patterns and best practices

## Prerequisites

Before starting, ensure you have:

- Completed the [Fundamentals](../01-fundamentals/) section
- Completed the [Compositions](../02-compositions/) section
- Understanding of XRDs, Compositions, and XRs
- Basic programming knowledge (Python or Go helpful)
- Docker installed (for testing custom functions)

## Learning Path

This composition functions section is organized into five progressive modules:

### 1. [Patch and Transform Function](./01-patch-and-transform/)

Learn how to use the Patch and Transform function for advanced patching scenarios.

**Topics Covered:**
- Installing the Patch and Transform function
- Simple transformations
- Conditional patching
- Advanced patch patterns

**Estimated Time:** 30-40 minutes

### 2. [Function Pipelines](./02-function-pipeline/)

Learn how to chain multiple functions together to build complex transformations.

**Topics Covered:**
- Function pipelines
- Multi-function compositions
- Function chaining
- Pipeline best practices

**Estimated Time:** 30-40 minutes

### 3. [Templating Functions](./03-templating-functions/)

Learn how to use templating-based functions for dynamic resource generation.

**Topics Covered:**
- Go templating function
- KCL (Kubernetes Configuration Language) function
- Helm function
- Template patterns

**Estimated Time:** 45-60 minutes

### 4. [Custom Functions](./04-custom-functions/)

Learn how to write your own Composition Functions in Python and Go.

**Topics Covered:**
- Function architecture
- Writing Python functions
- Writing Go functions
- Testing functions
- Building and deploying functions

**Estimated Time:** 60-90 minutes

### 5. [Advanced Patterns](./05-advanced-patterns/)

Learn advanced patterns and techniques for complex use cases.

**Topics Covered:**
- Conditional logic
- Loops and iteration
- External data fetching
- Error handling

**Estimated Time:** 30-40 minutes

## What are Composition Functions?

Composition Functions are:

- **Programs** that run during composition
- **Transform** XR inputs into managed resources
- **Validate** inputs and outputs
- **Extend** Crossplane's capabilities beyond basic patches

### Function Flow

```
XR Created → Composition Selected → Functions Run → 
Managed Resources Created → Status Updated
```

### When to Use Functions

Use functions when you need:

- **Complex Logic**: Conditional resource creation
- **Templating**: Dynamic resource generation
- **Validation**: Custom input validation
- **Transformation**: Complex data transformations
- **External Data**: Fetching data from external sources

## Function Types

### 1. Built-in Functions

- **Patch and Transform**: Advanced patching (most common)
- Provided by Crossplane core

### 2. Templating Functions

- **Go Templates**: Text templating
- **KCL**: Kubernetes Configuration Language
- **Helm**: Helm chart templating

### 3. Custom Functions

- **Python**: Easy to write, flexible
- **Go**: High performance, type-safe
- **Any Language**: As long as it implements the Function Protocol

## Quick Start

If you're eager to get started quickly:

1. **Install Patch and Transform Function** (5 min)
   ```bash
   cd 01-patch-and-transform
   # Install the function
   ```

2. **Create a Simple Composition** (10 min)
   ```bash
   # Use the function in a composition
   ```

3. **Test with an XR** (5 min)
   ```bash
   # Create an XR and see the function in action
   ```

## Key Concepts

### Function Protocol

Functions communicate using the Function Protocol:
- **Input**: XR spec and composition context
- **Output**: Managed resource configurations
- **Communication**: gRPC or HTTP

### Function Execution

Functions run:
- **During composition**: When XR is created/updated
- **In isolation**: Each function runs in its own container
- **In sequence**: Functions in a pipeline run one after another

### Function Configuration

Functions can be configured:
- **Globally**: In the composition
- **Per-function**: In function configuration
- **Via environment**: Environment variables

## Best Practices

1. **Start Simple**: Begin with Patch and Transform, add complexity gradually
2. **Test Thoroughly**: Test functions with various inputs
3. **Document Logic**: Document complex transformations
4. **Version Functions**: Version your custom functions
5. **Handle Errors**: Implement proper error handling
6. **Optimize Performance**: Keep functions fast and efficient

## Troubleshooting

### Function Not Running

- Check function is installed: `kubectl get function`
- Verify function is referenced in composition
- Check function logs: `kubectl logs -n crossplane-system <function-pod>`

### Function Errors

- Check function configuration
- Review function logs for errors
- Verify input/output format
- Test function independently

### Pipeline Issues

- Verify function order in pipeline
- Check each function's output
- Review pipeline logs
- Test functions individually

## Next Steps

After completing composition functions:

1. **Real-World Examples** - See functions in production scenarios
2. **Production Patterns** - Deploy functions in production
3. **Function Marketplace** - Explore community functions
4. **Advanced Topics** - Deep dive into function internals

## Resources

- [Composition Functions Documentation](https://docs.crossplane.io/latest/concepts/composition-functions/)
- [Function Protocol Specification](https://docs.crossplane.io/latest/concepts/composition-functions/#function-protocol)
- [Patch and Transform Function](https://docs.crossplane.io/latest/concepts/patch-and-transform/)
- [Function Examples](https://github.com/crossplane/function-examples)

## Feedback

Found an issue or have suggestions? Please open an issue or submit a pull request!

---

**Ready to begin?** Start with [Patch and Transform Function](./01-patch-and-transform/)!
