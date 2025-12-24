# Crossplane Compositions

Welcome to the Crossplane Compositions section! This module teaches you how to create reusable infrastructure patterns using Crossplane's composition system.

## Overview

Compositions are Crossplane's powerful feature for creating reusable infrastructure patterns. Instead of creating individual managed resources, you can define templates that combine multiple resources into higher-level abstractions.

### What You'll Learn

By completing this compositions section, you will:

- ✅ Understand what Compositions are and why they're powerful
- ✅ Create Composite Resource Definitions (XRDs) to define custom APIs
- ✅ Build Compositions that combine multiple resources
- ✅ Create and manage Composite Resources (XRs)
- ✅ Migrate from Crossplane v1 to v2 patterns
- ✅ Be ready to use Composition Functions for advanced logic

## Prerequisites

Before starting, ensure you have:

- Completed the [Fundamentals](../01-fundamentals/) section
- Understanding of managed resources
- Basic knowledge of Kubernetes Custom Resources
- Familiarity with YAML and Kubernetes patterns

## Learning Path

This compositions section is organized into four progressive modules:

### 1. [XRD Basics](./01-xrd-basics/)

Learn how to define Composite Resource Definitions (XRDs), which create custom APIs for your platform.

**Topics Covered:**
- What are XRDs
- Simple XRD examples
- Namespaced vs Cluster-scoped XRDs
- Schema definitions and validation

**Estimated Time:** 30-40 minutes

### 2. [Basic Compositions](./02-basic-compositions/)

Learn how to create Compositions that combine multiple managed resources into reusable patterns.

**Topics Covered:**
- Composition structure
- Resource templates
- Patch and Transform
- Composition metadata

**Estimated Time:** 45-60 minutes

### 3. [Composite Resources](./03-composite-resources/)

Learn how to create and manage Composite Resources (XRs), which are instances of your Compositions.

**Topics Covered:**
- Creating XRs
- Namespaced vs Cluster XRs
- XR status and conditions
- Working with XRs in practice

**Estimated Time:** 30-40 minutes

### 4. [v2 Migration](./04-v2-migration/)

Learn about Crossplane v2 changes and how to migrate from v1 patterns.

**Topics Covered:**
- Key differences between v1 and v2
- Migration strategies
- Namespaced XRs by default
- Removing Claims abstraction

**Estimated Time:** 20-30 minutes

## Key Concepts

Before diving in, here are essential concepts to understand:

### Composite Resource Definition (XRD)

An XRD defines:
- **What** your custom API looks like (schema)
- **Where** it can be used (namespaced or cluster-scoped)
- **Validation rules** for inputs

Think of an XRD as the "API contract" for your infrastructure pattern.

### Composition

A Composition defines:
- **How** to create infrastructure from an XR
- **Which** managed resources to create
- **How** to map XR inputs to resource configurations

Think of a Composition as the "implementation" of your infrastructure pattern.

### Composite Resource (XR)

An XR is:
- An **instance** of your custom API
- Created by users/developers
- Transformed by Compositions into managed resources

Think of an XR as a "request" for infrastructure that follows your pattern.

### The Flow

```
User creates XR → Crossplane finds matching Composition → 
Composition creates managed resources → Providers provision infrastructure
```

## Why Use Compositions?

### Benefits

1. **Abstraction**: Hide complexity from users
2. **Reusability**: Define once, use many times
3. **Consistency**: Enforce best practices
4. **Self-Service**: Enable developers to provision infrastructure
5. **Governance**: Control what can be created

### Example Use Case

Instead of developers creating:
- VPC
- Subnets
- Security Groups
- Internet Gateway
- Route Tables

They can create a single XR:
```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: production-network
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
```

And Crossplane creates all the underlying resources automatically!

## Quick Start

If you're eager to get started quickly:

1. **Create an XRD** (10 min)
   ```bash
   cd 01-xrd-basics
   # Create a simple XRD
   ```

2. **Create a Composition** (15 min)
   ```bash
   cd ../02-basic-compositions
   # Create a composition that uses the XRD
   ```

3. **Create an XR** (5 min)
   ```bash
   cd ../03-composite-resources
   # Create an XR instance
   ```

## Common Patterns

### Pattern 1: Simple Resource Composition

Combine multiple related resources:
- Network + Subnet + Security Group
- Database + Backup + Monitoring

### Pattern 2: Environment-Specific Compositions

Different compositions for different environments:
- Development: Small, cheap resources
- Production: High-availability, secure resources

### Pattern 3: Multi-Cloud Compositions

Same XRD, different compositions for different clouds:
- AWS composition
- Azure composition
- GCP composition

## Best Practices

1. **Start Simple**: Begin with basic compositions, add complexity gradually
2. **Use Schemas**: Define clear schemas in XRDs for validation
3. **Document Patterns**: Document what each composition creates
4. **Test Thoroughly**: Test compositions before production use
5. **Version Control**: Track composition changes in Git

## Troubleshooting

### XR Not Creating Resources

- Check XRD is installed: `kubectl get xrd`
- Check Composition matches XRD: `kubectl get composition`
- Check XR status: `kubectl describe xr <name>`
- Check Composition readiness: `kubectl describe composition <name>`

### Resources Not Matching Expected State

- Verify patch and transform logic
- Check managed resource status
- Review composition logs
- Verify provider configuration

### Schema Validation Errors

- Check XRD schema definition
- Verify XR spec matches schema
- Review validation errors in XR status

## Next Steps

After completing compositions:

1. **Composition Functions** - Add advanced logic with Python, Go, or KCL
2. **Function Pipelines** - Chain multiple functions together
3. **Custom Functions** - Write your own composition functions
4. **Production Patterns** - Deploy compositions in production

## Resources

- [Crossplane Compositions Documentation](https://docs.crossplane.io/latest/concepts/composition/)
- [XRD Reference](https://docs.crossplane.io/latest/concepts/composite-resources/)
- [Patch and Transform Guide](https://docs.crossplane.io/latest/concepts/patch-and-transform/)
- [Crossplane v2 Migration Guide](https://docs.crossplane.io/latest/concepts/v2-migration/)

## Feedback

Found an issue or have suggestions? Please open an issue or submit a pull request!

---

**Ready to begin?** Start with [XRD Basics](./01-xrd-basics/)!
