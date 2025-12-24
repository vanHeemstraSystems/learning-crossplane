# Restore Procedures

Step-by-step procedures for restoring Crossplane configurations from backups.

## Prerequisites

Before starting restore:

- [ ] Kubernetes cluster accessible
- [ ] kubectl configured
- [ ] Backup files available
- [ ] Backup validated
- [ ] Restore plan documented

## Restore Scenarios

### Scenario 1: Configuration Loss

Restore XRDs, Compositions, and Provider Configs.

### Scenario 2: Complete Cluster Loss

Restore entire Crossplane installation and configurations.

### Scenario 3: Partial Restore

Restore specific resources (e.g., single XRD or Composition).

## Restore from Git (Recommended)

### Step 1: Clone Configuration Repository

```bash
# Clone the repository
git clone <your-config-repo-url>
cd crossplane-configs

# Verify structure
ls -la
```

### Step 2: Verify Crossplane is Running

```bash
# Check Crossplane pods
kubectl get pods -n crossplane-system

# Verify Crossplane is healthy
kubectl get deployment -n crossplane-system
```

### Step 3: Restore XRDs

```bash
# Apply XRDs
kubectl apply -f xrds/

# Verify XRDs
kubectl get xrd

# Check XRD status
kubectl describe xrd <xrd-name>
```

### Step 4: Restore Compositions

```bash
# Apply Compositions
kubectl apply -f compositions/

# Verify Compositions
kubectl get composition

# Check Composition status
kubectl describe composition <composition-name>
```

### Step 5: Restore Provider Configs

```bash
# Apply Provider Configs
kubectl apply -f provider-configs/

# Verify Provider Configs
kubectl get providerconfig -A

# Note: Credentials need to be configured separately
```

### Step 6: Restore Functions

```bash
# Apply Functions (if applicable)
kubectl apply -f functions/

# Verify Functions
kubectl get functions
```

### Step 7: Configure Credentials

```bash
# Configure provider credentials
# (Use your secrets management system)

# Verify provider health
kubectl get providers
```

### Step 8: Verify Functionality

```bash
# Test resource creation
kubectl apply -f test-xr.yaml

# Monitor resource creation
kubectl get xr -w

# Check managed resources
kubectl get managed -A
```

## Restore from Backup Files

### Step 1: Extract Backup

```bash
# Extract backup archive
tar -xzf crossplane-backup-YYYYMMDD-HHMMSS.tar.gz
cd crossplane-backup-YYYYMMDD-HHMMSS

# List backup contents
ls -la
```

### Step 2: Validate Backup

```bash
# Check YAML syntax
yq eval '.' xrds.yaml > /dev/null
yq eval '.' compositions.yaml > /dev/null
yq eval '.' providerconfigs.yaml > /dev/null

# Review backup contents
head -20 xrds.yaml
```

### Step 3: Restore Resources

```bash
# Restore XRDs
kubectl apply -f xrds.yaml

# Restore Compositions
kubectl apply -f compositions.yaml

# Restore Provider Configs (if not containing secrets)
kubectl apply -f providerconfigs.yaml

# Restore Functions (if present)
kubectl apply -f functions.yaml
```

### Step 4: Configure Secrets

Provider credentials must be configured separately:

```bash
# Create secret from external secrets management
kubectl create secret generic aws-creds \
  --from-file=credentials=aws-credentials.json \
  -n crossplane-system

# Update ProviderConfig to reference secret
kubectl patch providerconfig <name> -p '{"spec":{"credentials":{"secretRef":{"name":"aws-creds"}}}}'
```

### Step 5: Verify Restoration

```bash
# Check all resources restored
kubectl get xrd
kubectl get composition
kubectl get providerconfig -A

# Verify provider health
kubectl get providers

# Test functionality
kubectl apply -f test-resource.yaml
```

## Restore from Velero

### Step 1: List Available Backups

```bash
# List backups
velero backup get

# Describe backup
velero backup describe <backup-name>
```

