# Troubleshooting Crossplane

Effective troubleshooting is essential for maintaining a healthy Crossplane platform. This guide covers common issues, debug procedures, and log analysis.

## Overview

Troubleshooting Crossplane involves:

- **Identifying Issues**: Recognizing problems quickly
- **Debugging**: Using tools and commands to diagnose
- **Log Analysis**: Understanding logs and error messages
- **Resolution**: Fixing issues and preventing recurrence

## Quick Debug Commands

Common commands for troubleshooting. See [debug-commands.sh](./debug-commands.sh) for a complete script.

### Check Crossplane Status

```bash
# Check Crossplane pods
kubectl get pods -n crossplane-system

# Check Crossplane logs
kubectl logs -n crossplane-system -l app=crossplane --tail=100

# Check provider pods
kubectl get pods -n crossplane-system -l component=provider
```

### Check Resource Status

```bash
# List all XRs
kubectl get xr -A

# Check XR status
kubectl describe xr <name> -n <namespace>

# Check managed resources
kubectl get managed -A
```

## Common Issues

See [common-issues.md](./common-issues.md) for detailed solutions.

### Issue 1: Resources Stuck in Creating

**Symptoms:**
- Resources remain in "Creating" status
- No progress after several minutes

**Diagnosis:**
```bash
# Check XR status
kubectl describe xr <name> -n <namespace>

# Check events
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Check provider logs
kubectl logs -n crossplane-system -l provider=<provider-name>
```

**Common Causes:**
- Provider credentials invalid
- Insufficient permissions
- Resource configuration invalid
- Provider API issues

### Issue 2: Provider Not Ready

**Symptoms:**
- Provider shows "NotReady" status
- Resources cannot be created

**Diagnosis:**
```bash
# Check provider status
kubectl get providers

# Check provider pod logs
kubectl logs -n crossplane-system -l provider=<provider-name>

# Check provider configuration
kubectl get providerconfig -A
```

**Common Causes:**
- Invalid credentials
- Network connectivity issues
- Provider configuration errors
- Resource limits exceeded

### Issue 3: Composition Not Working

**Symptoms:**
- XR created but no managed resources
- Composition not rendering

**Diagnosis:**
```bash
# Check composition
kubectl get composition <name>

# Check XR status
kubectl describe xr <name> -n <namespace>

# Check composition render logs
kubectl logs -n crossplane-system -l app=crossplane | grep composition
```

**Common Causes:**
- Composition not matching XR
- Invalid patch configuration
- Function errors
- Schema mismatches

## Log Analysis

See [logs-analysis.md](./logs-analysis.md) for detailed log analysis guide.

### Understanding Log Levels

- **ERROR**: Critical issues requiring attention
- **WARN**: Warnings that may indicate problems
- **INFO**: Informational messages
- **DEBUG**: Detailed debugging information

### Key Log Patterns

**Reconciliation Errors:**
```
ERROR controller.composite "Failed to render composite" error="..."
```

**Provider Errors:**
```
ERROR provider.aws "Failed to create resource" error="..."
```

**Composition Errors:**
```
ERROR composition "Failed to render composition" error="..."
```

## Debug Workflow

1. **Identify the Issue**
   - Check alerts
   - Review metrics
   - Check resource status

2. **Gather Information**
   - Collect logs
   - Check events
   - Review configurations

3. **Analyze the Problem**
   - Identify root cause
   - Check related resources
   - Review error messages

4. **Apply Fix**
   - Fix configuration
   - Update credentials
   - Restart components if needed

5. **Verify Resolution**
   - Check resource status
   - Monitor logs
   - Verify functionality

## Best Practices

### 1. Enable Debug Logging

Set log level to debug for detailed information:

```yaml
args:
  - --log-level=debug
```

### 2. Monitor Key Metrics

Watch metrics for:
- Error rates
- Reconciliation times
- Resource counts

### 3. Document Solutions

Document solutions to common issues for future reference.

### 4. Use Structured Logging

Use structured logging for easier analysis.

## Examples

This directory contains troubleshooting resources:

- **debug-commands.sh** - Common debug commands
- **common-issues.md** - Solutions to common issues
- **logs-analysis.md** - Log analysis guide

## Next Steps

1. **Practice Troubleshooting** - Work through common scenarios
2. **Build Runbooks** - Document procedures
3. **Set up Monitoring** - Enable comprehensive monitoring
4. **Review Regularly** - Learn from incidents

## Additional Resources

- [Crossplane Troubleshooting](https://docs.crossplane.io/latest/troubleshooting/)
- [Kubernetes Debugging](https://kubernetes.io/docs/tasks/debug/)
- [Log Analysis Tools](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

---

**Ready to protect your data?** Move to [Backup/Restore](../03-backup-restore/)!
