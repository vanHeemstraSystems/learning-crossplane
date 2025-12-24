# Backup Strategy

A comprehensive backup strategy ensures you can recover from data loss or disasters. This document outlines backup strategies for Crossplane.

## Backup Overview

### What Needs Backup

#### Critical (Must Backup)
- **XRDs**: Platform API definitions
- **Compositions**: Infrastructure patterns
- **Provider Configs**: Provider configurations (structure, not secrets)
- **Functions**: Composition function configurations

#### Important (Should Backup)
- **XR State**: Current state of XRs (for recovery reference)
- **Composition Metadata**: Composition versions and labels

#### Optional (Nice to Have)
- **Event History**: Recent events for debugging
- **Audit Logs**: Compliance and security logs

#### Do NOT Backup in Kubernetes
- **Secrets**: Should be in external secrets management
- **Managed Resources**: Recreated from XRs
- **Provider Credentials**: Managed externally

## Backup Methods

### Method 1: Git-Based Backup (Recommended)

Store all configurations in Git repositories:

**Advantages:**
- Version control
- Change history
- Easy rollback
- Collaboration

**Structure:**
```
crossplane-configs/
├── xrds/
│   ├── database-xrd.yaml
│   ├── network-xrd.yaml
│   └── application-xrd.yaml
├── compositions/
│   ├── database/
│   │   ├── postgres-composition.yaml
│   │   └── mysql-composition.yaml
│   ├── network/
│   │   └── vpc-composition.yaml
│   └── application/
│       └── k8s-app-composition.yaml
├── provider-configs/
│   ├── aws-providerconfig.yaml
│   ├── azure-providerconfig.yaml
│   └── gcp-providerconfig.yaml
├── functions/
│   └── function-configs.yaml
└── README.md
```

**Workflow:**
1. Export resources to YAML
2. Commit to Git
3. Push to remote repository
4. Automate with CI/CD

### Method 2: Automated YAML Backups

Script-based backups to storage:

**Advantages:**
- Automated
- Regular snapshots
- Storage flexibility

**Script Example:**
```bash
#!/bin/bash
BACKUP_DIR="/backups/crossplane-$(date +%Y%m%d-%H%M%S)"
STORAGE_BACKEND="s3://my-backups/crossplane"

mkdir -p $BACKUP_DIR

# Backup XRDs
kubectl get xrd -o yaml > $BACKUP_DIR/xrds.yaml

# Backup Compositions
kubectl get composition -o yaml > $BACKUP_DIR/compositions.yaml

# Backup Provider Configs (remove secrets)
kubectl get providerconfig -A -o yaml | \
  yq 'del(.items[].spec.credentials.secretRef)' > $BACKUP_DIR/providerconfigs.yaml

# Backup Functions
kubectl get functions -o yaml > $BACKUP_DIR/functions.yaml

# Compress and upload
tar -czf $BACKUP_DIR.tar.gz $BACKUP_DIR
aws s3 cp $BACKUP_DIR.tar.gz $STORAGE_BACKEND/
```

### Method 3: Velero Backups

Use Velero for Kubernetes resource backups:

**Advantages:**
- Kubernetes-native
- Backup entire namespace
- Point-in-time recovery

**Example:**
```bash
# Install Velero (if not installed)
# velero install --provider aws --bucket my-backups

# Backup Crossplane namespace
velero backup create crossplane-backup \
  --include-namespaces crossplane-system

# Schedule regular backups
velero schedule create crossplane-daily \
  --schedule="0 2 * * *" \
  --include-namespaces crossplane-system
```

## Backup Frequency

### Recommended Schedule

- **XRDs**: On every change (Git commit) + Daily snapshot
- **Compositions**: On every change (Git commit) + Daily snapshot
- **Provider Configs**: Weekly + On change
- **Functions**: Weekly + On change
- **State Snapshots**: Daily

### Retention Policy

- **Daily Backups**: Keep 30 days
- **Weekly Backups**: Keep 12 weeks
- **Monthly Backups**: Keep 12 months
- **Git History**: Keep indefinitely

## Backup Locations

### Storage Options

1. **Git Repository** (Primary)
   - Source of truth
   - Version controlled
   - Accessible to team

2. **Object Storage** (Secondary)
   - S3, GCS, Azure Blob
   - Long-term storage
   - Disaster recovery

3. **Local Storage** (Tertiary)
   - NFS, Local disk
   - Quick access
   - Short-term only

### Security Considerations

- **Encryption**: Encrypt backups at rest
- **Access Control**: Limit backup access
- **Verification**: Verify backup integrity
- **Offsite**: Store backups offsite

## Backup Validation

### Automated Checks

```bash
#!/bin/bash
BACKUP_FILE=$1

# Check file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found"
    exit 1
fi

# Validate YAML syntax
yq eval '.' $BACKUP_FILE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: Invalid YAML"
    exit 1
fi

# Check for required resources
REQUIRED=("xrd" "composition" "providerconfig")
for resource in "${REQUIRED[@]}"; do
    if ! grep -q "kind:.*$resource" $BACKUP_FILE; then
        echo "WARNING: Missing $resource"
    fi
done

echo "Backup validation passed"
```

### Restore Testing

Regularly test restore procedures:
- Monthly restore tests
- Document test results
- Update procedures as needed

## Automation

### Cron Job Example

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: crossplane-backup
  namespace: crossplane-system
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: bitnami/kubectl:latest
            command:
            - /bin/bash
            - -c
            - |
              # Backup script here
          restartPolicy: OnFailure
```

### GitOps Integration

Use GitOps to automatically backup:
- ArgoCD/Flux syncs from Git
- Git becomes backup automatically
- Changes tracked in Git history

## Monitoring Backups

### Backup Health Checks

Monitor backup success:
- Backup job status
- Backup file size
- Backup age
- Backup integrity

### Alerts

Set up alerts for:
- Backup failures
- Backup age too old
- Backup size anomalies
- Storage quota issues

## Best Practices

1. **Version Control**: Use Git for primary backup
2. **Automation**: Automate backup processes
3. **Testing**: Regularly test restore procedures
4. **Documentation**: Document backup procedures
5. **Security**: Encrypt and secure backups
6. **Retention**: Follow retention policies
7. **Validation**: Validate backup integrity
8. **Monitoring**: Monitor backup health
9. **Offsite**: Store backups offsite
10. **Recovery**: Test recovery procedures regularly