### Step 2: Restore Backup

```bash
# Restore entire backup
velero restore create --from-backup <backup-name>

# Restore specific resources
velero restore create --from-backup <backup-name> \
  --include-resources xrd,composition,providerconfig
```

### Step 3: Monitor Restore

```bash
# Check restore status
velero restore get

# Describe restore
velero restore describe <restore-name>

# Check restore logs
velero restore logs <restore-name>
```

### Step 4: Verify Resources

```bash
# Verify resources restored
kubectl get xrd
kubectl get composition
kubectl get providerconfig -A
```

## Partial Restore

### Restore Single XRD

```bash
# Extract XRD from backup
yq eval '.items[] | select(.metadata.name=="database-xrd")' backup.yaml > database-xrd.yaml

# Apply XRD
kubectl apply -f database-xrd.yaml

# Verify
kubectl get xrd database-xrd
```

### Restore Single Composition

```bash
# Extract Composition from backup
yq eval '.items[] | select(.metadata.name=="postgres-composition")' backup.yaml > postgres-composition.yaml

# Apply Composition
kubectl apply -f postgres-composition.yaml

# Verify
kubectl get composition postgres-composition
```

## Post-Restore Tasks

### 1. Verify Provider Health

```bash
# Check all providers
kubectl get providers

# Check provider pods
kubectl get pods -n crossplane-system -l component=provider

# Check provider logs for errors
kubectl logs -n crossplane-system -l component=provider --tail=50
```

### 2. Test Resource Creation

```bash
# Create test XR
kubectl apply -f test-xr.yaml

# Monitor creation
kubectl get xr test-xr -w

# Verify managed resources created
kubectl get managed -l crossplane.io/composite=test-xr
```

### 3. Verify Compositions Work

```bash
# List available Compositions
kubectl get composition

# Create XR using Composition
kubectl apply -f test-xr.yaml

# Verify Composition rendered correctly
kubectl describe xr test-xr
```

### 4. Update Documentation

- Document restore date
- Note any issues encountered
- Update procedures if needed

## Troubleshooting Restore

### Issue: Resources Not Restoring

```bash
# Check for errors
kubectl get events --sort-by='.lastTimestamp'

# Check resource status
kubectl describe xrd <name>

# Check logs
kubectl logs -n crossplane-system -l app=crossplane
```

### Issue: Provider Configs Not Working

```bash
# Verify secrets exist
kubectl get secrets -n crossplane-system

# Check ProviderConfig references
kubectl get providerconfig <name> -o yaml

# Verify provider can access secrets
kubectl describe provider <provider-name>
```

### Issue: Dependencies Missing

Some resources depend on others:

```bash
# Restore in order:
# 1. XRDs first
# 2. Then Compositions (reference XRDs)
# 3. Then Provider Configs
# 4. Finally Functions
```

## Rollback Procedure

If restore causes issues:

```bash
# Delete restored resources
kubectl delete -f restored-resources.yaml

# Restore from previous backup
# (Repeat restore procedure with previous backup)

# Or restore from Git previous commit
git checkout <previous-commit-hash>
kubectl apply -f .
```

## Best Practices

1. **Test First**: Test restore in non-production
2. **Document**: Document all restore steps
3. **Verify**: Verify each step before proceeding
4. **Backup First**: Backup current state before restore
5. **Monitor**: Monitor during and after restore
6. **Validate**: Validate functionality after restore
7. **Rollback Plan**: Have rollback plan ready

## Recovery Time Objectives (RTO)

- **Configuration Loss**: 15-30 minutes
- **Partial Restore**: 30-60 minutes
- **Complete Cluster Loss**: 1-2 hours
- **Disaster Recovery**: 2-4 hours

## Recovery Point Objectives (RPO)

- **Git-Based**: Near zero (continuous)
- **Automated Backups**: Up to 24 hours
- **Manual Backups**: Depends on schedule
