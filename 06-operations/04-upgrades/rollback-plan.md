# Rollback Plan

Detailed procedures for rolling back Crossplane upgrades if issues occur.

## When to Rollback

Consider rollback if:

- Critical functionality is broken
- Unable to resolve upgrade issues
- Significant performance degradation
- Data integrity concerns
- Security issues discovered
- Unable to restore functionality within acceptable time

## Pre-Rollback Assessment

### Decision Criteria

1. **Severity Assessment**
   - How critical is the issue?
   - How many users/resources affected?
   - Can workaround be implemented?

2. **Time Assessment**
   - How long to fix vs rollback?
   - Maintenance window remaining?
   - Impact of extended downtime?

3. **Risk Assessment**
   - Risk of rollback itself?
   - Risk of staying on new version?
   - Data loss risk?

## Rollback Methods

### Method 1: Helm Rollback (Recommended)

If upgraded using Helm:

```bash
# Check upgrade history
helm history crossplane -n crossplane-system

# Rollback to previous version
helm rollback crossplane -n crossplane-system

# Rollback to specific revision
helm rollback crossplane <revision-number> -n crossplane-system
```

### Method 2: Kubernetes Deployment Rollback

If using kubectl:

```bash
# Check rollout history
kubectl rollout history deployment/crossplane -n crossplane-system

# Rollback to previous version
kubectl rollout undo deployment/crossplane -n crossplane-system

# Rollback to specific revision
kubectl rollout undo deployment/crossplane --to-revision=<revision-number> -n crossplane-system
```

### Method 3: Restore from Backup

If rollback doesn't work or need full restore:

```bash
# Restore from Velero backup
velero restore create crossplane-rollback \
  --from-backup pre-upgrade-backup \
  --include-namespaces crossplane-system

# Or restore from Git
git checkout <previous-commit>
kubectl apply -f .
```

### Method 4: Reinstall Previous Version

Complete reinstall (last resort):

```bash
# Uninstall current version
helm uninstall crossplane -n crossplane-system

# Install previous version
helm install crossplane crossplane-stable/crossplane \
  --namespace crossplane-system \
  --version <previous-version>

# Restore configurations
kubectl apply -f backup/
```

## Rollback Procedures

### Quick Rollback (Helm)

**Steps:**

1. Verify backup exists
   ```bash
   helm history crossplane -n crossplane-system
   ```

2. Execute rollback
   ```bash
   helm rollback crossplane -n crossplane-system
   ```

3. Monitor rollback
   ```bash
   kubectl get pods -n crossplane-system -w
   ```

4. Verify functionality
   ```bash
   kubectl get xr -A
   kubectl get providers
   ```

### Provider Rollback

**Steps:**

1. Rollback provider
   ```bash
   helm rollback provider-aws -n crossplane-system
   ```

2. Monitor provider
   ```bash
   kubectl get pods -n crossplane-system -l component=provider -w
   ```

3. Verify provider health
   ```bash
   kubectl get providers
   ```

4. Test provider functionality
   ```bash
   kubectl apply -f test-resource.yaml
   ```

### Full System Rollback

**Steps:**

1. Rollback Crossplane
   ```bash
   helm rollback crossplane -n crossplane-system
   ```

2. Rollback all providers
   ```bash
   for provider in provider-aws provider-azure provider-gcp; do
     helm rollback $provider -n crossplane-system
   done
   ```

3. Restore configurations
   ```bash
   kubectl apply -f backup/xrds.yaml
   kubectl apply -f backup/compositions.yaml
   kubectl apply -f backup/providerconfigs.yaml
   ```

4. Verify system health
   ```bash
   kubectl get pods -n crossplane-system
   kubectl get providers
   kubectl get xrd
   ```

## Post-Rollback Verification

### Immediate Checks

```bash
# Check all pods running
kubectl get pods -n crossplane-system

# Check for errors
kubectl logs -n crossplane-system -l app=crossplane --tail=50

# Verify providers
kubectl get providers

# Check resource reconciliation
kubectl get xr -A
```

