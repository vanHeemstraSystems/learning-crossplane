# Upgrading Crossplane

Upgrading Crossplane requires careful planning and execution. This guide covers upgrade strategies, procedures, and rollback plans.

## Overview

Upgrading Crossplane involves:

- **Planning**: Version compatibility and upgrade path
- **Preparation**: Backup and testing
- **Execution**: Step-by-step upgrade procedure
- **Verification**: Post-upgrade validation
- **Rollback**: Reverting if issues occur

## Upgrade Types

### 1. Crossplane Core Upgrade

Upgrading the Crossplane control plane.

### 2. Provider Upgrades

Upgrading individual providers.

### 3. Function Upgrades

Upgrading composition functions.

### 4. Minor vs Major Upgrades

- **Minor**: Usually safe, backward compatible
- **Major**: May require migration, breaking changes

## Pre-Upgrade Checklist

See [upgrade-checklist.md](./upgrade-checklist.md) for detailed checklist.

### Before Upgrade

- [ ] Review release notes
- [ ] Check compatibility matrix
- [ ] Backup current state
- [ ] Test in staging
- [ ] Review breaking changes
- [ ] Plan migration if needed
- [ ] Notify team
- [ ] Schedule maintenance window

## Upgrade Procedure

### Step 1: Review Release Notes

```bash
# Check Crossplane releases
# https://github.com/crossplane/crossplane/releases

# Review:
# - New features
# - Breaking changes
# - Deprecations
# - Migration guides
```

### Step 2: Check Compatibility

```bash
# Check Kubernetes version compatibility
kubectl version

# Check provider compatibility
kubectl get providers

# Check current Crossplane version
kubectl get deployment crossplane -n crossplane-system -o jsonpath='{.spec.template.spec.containers[0].image}'
```

### Step 3: Backup Current State

```bash
# Backup configurations
kubectl get xrd -o yaml > backup/xrds.yaml
kubectl get composition -o yaml > backup/compositions.yaml
kubectl get providerconfig -A -o yaml > backup/providerconfigs.yaml

# Backup using Velero (if available)
velero backup create pre-upgrade-backup \
  --include-namespaces crossplane-system
```

### Step 4: Test in Staging

```bash
# Upgrade in staging first
# Test all functionality
# Verify resource creation
# Check for errors
```

### Step 5: Upgrade Crossplane

```bash
# Upgrade using Helm (recommended)
helm upgrade crossplane crossplane-stable/crossplane \
  --namespace crossplane-system \
  --version <new-version>

# Or upgrade using kubectl
kubectl set image deployment/crossplane \
  crossplane=crossplane/crossplane:<new-version> \
  -n crossplane-system
```

### Step 6: Upgrade Providers

```bash
# Upgrade provider using Helm
helm upgrade provider-aws crossplane-stable/provider-aws-aws \
  --namespace crossplane-system \
  --version <new-version>

# Or apply new provider YAML
kubectl apply -f provider-aws.yaml
```

### Step 7: Monitor Upgrade

```bash
# Watch pods during upgrade
kubectl get pods -n crossplane-system -w

# Check for errors
kubectl logs -n crossplane-system -l app=crossplane --tail=100

# Monitor resource reconciliation
kubectl get xr -A -w
```

### Step 8: Verify Upgrade

```bash
# Check Crossplane version
kubectl get deployment crossplane -n crossplane-system \
  -o jsonpath='{.spec.template.spec.containers[0].image}'

# Verify providers
kubectl get providers

# Test resource creation
kubectl apply -f test-resource.yaml

# Check for errors
kubectl get events -n crossplane-system --sort-by='.lastTimestamp'
```

## Version Migration

See [version-migration.yaml](./version-migration.yaml) for migration examples.

### Common Migrations

1. **v1 to v2**: Namespaced XRs by default
2. **Composition Changes**: API changes
3. **Provider Updates**: New resource support

## Rollback Plan

See [rollback-plan.md](./rollback-plan.md) for detailed rollback procedures.

### Quick Rollback

```bash
# Rollback Helm upgrade
helm rollback crossplane -n crossplane-system

# Or rollback deployment
kubectl rollout undo deployment/crossplane -n crossplane-system

# Restore from backup if needed
velero restore create --from-backup pre-upgrade-backup
```

## Best Practices

### 1. Test First

Always test upgrades in staging:
- Test all functionality
- Verify resource creation
- Check for errors

### 2. Backup Before Upgrade

Backup current state:
- Configuration backups
- Velero backups
- State snapshots

### 3. Upgrade Incrementally

Upgrade one component at a time:
- Crossplane core first
- Then providers
- Then functions

### 4. Monitor Closely

Monitor during and after upgrade:
- Pod health
- Resource reconciliation
- Error logs
- Performance metrics

### 5. Have Rollback Plan

Always have rollback plan ready:
- Document rollback steps
- Test rollback procedure
- Keep previous version available

## Examples

This directory contains upgrade resources:

- **upgrade-checklist.md** - Pre-upgrade checklist
- **rollback-plan.md** - Rollback procedures
- **version-migration.yaml** - Migration examples

## Next Steps

1. **Plan Upgrade** - Review requirements
2. **Test in Staging** - Verify compatibility
3. **Execute Upgrade** - Follow procedures
4. **Monitor** - Watch for issues
5. **Verify** - Test functionality

## Additional Resources

- [Crossplane Releases](https://github.com/crossplane/crossplane/releases)
- [Upgrade Guide](https://docs.crossplane.io/latest/software/upgrade/)
- [Breaking Changes](https://github.com/crossplane/crossplane/blob/master/CHANGELOG.md)

---

**Ready to optimize?** Move to [Performance](../05-performance/)!
