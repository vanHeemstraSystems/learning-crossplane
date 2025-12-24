# Database Platform

A complete self-service database platform that enables developers to provision databases on-demand with support for multiple database engines.

## Overview

This example demonstrates how to build a database platform that:

- Supports multiple database engines (PostgreSQL, MySQL, MongoDB)
- Provides environment-specific configurations
- Manages connection secrets automatically
- Enables developer self-service

## Architecture

```
Developer creates Database XR
    ↓
XRD validates input
    ↓
Composition selected (based on engine)
    ↓
Managed resources created (RDS, Azure DB, etc.)
    ↓
Connection secrets written
    ↓
Database ready for use
```

## Components

### 1. XRD (Custom API)

Defines the Database API that developers use:
- Engine selection (postgres, mysql, mongodb)
- Instance configuration
- Environment settings
- Connection secret management

See [xrd/database-xrd.yaml](./xrd/database-xrd.yaml)

### 2. Compositions

Different compositions for different engines:
- **PostgreSQL**: AWS RDS PostgreSQL
- **MySQL**: AWS RDS MySQL
- **MongoDB**: MongoDB Atlas or self-hosted

See [compositions/](./compositions/) directory

### 3. Example Usage

Sample Database XRs showing how developers use the platform.

See [claims/](./claims/) directory

## Installation

### Step 1: Install XRD

```bash
kubectl apply -f xrd/database-xrd.yaml
```

Verify:

```bash
kubectl get xrd databases.database.example.org
```

### Step 2: Install Compositions

```bash
# Install all compositions
kubectl apply -f compositions/

# Or install individually
kubectl apply -f compositions/postgres-composition.yaml
kubectl apply -f compositions/mysql-composition.yaml
kubectl apply -f compositions/mongodb-composition.yaml
```

Verify:

```bash
kubectl get composition
```

### Step 3: Create a Database

```bash
kubectl apply -f claims/sample-database.yaml
```

Monitor:

```bash
kubectl get database sample-db -w
kubectl describe database sample-db
```

## Usage Examples

### PostgreSQL Database

```yaml
apiVersion: database.example.org/v1alpha1
kind: Database
metadata:
  name: my-postgres-db
  namespace: production
spec:
  engine: postgres
  engineVersion: "15.4"
  instanceClass: db.t3.medium
  storageSize: 100
  environment: production
  writeConnectionSecretsToRef:
    name: postgres-connection
    namespace: production
```

### MySQL Database

```yaml
apiVersion: database.example.org/v1alpha1
kind: Database
metadata:
  name: my-mysql-db
  namespace: development
spec:
  engine: mysql
  engineVersion: "8.0"
  instanceClass: db.t3.micro
  storageSize: 20
  environment: development
```

### MongoDB Database

```yaml
apiVersion: database.example.org/v1alpha1
kind: Database
metadata:
  name: my-mongodb
  namespace: staging
spec:
  engine: mongodb
  instanceClass: M10
  storageSize: 50
  environment: staging
```

## Features

### Multi-Engine Support

The same API works for different database engines:

```yaml
spec:
  engine: postgres  # or mysql, mongodb
```

### Environment-Specific Configuration

Automatically configures based on environment:

- **Development**: Small instances, no backups
- **Staging**: Medium instances, daily backups
- **Production**: Large instances, multi-AZ, automated backups

### Connection Secret Management

Automatically writes connection information to secrets:

```yaml
spec:
  writeConnectionSecretsToRef:
    name: db-connection
    namespace: app
```

Access the secret:

```bash
kubectl get secret db-connection -n app -o yaml
```

### Automatic Backups

Production databases automatically get:
- Daily backups
- 7-day retention
- Point-in-time recovery

## Customization

### Adding a New Engine

1. Create a new composition for the engine
2. Add the engine to the XRD enum
3. Test with sample XR

### Modifying Instance Classes

Update the composition to use different instance classes:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.instanceClass
    toFieldPath: spec.forProvider.dbInstanceClass
```

### Adding Custom Tags

Add tags based on XR fields:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.environment
    toFieldPath: spec.forProvider.tags[Environment]
```

## Best Practices Demonstrated

1. **Clear API**: Simple, intuitive API for developers
2. **Validation**: Schema validation prevents errors
3. **Secrets Management**: Secure handling of credentials
4. **Environment Awareness**: Different configs per environment
5. **Documentation**: Complete usage documentation

## Troubleshooting

### Database Not Creating

```bash
# Check XR status
kubectl describe database my-db

# Check composition match
kubectl get composition

# Check provider health
kubectl get provider provider-aws-aws
```

### Connection Secret Not Created

```bash
# Check XR status for secret reference
kubectl get database my-db -o jsonpath='{.status.connectionDetails}'

# Verify writeConnectionSecretsToRef is set
kubectl get database my-db -o yaml | grep writeConnectionSecretsToRef
```

### Wrong Engine Selected

```bash
# Verify engine in XR
kubectl get database my-db -o jsonpath='{.spec.engine}'

# Check available compositions
kubectl get composition -l engine=postgres
```

## Next Steps

1. **Customize**: Adapt to your database needs
2. **Add Engines**: Add support for more database engines
3. **Enhance**: Add monitoring, backups, scaling
4. **Production**: Deploy in your production environment

## Additional Resources

- [Database Platform Patterns](https://docs.crossplane.io/latest/concepts/composition/)
- [AWS RDS Provider](https://marketplace.upbound.io/providers/upbound/provider-aws-aws/)
- [Azure Database Provider](https://marketplace.upbound.io/providers/upbound/provider-azure-azure/)

---

**Ready for the next example?** Check out [Application Platform](../02-application-platform/)!
