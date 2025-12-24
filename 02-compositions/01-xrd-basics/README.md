# Composite Resource Definition (XRD) Basics

Composite Resource Definitions (XRDs) are the foundation of Crossplane's composition system. They define custom APIs that abstract away infrastructure complexity.

## What is an XRD?

An XRD (Composite Resource Definition) is a Kubernetes Custom Resource Definition that:

- Defines a **custom API** for your infrastructure patterns
- Specifies the **schema** (what fields users can provide)
- Determines **scope** (namespaced or cluster-scoped)
- Enables **validation** of user inputs

Think of an XRD as the "contract" or "interface" that defines what users can request.

## XRD Structure

A basic XRD has these components:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: CompositeResourceDefinition
metadata:
  name: <plural>.<group>
spec:
  group: <group>                    # API group
  names:
    kind: <Kind>                    # Resource kind
    plural: <plural>                # Plural name
  versions:
    - name: v1alpha1
      served: true
      referenceable: true
      schema:                        # Schema definition
        openAPIV3Schema:
          type: object
          properties:
            spec:
              # User-provided fields
  claimNames:                       # Optional: for namespaced XRs
    kind: <ClaimKind>
    plural: <claimPlural>
```

## Simple XRD Example

Let's create a simple XRD for a network:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: CompositeResourceDefinition
metadata:
  name: networks.network.example.org
spec:
  group: network.example.org
  names:
    kind: Network
    plural: networks
  versions:
    - name: v1alpha1
      served: true
      referenceable: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required:
                - cidr
                - region
              properties:
                cidr:
                  type: string
                  description: "CIDR block for the network"
                region:
                  type: string
                  description: "AWS region"
```

See `simple-xrd.yaml` for the complete example.

## Namespaced vs Cluster-Scoped

### Cluster-Scoped XRD (Default)

Resources exist at the cluster level:

```yaml
spec:
  # No claimNames = cluster-scoped
  group: network.example.org
  names:
    kind: Network
    plural: networks
```

**Use when:**
- Resources are shared across namespaces
- Infrastructure is cluster-wide
- You want centralized management

### Namespaced XRD

Resources exist within namespaces (Crossplane v2 default):

```yaml
spec:
  group: network.example.org
  names:
    kind: Network
    plural: networks
  claimNames:
    kind: NetworkClaim
    plural: networkclaims
```

**Use when:**
- Resources are namespace-specific
- Teams manage their own infrastructure
- You want namespace isolation

See `namespaced-xrd.yaml` and `cluster-scoped-xrd.yaml` for examples.

## Schema Definition

Schemas define what users can provide and validate inputs.

### Basic Schema

```yaml
schema:
  openAPIV3Schema:
    type: object
    properties:
      spec:
        type: object
        properties:
          cidr:
            type: string
          region:
            type: string
```

### Advanced Schema with Validation

```yaml
schema:
  openAPIV3Schema:
    type: object
    properties:
      spec:
        type: object
        required:
          - cidr
          - region
        properties:
          cidr:
            type: string
            pattern: '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'
            description: "CIDR block in format x.x.x.x/y"
          region:
            type: string
            enum:
              - us-east-1
              - us-west-2
              - eu-west-1
          environment:
            type: string
            default: development
            enum:
              - development
              - staging
              - production
```

See `schema-definition.yaml` for comprehensive examples.

## Creating an XRD

### Step 1: Define the XRD

Create a YAML file with your XRD definition:

```bash
kubectl apply -f simple-xrd.yaml
```

### Step 2: Verify Installation

```bash
# Check XRD is installed
kubectl get xrd

# Check the CRD was created
kubectl get crd networks.network.example.org

# View XRD details
kubectl describe xrd networks.network.example.org
```

### Step 3: Test the Schema

Try creating an XR with invalid data to test validation:

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: test-network
spec:
  # Missing required field - should fail validation
  region: us-east-1
```

## XRD Best Practices

### 1. Use Clear Naming

```yaml
# Good
group: network.example.org
kind: Network

# Avoid
group: x.example.org
kind: X
```

### 2. Define Required Fields

```yaml
required:
  - cidr
  - region
```

### 3. Add Descriptions

```yaml
properties:
  cidr:
    type: string
    description: "CIDR block for the network (e.g., 10.0.0.0/16)"
```

### 4. Use Enums for Limited Choices

```yaml
properties:
  environment:
    type: string
    enum:
      - development
      - staging
      - production
```

### 5. Provide Defaults When Appropriate

```yaml
properties:
  environment:
    type: string
    default: development
```

### 6. Validate Inputs

```yaml
properties:
  cidr:
    type: string
    pattern: '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'
```

## Common Patterns

### Pattern 1: Simple Resource Request

```yaml
spec:
  properties:
    spec:
      properties:
        name:
          type: string
        size:
          type: string
```

### Pattern 2: Environment-Aware

```yaml
spec:
  properties:
    spec:
      properties:
        environment:
          type: string
          enum: [dev, staging, prod]
        region:
          type: string
```

### Pattern 3: Multi-Resource Composition

```yaml
spec:
  properties:
    spec:
      properties:
        network:
          type: object
          properties:
            cidr:
              type: string
        database:
          type: object
          properties:
            engine:
              type: string
```

## Updating XRDs

XRDs can be updated, but be careful:

### Safe Updates

- Adding optional fields
- Adding new versions
- Adding descriptions

### Breaking Changes

- Removing fields
- Changing field types
- Making optional fields required

### Update Strategy

1. Add new version to XRD
2. Update compositions to use new version
3. Migrate existing XRs
4. Remove old version

## Troubleshooting

### XRD Not Creating CRD

```bash
# Check XRD status
kubectl get xrd networks.network.example.org -o yaml

# Check for errors
kubectl describe xrd networks.network.example.org
```

### Schema Validation Not Working

```bash
# Verify schema syntax
kubectl get xrd networks.network.example.org -o jsonpath='{.spec.versions[0].schema}'

# Test with invalid XR
kubectl apply -f invalid-xr.yaml
```

### XR Creation Fails

```bash
# Check XR events
kubectl describe network test-network

# Verify XRD is ready
kubectl get xrd networks.network.example.org
```

## Examples

This directory contains example XRDs:

- **simple-xrd.yaml** - Basic XRD example
- **namespaced-xrd.yaml** - Namespaced XRD with claims
- **cluster-scoped-xrd.yaml** - Cluster-scoped XRD
- **schema-definition.yaml** - Advanced schema examples

## Next Steps

Now that you understand XRDs:

1. **Create Compositions** - Move to [02-basic-compositions](../02-basic-compositions/) to learn how to implement your XRD
2. **Create XRs** - Jump to [03-composite-resources](../03-composite-resources/) to create instances

## Additional Resources

- [XRD Documentation](https://docs.crossplane.io/latest/concepts/composite-resources/)
- [Schema Validation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation)
- [OpenAPI Schema](https://swagger.io/specification/)

---

**Ready for the next step?** Create a [Composition](../02-basic-compositions/)!
