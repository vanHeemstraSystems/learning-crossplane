# Backup and Restore

Backup and restore procedures are essential for disaster recovery and data protection. This guide covers backup strategies and restore procedures for Crossplane.

## Overview

Backup and restore for Crossplane involves:

- **Configuration Backups**: XRDs, Compositions, Provider Configs
- **State Backups**: XR states and managed resource states
- **Secret Backups**: Provider credentials (in secure systems)
- **Disaster Recovery**: Complete platform restoration

## What to Backup

### Critical Resources

1. **Composite Resource Definitions (XRDs)**
   - Platform API definitions
   - Schema definitions

2. **Compositions**
   - Infrastructure patterns
   - Resource templates

3. **Provider Configurations**
   - Provider configs (excluding secrets)
   - Provider references

4. **Functions**
   - Composition function configs
   - Function references

### Optional Resources

- **Composite Resources (XRs)**: Usually recreated from Git
- **Managed Resources**: Usually recreated from XRs
- **Secrets**: Should be in external secrets management

## Backup Strategy

See [backup-strategy.md](./backup-strategy.md) for detailed backup strategy.

### Automated Backups

Set up automated backups using:

```bash
# Backup script (example)
#!/bin/bash
BACKUP_DIR="/backups/crossplane-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup XRDs
kubectl get xrd -o yaml > $BACKUP_DIR/xrds.yaml

# Backup Compositions
kubectl get composition -o yaml > $BACKUP_DIR/compositions.yaml

# Backup Provider Configs (without secrets)
kubectl get providerconfig -A -o yaml > $BACKUP_DIR/providerconfigs.yaml

# Backup Functions
kubectl get functions -o yaml > $BACKUP_DIR/functions.yaml
```

### Git-Based Backups

Store configurations in Git:

```bash
# Repository structure
crossplane-configs/
├── xrds/
│   ├── database-xrd.yaml
│   └── network-xrd.yaml
├── compositions/
│   ├── postgres-composition.yaml
│   └── vpc-composition.yaml
└── provider-configs/
    └── aws-providerconfig.yaml
```

### Backup Frequency

- **XRDs and Compositions**: Daily (or on every change)
- **Provider Configs**: Weekly (or on change)
- **Functions**: Weekly (or on change)
- **State Snapshots**: Daily

## Restore Procedures

See [restore-procedures.md](./restore-procedures.md) for detailed restore procedures.

### Restoring from Git

```bash
# Clone configuration repository
git clone <config-repo>
cd crossplane-configs

# Apply XRDs
kubectl apply -f xrds/

# Apply Compositions
kubectl apply -f compositions/

# Apply Provider Configs
kubectl apply -f provider-configs/
```

### Restoring from Backup Files

```bash
# Restore XRDs
kubectl apply -f backup/xrds.yaml

# Restore Compositions
kubectl apply -f backup/compositions.yaml

# Restore Provider Configs
kubectl apply -f backup/providerconfigs.yaml
```

## Disaster Recovery

### Recovery Scenarios

1. **Configuration Loss**
   - Restore from Git or backups
   - Verify configurations
   - Test functionality

2. **Cluster Loss**
   - Restore cluster
   - Reinstall Crossplane
   - Restore configurations
   - Recreate XRs if needed

3. **Provider Issues**
   - Verify provider configs
   - Check credentials
   - Test provider connectivity

### Recovery Checklist

- [ ] Cluster accessible
- [ ] Crossplane installed
- [ ] XRDs restored
- [ ] Compositions restored
- [ ] Provider configs restored
- [ ] Credentials configured
- [ ] Providers healthy
- [ ] Test resource creation

## Best Practices

### 1. Version Control

Store all configurations in Git:
- Enable version history
- Review changes
- Rollback if needed

### 2. Automated Backups

Automate backup processes:
- Schedule regular backups
- Test restore procedures
- Verify backup integrity

### 3. Secure Storage

Store backups securely:
- Encrypt backup data
- Use secure storage
- Limit access to backups

### 4. Test Restores

Regularly test restore procedures:
- Test in non-production
- Document procedures
- Train team members

### 5. Document Procedures

Document backup/restore procedures:
- Step-by-step guides
- Recovery scenarios
- Contact information

## Examples

This directory contains backup and restore resources:

- **backup-strategy.md** - Detailed backup strategy
- **restore-procedures.md** - Step-by-step restore procedures

## Next Steps

1. **Define Strategy** - Plan backup strategy
2. **Implement Backups** - Set up automated backups
3. **Test Restores** - Practice restore procedures
4. **Document** - Document all procedures

## Additional Resources

- [Kubernetes Backup](https://kubernetes.io/docs/tasks/administer-cluster/backup/)
- [Velero](https://velero.io/) - Kubernetes backup tool
- [Disaster Recovery Best Practices](https://kubernetes.io/docs/tasks/administer-cluster/cluster-management/)

---

**Ready to upgrade?** Move to [Upgrades](../04-upgrades/)!
