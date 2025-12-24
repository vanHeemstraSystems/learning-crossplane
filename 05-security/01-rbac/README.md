# RBAC for Crossplane

Role-Based Access Control (RBAC) is essential for securing Crossplane deployments. This guide covers implementing proper access control for users, service accounts, and applications.

## Overview

RBAC in Crossplane controls:

- **Who** can create/modify XRs and compositions
- **What** resources users can access
- **Where** (which namespaces) users can operate
- **How** service accounts interact with Crossplane

## RBAC Components

### 1. Service Accounts

Service accounts for Crossplane components:

- **Crossplane Core**: System service account
- **Providers**: Provider-specific service accounts
- **Functions**: Function service accounts

See [service-accounts.yaml](./service-accounts.yaml)

### 2. Roles

Define what actions are allowed:

- **ClusterRoles**: Cluster-wide permissions
- **Roles**: Namespace-scoped permissions

See [roles.yaml](./roles.yaml)

### 3. Role Bindings

Bind roles to users/service accounts:

- **ClusterRoleBindings**: Cluster-wide bindings
- **RoleBindings**: Namespace-scoped bindings

See [rolebindings.yaml](./rolebindings.yaml)

## Service Accounts

### Crossplane Core Service Account

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: crossplane
  namespace: crossplane-system
```

### Provider Service Accounts

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: provider-aws
  namespace: crossplane-system
```

## Roles

### Developer Role (Namespace-Scoped)

Allows developers to create XRs in their namespace:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  namespace: production
rules:
  - apiGroups: ["database.example.org"]
    resources: ["databaseclaims"]
    verbs: ["get", "list", "create", "update", "delete"]
  - apiGroups: ["app.example.org"]
    resources: ["applicationclaims"]
    verbs: ["get", "list", "create", "update", "delete"]
```

### Platform Admin Role (Cluster-Scoped)

Allows platform administrators to manage compositions:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: platform-admin
rules:
  - apiGroups: ["apiextensions.crossplane.io"]
    resources: ["compositions", "compositeresourcedefinitions"]
    verbs: ["get", "list", "create", "update", "delete"]
```

## Role Bindings

### Developer Role Binding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: production
subjects:
  - kind: User
    name: developer@example.com
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

### Platform Admin Role Binding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: platform-admin-binding
subjects:
  - kind: Group
    name: platform-admins
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: platform-admin
  apiGroup: rbac.authorization.k8s.io
```

## Common Patterns

### Pattern 1: Team-Based Access

Different teams in different namespaces:

```yaml
# Team A namespace
apiVersion: v1
kind: Namespace
metadata:
  name: team-a

# Team A role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: team-a-developer
  namespace: team-a
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["get", "list", "create", "update"]
```

### Pattern 2: Resource-Specific Access

Limit access to specific resource types:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: database-user
rules:
  - apiGroups: ["database.example.org"]
    resources: ["databaseclaims"]
    verbs: ["get", "list", "create"]
  # No access to other resources
```

### Pattern 3: Read-Only Access

Read-only access for auditors:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: auditor
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["get", "list", "watch"]
```

## Best Practices

### 1. Use Namespaces for Isolation

```yaml
# Separate namespace per team/environment
metadata:
  namespace: production
```

### 2. Follow Least Privilege

Grant only necessary permissions:

```yaml
# Good: Specific permissions
verbs: ["get", "list", "create"]

# Avoid: Wildcard permissions
verbs: ["*"]
```

### 3. Use Role Bindings (Not Direct Permissions)

Bind roles to users, not grant permissions directly.

### 4. Regular Access Reviews

Review and audit access regularly:

```bash
# List all role bindings
kubectl get rolebindings --all-namespaces

# Check user permissions
kubectl auth can-i create databaseclaims --namespace production --as=developer@example.com
```

### 5. Use Groups Instead of Individual Users

```yaml
subjects:
  - kind: Group
    name: developers
    # Instead of individual users
```

## Testing RBAC

### Check Permissions

```bash
# Check if user can perform action
kubectl auth can-i create databaseclaims --namespace production

# Check as different user
kubectl auth can-i create databaseclaims --namespace production --as=developer@example.com

# Check all permissions
kubectl auth can-i --list --namespace production
```

### Test Role Bindings

```bash
# List role bindings
kubectl get rolebindings -n production

# Describe role binding
kubectl describe rolebinding developer-binding -n production

# Check what role allows
kubectl describe role developer -n production
```

## Troubleshooting

### Access Denied

```bash
# Check role binding exists
kubectl get rolebinding -n production

# Check role exists
kubectl get role -n production

# Check user is in role binding
kubectl describe rolebinding developer-binding -n production

# Check permissions
kubectl auth can-i create databaseclaims --namespace production
```

### Too Many Permissions

```bash
# Review role permissions
kubectl describe role developer -n production

# Review cluster role permissions
kubectl describe clusterrole platform-admin

# List all permissions
kubectl auth can-i --list --namespace production
```

## Examples

This directory contains example RBAC configurations:

- **service-accounts.yaml** - Service account examples
- **roles.yaml** - Role examples
- **rolebindings.yaml** - Role binding examples

## Next Steps

Now that you understand RBAC:

1. **Secrets Management** - Secure your credentials
2. **Policy Enforcement** - Enforce policies
3. **Compliance** - Set up audit logging

## Additional Resources

- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Crossplane RBAC Guide](https://docs.crossplane.io/latest/security/rbac/)

---

**Ready to secure secrets?** Move to [Secrets Management](../02-secrets-management/)!
