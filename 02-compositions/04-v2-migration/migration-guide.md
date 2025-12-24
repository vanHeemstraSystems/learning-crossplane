# Crossplane v1 to v2 Migration Guide

This guide helps you migrate from Crossplane v1 to v2, focusing on the key changes in the composition system.

## Overview

Crossplane v2 introduced significant changes to simplify the composition model:

- **Namespaced XRs by default** - No more Claims abstraction needed
- **Simplified architecture** - Removed Claims layer
- **Better application support** - First-class support for managing apps
- **Improved developer experience** - Streamlined workflows

## Key Changes

### 1. Namespaced XRs by Default

**v1 (Cluster-scoped XRs with Claims):**
```yaml
# Cluster-scoped XR
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: my-network
  # No namespace

# Namespaced Claim
apiVersion: network.example.org/v1alpha1
kind: NetworkClaim
metadata:
  name: my-network
  namespace: production
```

**v2 (Namespaced XRs directly):**
```yaml
# Namespaced XR (no Claim needed)
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: my-network
  namespace: production  # Directly namespaced
```

### 2. No More Claims Abstraction

**v1:** XR (cluster) → Claim (namespaced) → User creates Claim

**v2:** XR (namespaced) → User creates XR directly

### 3. XRD Changes

**v1 XRD:**
```yaml
spec:
  # No claimNames = cluster-scoped only
  group: network.example.org
  names:
    kind: Network
```

**v2 XRD (with namespaced support):**
```yaml
spec:
  group: network.example.org
  names:
    kind: Network
  claimNames:  # Optional but recommended
    kind: NetworkClaim
    plural: networkclaims
```

### 4. Composition Changes

Compositions remain largely the same, but:

- **compositeTypeRef** now references the XRD directly
- No need to handle Claims separately
- Simpler resource references

## Migration Steps

### Step 1: Update XRDs

Update your XRDs to support namespaced XRs:

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
  # Add claimNames for namespaced support
  claimNames:
    kind: NetworkClaim
    plural: networkclaims
  versions:
    - name: v1alpha1
      served: true
      referenceable: true
      schema:
        # ... schema definition
```

### Step 2: Update Compositions

Compositions need minimal changes:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: network-aws
spec:
  compositeTypeRef:
    apiVersion: network.example.org/v1alpha1
    kind: Network  # References XRD directly
  resources:
    # ... resource templates
```

### Step 3: Migrate Existing Resources

#### Option A: Keep Cluster-Scoped (Backward Compatible)

If you have existing cluster-scoped XRs, they will continue to work:

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: shared-network
  # No namespace = cluster-scoped
```

#### Option B: Migrate to Namespaced

1. Create new namespaced XRs:
```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: production-network
  namespace: production
```

2. Verify new XRs work correctly

3. Delete old cluster-scoped XRs (if no longer needed)

### Step 4: Update Documentation

Update your documentation to reflect:
- Namespaced XRs as the default
- Removal of Claims abstraction
- New patterns and best practices

## Migration Checklist

- [ ] Review existing XRDs
- [ ] Add `claimNames` to XRDs (if using namespaced XRs)
- [ ] Update Compositions to reference XRDs directly
- [ ] Test new namespaced XRs
- [ ] Migrate existing Claims to XRs
- [ ] Update CI/CD pipelines
- [ ] Update documentation
- [ ] Train team on v2 patterns
- [ ] Plan deprecation of v1 patterns

## Common Migration Scenarios

### Scenario 1: Simple Network Composition

**v1 Pattern:**
```yaml
# Cluster XR
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: shared-network

# Namespaced Claim
apiVersion: network.example.org/v1alpha1
kind: NetworkClaim
metadata:
  name: prod-network
  namespace: production
```

**v2 Pattern:**
```yaml
# Direct namespaced XR
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: prod-network
  namespace: production
```

### Scenario 2: Database with Secrets

**v1 Pattern:**
```yaml
# Claim writes to secret
apiVersion: database.example.org/v1alpha1
kind: DatabaseClaim
metadata:
  name: my-db
  namespace: app
spec:
  writeConnectionSecretsToRef:
    name: db-connection
```

**v2 Pattern:**
```yaml
# XR writes to secret directly
apiVersion: database.example.org/v1alpha1
kind: Database
metadata:
  name: my-db
  namespace: app
spec:
  writeConnectionSecretsToRef:
    name: db-connection
    namespace: app
```

## Backward Compatibility

Crossplane v2 maintains backward compatibility:

- **Cluster-scoped XRs** still work
- **Existing Compositions** continue to function
- **Gradual migration** is supported

You can run both patterns during migration.

## Best Practices for v2

### 1. Use Namespaced XRs by Default

```yaml
metadata:
  namespace: production  # Always specify namespace
```

### 2. Remove Claims Layer

Create XRs directly instead of Claims.

### 3. Update XRD Schemas

Ensure schemas support namespaced usage.

### 4. Use Connection Secrets

Write connection info directly from XRs:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: connection-secret
    namespace: app
```

## Troubleshooting Migration

### XR Not Creating

- Verify XRD has `claimNames` if using namespaced XRs
- Check Composition `compositeTypeRef` matches XRD
- Verify namespace exists

### Resources Not Appearing

- Check XR status: `kubectl describe xr <name>`
- Verify Composition is installed
- Check managed resources: `kubectl get managed`

### Schema Validation Errors

- Verify XR spec matches XRD schema
- Check for required fields
- Review validation errors in XR status

## Additional Resources

- [Crossplane v2 Release Notes](https://github.com/crossplane/crossplane/releases)
- [v2 Migration Documentation](https://docs.crossplane.io/latest/concepts/v2-migration/)
- [Namespaced XRs Guide](https://docs.crossplane.io/latest/concepts/composite-resources/#namespaced-composite-resources)

## Summary

Migration to v2 is straightforward:

1. ✅ Update XRDs to support namespaced XRs
2. ✅ Update Compositions (minimal changes)
3. ✅ Create namespaced XRs directly
4. ✅ Remove Claims abstraction
5. ✅ Enjoy simplified architecture!

---

**Questions?** Check the [official migration guide](https://docs.crossplane.io/latest/concepts/v2-migration/)!
