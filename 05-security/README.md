# Crossplane Security

Welcome to the Crossplane Security section! This module covers security best practices, access control, secrets management, policy enforcement, and compliance patterns for production Crossplane deployments.

## Overview

Security is critical for any production infrastructure platform. This section covers:

- **RBAC**: Role-Based Access Control for Crossplane
- **Secrets Management**: Secure handling of credentials
- **Policy Enforcement**: Policy as Code for governance
- **Compliance**: Audit logging and compliance patterns

## What You'll Learn

By completing this security section, you will:

- ✅ Understand Crossplane security architecture
- ✅ Implement proper RBAC for users and service accounts
- ✅ Manage secrets securely
- ✅ Enforce policies using OPA, Kyverno, and admission controllers
- ✅ Set up audit logging and compliance monitoring
- ✅ Deploy Crossplane securely in production

## Prerequisites

Before starting, ensure you have:

- Completed the [Fundamentals](../01-fundamentals/) section
- Understanding of Kubernetes RBAC
- Basic knowledge of secrets management
- Familiarity with policy engines (OPA, Kyverno)

## Learning Path

This security section is organized into four modules:

### 1. [RBAC](./01-rbac/)

Learn how to implement proper access control for Crossplane.

**Topics Covered:**
- Service accounts for Crossplane
- Roles and permissions
- Role bindings
- Least privilege principles

**Estimated Time:** 30-40 minutes

### 2. [Secrets Management](./02-secrets-management/)

Learn how to securely manage credentials and secrets.

**Topics Covered:**
- External Secrets Operator
- Sealed Secrets
- Vault integration
- Secret rotation

**Estimated Time:** 45-60 minutes

### 3. [Policy Enforcement](./03-policy-enforcement/)

Learn how to enforce policies and governance.

**Topics Covered:**
- OPA policies
- Kyverno policies
- Admission controllers
- Policy validation

**Estimated Time:** 45-60 minutes

### 4. [Compliance](./04-compliance/)

Learn how to maintain compliance and auditability.

**Topics Covered:**
- Audit logging
- Compliance checks
- Audit trails
- Compliance reporting

**Estimated Time:** 30-40 minutes

## Security Principles

### 1. Least Privilege

Grant only the minimum permissions necessary:
- Service accounts should have minimal permissions
- Users should only access what they need
- Providers should use IAM roles with least privilege

### 2. Defense in Depth

Multiple layers of security:
- Network policies
- RBAC
- Policy enforcement
- Secrets management
- Audit logging

### 3. Principle of Least Exposure

Limit exposure of sensitive information:
- Use secrets management systems
- Encrypt secrets at rest and in transit
- Rotate credentials regularly

### 4. Auditability

Track all actions:
- Enable audit logging
- Monitor access patterns
- Review compliance regularly

## Security Architecture

### Components

1. **RBAC**: Controls who can do what
2. **Secrets Management**: Secures credentials
3. **Policy Enforcement**: Enforces rules
4. **Audit Logging**: Tracks actions

### Security Layers

```
Application Layer (XRDs, XRs)
    ↓
Policy Enforcement (OPA, Kyverno)
    ↓
RBAC (Kubernetes RBAC)
    ↓
Secrets Management (Vault, External Secrets)
    ↓
Provider Credentials (IAM, Service Principals)
```

## Common Security Concerns

### Provider Credentials

**Risk**: Exposed credentials can lead to unauthorized access

**Mitigation**:
- Use IAM roles (IRSA, Workload Identity)
- Store credentials in secrets management systems
- Rotate credentials regularly
- Use least privilege IAM policies

### XR Access

**Risk**: Unauthorized users creating/modifying infrastructure

**Mitigation**:
- Implement RBAC
- Use namespaces for isolation
- Enforce policies
- Audit all changes

### Composition Security

**Risk**: Malicious compositions creating unwanted resources

**Mitigation**:
- Review compositions before deployment
- Use policy enforcement
- Limit who can create compositions
- Audit composition usage

## Best Practices

### 1. Use Namespaces for Isolation

```yaml
metadata:
  namespace: team-a  # Isolate by team/project
```

### 2. Implement RBAC

```yaml
# Role with minimal permissions
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
rules:
  - apiGroups: ["database.example.org"]
    resources: ["databaseclaims"]
    verbs: ["get", "list", "create"]
```

### 3. Use Secrets Management

```yaml
# Use External Secrets Operator
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
```

### 4. Enforce Policies

```yaml
# Kyverno policy
apiVersion: kyverno.io/v1
kind: ClusterPolicy
spec:
  rules:
    - name: require-labels
```

### 5. Enable Audit Logging

```yaml
# Audit configuration
apiVersion: v1
kind: ConfigMap
data:
  policy.yaml: |
    rules:
      - level: Metadata
```

## Security Checklist

### Pre-Production

- [ ] RBAC configured for all users and service accounts
- [ ] Secrets stored in secure management system
- [ ] Provider credentials use IAM roles where possible
- [ ] Policies enforced (OPA/Kyverno)
- [ ] Audit logging enabled
- [ ] Network policies configured
- [ ] Encryption at rest enabled
- [ ] Encryption in transit enabled

### Ongoing

- [ ] Regular credential rotation
- [ ] Regular RBAC reviews
- [ ] Policy compliance monitoring
- [ ] Audit log review
- [ ] Security updates applied
- [ ] Access reviews conducted

## Compliance Considerations

### SOC 2

- Access controls
- Audit logging
- Encryption
- Change management

### GDPR

- Data protection
- Access controls
- Audit trails
- Data retention

### HIPAA

- Encryption
- Access controls
- Audit logging
- Data protection

## Troubleshooting Security Issues

### Access Denied Errors

```bash
# Check RBAC
kubectl auth can-i create databaseclaims --namespace production

# Check role bindings
kubectl get rolebindings -n production

# Check user permissions
kubectl describe rolebinding developer-role -n production
```

### Secret Access Issues

```bash
# Check secret exists
kubectl get secret aws-creds -n crossplane-system

# Check secret permissions
kubectl auth can-i get secret aws-creds -n crossplane-system

# Check external secrets status
kubectl get externalsecret
```

### Policy Violations

```bash
# Check OPA policies
kubectl get constrainttemplates

# Check Kyverno policies
kubectl get clusterpolicies

# Check policy violations
kubectl get policyviolations
```

## Additional Resources

- [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [External Secrets Operator](https://external-secrets.io/)
- [OPA](https://www.openpolicyagent.org/)
- [Kyverno](https://kyverno.io/)
- [Crossplane Security Best Practices](https://docs.crossplane.io/latest/security/)

## Feedback

Found an issue or have suggestions? Please open an issue or submit a pull request!

---

**Ready to secure your platform?** Start with [RBAC](./01-rbac/)!
