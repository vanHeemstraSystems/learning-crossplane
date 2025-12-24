# Secrets Management

Secure secrets management is critical for production Crossplane deployments. This guide covers best practices for managing provider credentials and connection secrets.

## Overview

Secrets in Crossplane include:

- **Provider Credentials**: AWS access keys, Azure service principals, GCP service accounts
- **Connection Secrets**: Database connection strings, API endpoints
- **Function Secrets**: Secrets used by composition functions
- **Application Secrets**: Secrets used by deployed applications

## Security Principles

### 1. Never Store Secrets in Git

Secrets should never be committed to version control:
- Use secrets management systems
- Use encrypted secrets (Sealed Secrets)
- Store secrets externally

### 2. Use External Secrets Management

Prefer external systems:
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- GCP Secret Manager

### 3. Use IAM Roles When Possible

Prefer IAM roles over static credentials:
- AWS: IRSA (IAM Roles for Service Accounts)
- Azure: Workload Identity
- GCP: Workload Identity

### 4. Rotate Credentials Regularly

Implement credential rotation:
- Automated rotation
- Regular manual rotation
- Rotation policies

## Secrets Management Solutions

### 1. External Secrets Operator

Sync secrets from external systems:
- Supports multiple backends
- Automatic synchronization
- Secret rotation support

See [external-secrets.yaml](./external-secrets.yaml)

### 2. Sealed Secrets

Encrypt secrets for Git storage:
- Encrypted at rest in Git
- Decrypted at runtime
- Public key encryption

See [sealed-secrets.yaml](./sealed-secrets.yaml)

### 3. HashiCorp Vault

Enterprise secrets management:
- Centralized secrets
- Dynamic secrets
- Secret rotation

See [vault-integration.yaml](./vault-integration.yaml)

## Provider Credentials

### AWS Credentials

#### Option 1: IAM Roles (IRSA) - Recommended

Use IAM Roles for Service Accounts:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: provider-aws
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/CrossplaneProviderRole
```

#### Option 2: External Secrets

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: aws-creds
spec:
  secretStoreRef:
    name: aws-secrets-manager
  target:
    name: aws-creds
  data:
    - secretKey: credentials
      remoteRef:
        key: crossplane/aws/credentials
```

### Azure Credentials

#### Option 1: Workload Identity - Recommended

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: provider-azure
  annotations:
    azure.workload.identity/client-id: "azure-client-id"
```

#### Option 2: External Secrets

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: azure-creds
spec:
  secretStoreRef:
    name: azure-key-vault
  target:
    name: azure-creds
```

### GCP Credentials

#### Option 1: Workload Identity - Recommended

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: provider-gcp
  annotations:
    iam.gke.io/gcp-service-account: crossplane@project.iam.gserviceaccount.com
```

#### Option 2: External Secrets

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: gcp-creds
spec:
  secretStoreRef:
    name: gcp-secret-manager
  target:
    name: gcp-creds
```

## Connection Secrets

### Writing Connection Secrets

XRDs can write connection information to secrets:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: database-connection
    namespace: production
```

### Accessing Connection Secrets

Applications can reference connection secrets:

```yaml
env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: database-connection
        key: url
```

## Best Practices

### 1. Use IAM Roles

Prefer IAM roles over static credentials:

```yaml
# AWS IRSA
annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/Role

# Azure Workload Identity
annotations:
  azure.workload.identity/client-id: "client-id"

# GCP Workload Identity
annotations:
  iam.gke.io/gcp-service-account: service-account@project.iam.gserviceaccount.com
```

### 2. Use External Secrets Operator

Sync secrets from external systems:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: provider-creds
spec:
  secretStoreRef:
    name: vault-backend
  target:
    name: provider-creds
```

### 3. Encrypt Secrets at Rest

Use Sealed Secrets for Git storage:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: aws-creds
spec:
  encryptedData:
    credentials: AgBy3i4OJSWK+PiTySYZZA9rO43cGDEQAx...
```

### 4. Rotate Credentials

Implement credential rotation:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: rotating-creds
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
```

### 5. Limit Secret Access

Use RBAC to limit who can access secrets:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: secret-reader
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    resourceNames: ["database-connection"]
    verbs: ["get"]
```

## Troubleshooting

### Secret Not Found

```bash
# Check secret exists
kubectl get secret aws-creds -n crossplane-system

# Check external secret status
kubectl get externalsecret aws-creds -n crossplane-system

# Check external secret events
kubectl describe externalsecret aws-creds -n crossplane-system
```

### Secret Access Denied

```bash
# Check RBAC permissions
kubectl auth can-i get secret aws-creds -n crossplane-system

# Check service account permissions
kubectl describe rolebinding -n crossplane-system
```

### Secret Sync Issues

```bash
# Check external secrets operator logs
kubectl logs -n external-secrets-system -l app.kubernetes.io/name=external-secrets

# Check secret store
kubectl get secretstore -n crossplane-system
```

## Examples

This directory contains example configurations:

- **external-secrets.yaml** - External Secrets Operator examples
- **sealed-secrets.yaml** - Sealed Secrets examples
- **vault-integration.yaml** - Vault integration examples

## Next Steps

Now that you understand secrets management:

1. **Policy Enforcement** - Enforce security policies
2. **Compliance** - Set up audit logging
3. **Production** - Deploy secure configurations

## Additional Resources

- [External Secrets Operator](https://external-secrets.io/)
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- [HashiCorp Vault](https://www.vaultproject.io/)
- [AWS IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

---

**Ready to enforce policies?** Move to [Policy Enforcement](../03-policy-enforcement/)!