### Functionality Testing

```bash
# Test resource creation
kubectl apply -f test-xr.yaml

# Monitor creation
kubectl get xr test-xr -w

# Verify managed resources
kubectl get managed -A

# Test resource update
kubectl patch xr test-xr -p '{"spec":{"environment":"staging"}}'

# Test resource deletion
kubectl delete xr test-xr
```

### Performance Verification

```bash
# Check reconciliation times
# Monitor metrics dashboard

# Check resource usage
kubectl top pods -n crossplane-system

# Verify no performance degradation
```

## Rollback Timeline

### Immediate (0-15 minutes)

- Decision to rollback
- Execute rollback
- Verify pods running

### Short-term (15-60 minutes)

- Verify functionality
- Test critical paths
- Monitor for issues

### Medium-term (1-4 hours)

- Full functionality testing
- Performance verification
- Issue investigation

### Long-term (4-24 hours)

- Continuous monitoring
- Root cause analysis
- Plan next upgrade

## Common Rollback Scenarios

### Scenario 1: Pods Not Starting

**Symptoms:**
- Pods in CrashLoopBackOff
- Image pull errors
- Configuration errors

**Rollback:**
```bash
# Quick rollback
helm rollback crossplane -n crossplane-system

# Check logs
kubectl logs -n crossplane-system -l app=crossplane
```

### Scenario 2: API Incompatibility

**Symptoms:**
- Resources not creating
- API errors
- Version mismatch errors

**Rollback:**
```bash
# Rollback to compatible version
helm rollback crossplane -n crossplane-system

# Verify API compatibility
kubectl api-versions | grep crossplane
```

### Scenario 3: Provider Issues

**Symptoms:**
- Provider unhealthy
- Resource creation failing
- Provider API errors

**Rollback:**
```bash
# Rollback provider
helm rollback provider-aws -n crossplane-system

# Verify provider
kubectl get providers
```

### Scenario 4: Performance Degradation

**Symptoms:**
- Slow reconciliation
- High resource usage
- Timeout errors

**Rollback:**
```bash
# Rollback
helm rollback crossplane -n crossplane-system

# Monitor performance
kubectl top pods -n crossplane-system
```

## Rollback Prevention

To reduce need for rollback:

1. **Thorough Testing**: Test in staging extensively
2. **Gradual Rollout**: Upgrade incrementally
3. **Monitor Closely**: Watch metrics during upgrade
4. **Backup Always**: Always backup before upgrade
5. **Plan Carefully**: Review all changes

## Post-Rollback Actions

### Documentation

- [ ] Document rollback reason
- [ ] Record issues encountered
- [ ] Update rollback procedures
- [ ] Share learnings with team

### Investigation

- [ ] Investigate root cause
- [ ] Review logs and metrics
- [ ] Check for known issues
- [ ] Contact support if needed

### Next Steps

- [ ] Plan fix for issues
- [ ] Schedule next upgrade attempt
- [ ] Update upgrade procedures
- [ ] Test fixes in staging

## Rollback Checklist

### Before Rollback

- [ ] Decision to rollback confirmed
- [ ] Rollback method selected
- [ ] Backup verified available
- [ ] Team notified
- [ ] Rollback plan reviewed

### During Rollback

- [ ] Execute rollback procedure
- [ ] Monitor pod status
- [ ] Check for errors
- [ ] Verify rollback progress

### After Rollback

- [ ] Verify pods running
- [ ] Test functionality
- [ ] Monitor for issues
- [ ] Document rollback
- [ ] Investigate root cause

## Best Practices

1. **Always Backup**: Backup before upgrade
2. **Test Rollback**: Test rollback in staging
3. **Document**: Document rollback procedures
4. **Monitor**: Monitor during and after rollback
5. **Learn**: Learn from rollback experiences
6. **Improve**: Improve procedures based on learnings
