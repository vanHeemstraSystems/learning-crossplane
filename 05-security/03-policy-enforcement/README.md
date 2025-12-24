# Policy Enforcement

Policy enforcement ensures that only compliant resources are created in your Crossplane platform. This guide covers using OPA, Kyverno, and admission controllers to enforce policies.

## Overview

Policy enforcement in Crossplane includes:

- **Validation**: Ensure resources meet requirements
- **Mutation**: Automatically fix non-compliant resources
- **Admission Control**: Block non-compliant resources at creation time
- **Governance**: Enforce organizational policies

## Policy Enforcement Tools

### 1. OPA (Open Policy Agent)

Policy engine using Rego language:
- Powerful policy language
- Flexible validation
- Wide adoption

See [opa-policies/](./opa-policies/) for examples.

### 2. Kyverno

Kubernetes-native policy engine:
- YAML-based policies
- Easy to use
- Built-in validation and mutation

See [kyverno-policies/](./kyverno-policies/) for examples.

### 3. Admission Controllers

Kubernetes admission controllers:
- Validate resources
- Mutate resources
- Enforce policies at API level

See [admission-control.yaml](./admission-control.yaml) for examples.

## Common Policies

### 1. Require Labels

Ensure all resources have required labels:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  rules:
    - name: require-labels
      match:
        resources:
          kinds: ["*"]
      validate:
        message: "Labels 'environment' and 'team' are required"
        pattern:
          metadata:
            labels:
              environment: "?*"
              team: "?*"
```

### 2. Prevent Deletion

Prevent deletion of critical resources:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: prevent-deletion
spec:
  rules:
    - name: prevent-production-deletion
      match:
        resources:
          kinds: ["*"]
      validate:
        message: "Cannot delete resources in production namespace"
        deny:
          conditions:
            - key: "{{request.operation}}"
              operator: Equals
              value: DELETE
            - key: "{{request.namespace}}"
              operator: Equals
              value: production
```

### 3. Validate Schema

Ensure XRs match XRD schema:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: validate-xr-schema
spec:
  rules:
    - name: validate-schema
      match:
        resources:
          kinds: ["*"]
          namespaces: ["production"]
      validate:
        message: "XR must match XRD schema"
        # Schema validation logic
```

## OPA Policies

### Installing OPA Gatekeeper

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.14/deploy/gatekeeper.yaml
```

### Example OPA Policy

See [opa-policies/policy-1.rego](./opa-policies/policy-1.rego) for examples.

## Kyverno Policies

### Installing Kyverno

```bash
kubectl apply -f https://github.com/kyverno/kyverno/releases/download/v1.11.0/install.yaml
```

### Example Kyverno Policy

See [kyverno-policies/policy-1.yaml](./kyverno-policies/policy-1.yaml) for examples.

## Admission Controllers

### Validating Admission Webhook

Validate resources before creation:

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: crossplane-validation
webhooks:
  - name: validate.crossplane.io
    rules:
      - apiGroups: ["*"]
        apiVersions: ["*"]
        operations: ["CREATE", "UPDATE"]
        resources: ["*"]
    clientConfig:
      service:
        name: validation-webhook
        namespace: crossplane-system
```

## Best Practices

### 1. Start with Validation

Begin with validation policies before adding mutation:

```yaml
validate:
  message: "Policy violation"
  deny: {}
```

### 2. Use Clear Messages

Provide clear error messages:

```yaml
message: "Label 'environment' is required. Valid values: development, staging, production"
```

### 3. Test Policies

Test policies thoroughly:

```bash
# Test Kyverno policy
kyverno test policy.yaml

# Test OPA policy
opa test policy.rego
```

### 4. Document Policies

Document policy purpose and rationale:

```yaml
metadata:
  annotations:
    description: "Requires environment label for resource organization"
```

### 5. Gradual Rollout

Roll out policies gradually:
- Start with warnings
- Move to enforcement
- Monitor impact

## Common Policy Patterns

### Pattern 1: Require Labels

```yaml
validate:
  message: "Required labels missing"
  pattern:
    metadata:
      labels:
        environment: "?*"
        team: "?*"
```

### Pattern 2: Block Namespace

```yaml
validate:
  message: "Cannot create resources in this namespace"
  deny:
    conditions:
      - key: "{{request.namespace}}"
        operator: Equals
        value: restricted
```

### Pattern 3: Enforce Values

```yaml
validate:
  message: "Invalid value"
  pattern:
    spec:
      environment:
        - "development"
        - "staging"
        - "production"
```

## Troubleshooting

### Policy Not Enforcing

```bash
# Check policy is installed
kubectl get clusterpolicies

# Check policy status
kubectl describe clusterpolicy require-labels

# Check policy violations
kubectl get policyviolations
```

### Policy Blocking Valid Resources

```bash
# Check policy logs
kubectl logs -n kyverno -l app.kubernetes.io/name=kyverno

# Review policy rules
kubectl get clusterpolicy require-labels -o yaml

# Test policy
kyverno test policy.yaml
```

## Examples

This directory contains example policies:

- **opa-policies/** - OPA/Rego policy examples
- **kyverno-policies/** - Kyverno YAML policy examples
- **admission-control.yaml** - Admission controller examples

## Next Steps

Now that you understand policy enforcement:

1. **Compliance** - Set up audit logging
2. **Production** - Deploy policies in production
3. **Monitoring** - Monitor policy violations

## Additional Resources

- [OPA Documentation](https://www.openpolicyagent.org/docs/latest/)
- [Kyverno Documentation](https://kyverno.io/docs/)
- [Kubernetes Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

---

**Ready for compliance?** Move to [Compliance](../04-compliance/)!
