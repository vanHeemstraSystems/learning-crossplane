# Testing Crossplane Resources

Automated testing is essential for ensuring Crossplane resources work correctly. This guide covers testing strategies for compositions, functions, and integration testing.

## Overview

Testing Crossplane involves:

- **Composition Testing**: Validate compositions render correctly
- **Function Testing**: Test composition functions
- **Integration Testing**: End-to-end resource creation
- **Policy Testing**: Validate policies and constraints

## Testing Strategy

### Testing Pyramid

```
        /\
       /  \  E2E Tests (Few)
      /____\
     /      \  Integration Tests (Some)
    /________\
   /          \  Unit Tests (Many)
  /____________\
```

### Test Levels

1. **Unit Tests**: Test individual components
2. **Integration Tests**: Test component interactions
3. **E2E Tests**: Test complete workflows

## Composition Testing

Test that compositions render correctly. See [composition-tests/](./composition-tests/) for examples.

### What to Test

- Composition renders without errors
- All resources are created
- Patches are applied correctly
- Dependencies are handled
- Secrets are generated

### Example Test

```yaml
apiVersion: v1
kind: TestCase
metadata:
  name: test-postgres-composition
spec:
  input:
    apiVersion: database.example.org/v1alpha1
    kind: DatabaseClaim
    spec:
      engine: postgres
      instanceClass: db.t3.medium
  expected:
    resources:
      - kind: DBInstance
        spec:
          forProvider:
            engine: postgres
            dbInstanceClass: db.t3.medium
```

## Function Testing

Test composition functions independently. See [function-tests/](./function-tests/) for examples.

### Testing Functions

1. **Input Validation**: Test function with various inputs
2. **Output Validation**: Verify function output
3. **Error Handling**: Test error cases
4. **Edge Cases**: Test boundary conditions

### Example Function Test

```bash
#!/bin/bash
# Test patch-and-transform function

INPUT='{"spec":{"engine":"postgres"}}'
OUTPUT=$(echo $INPUT | function-process)

if echo $OUTPUT | grep -q "postgres"; then
  echo "Test passed"
else
  echo "Test failed"
  exit 1
fi
```

## Integration Testing

Test complete workflows end-to-end. See [integration-tests/](./integration-tests/) for examples.

### What to Test

- XR creation creates managed resources
- Resources are created in cloud
- Status is updated correctly
- Dependencies are resolved
- Deletion works correctly

### Example Integration Test

```bash
#!/bin/bash
# Integration test

# Create XR
kubectl apply -f test-xr.yaml

# Wait for ready
kubectl wait --for=condition=Ready xr/test-database --timeout=5m

# Verify managed resources
kubectl get managed -l crossplane.io/composite=test-database

# Verify cloud resource exists
aws rds describe-db-instances --db-instance-identifier test-database

# Cleanup
kubectl delete xr test-database
```

## Testing Tools

### kubectl

Basic testing with kubectl:
```bash
# Dry-run
kubectl apply --dry-run=client -f .

# Validate
kubectl apply --validate=true -f .
```

### KUTTL

Kubernetes Integration Testing:
```yaml
apiVersion: kuttl.dev/v1beta1
kind: TestSuite
metadata:
  name: crossplane-tests
spec:
  tests:
    - name: database-creation
```

### conftest

Policy testing with OPA:
```bash
conftest test --policy policies/ .
```

## Best Practices

### 1. Test Early and Often

- Test in development
- Test in CI/CD
- Test before merge
- Test after deployment

### 2. Test Real Scenarios

- Use realistic data
- Test common use cases
- Test edge cases
- Test error scenarios

### 3. Isolate Tests

- Each test is independent
- Clean up after tests
- Use test namespaces
- Mock external dependencies

### 4. Automate Testing

- Run tests in CI/CD
- Fail fast on errors
- Generate test reports
- Track test coverage

### 5. Test Across Environments

- Test in staging
- Test in production-like environments
- Test with real providers (carefully)
- Use test clusters

## Test Organization

### Directory Structure

```
tests/
├── unit/
│   ├── compositions/
│   └── functions/
├── integration/
│   ├── xr-creation/
│   └── resource-lifecycle/
└── e2e/
    └── complete-workflows/
```

## Examples

This directory contains example test configurations:

- **composition-tests/** - Composition test examples
- **function-tests/** - Function test examples
- **integration-tests/** - Integration test examples

## Additional Resources

- [KUTTL Documentation](https://kuttl.dev/)
- [conftest Documentation](https://www.conftest.dev/)
- [Testing Best Practices](https://kubernetes.io/docs/concepts/cluster-administration/testing/)

---

**Congratulations!** You've completed the CI/CD Integration section!
