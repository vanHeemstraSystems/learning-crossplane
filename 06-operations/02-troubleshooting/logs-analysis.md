# Log Analysis Guide

Understanding Crossplane logs is crucial for effective troubleshooting. This guide explains how to analyze logs and identify issues.

## Log Levels

Crossplane uses standard log levels:

- **ERROR**: Critical errors requiring immediate attention
- **WARN**: Warnings that may indicate problems
- **INFO**: Informational messages about normal operation
- **DEBUG**: Detailed debugging information

## Viewing Logs

### Crossplane Core Logs

```bash
# All Crossplane logs
kubectl logs -n crossplane-system -l app=crossplane

# Specific pod logs
kubectl logs -n crossplane-system <crossplane-pod-name>

# Follow logs in real-time
kubectl logs -n crossplane-system -l app=crossplane -f

# Last N lines
kubectl logs -n crossplane-system -l app=crossplane --tail=100

# Since specific time
kubectl logs -n crossplane-system -l app=crossplane --since=1h
```

### Provider Logs

```bash
# All provider logs
kubectl logs -n crossplane-system -l component=provider

# Specific provider logs
kubectl logs -n crossplane-system -l provider=provider-aws-aws

# Follow provider logs
kubectl logs -n crossplane-system -l provider=provider-aws-aws -f
```

### Function Logs

```bash
# Function logs
kubectl logs -n crossplane-system -l function=<function-name>
```

## Log Patterns

### Reconciliation Logs

**Successful Reconciliation:**
```
INFO  controller.composite "Successfully reconciled composite resource" 
      composite="default/my-database" 
      controller="database.example.org/databaseclaims.database.example.org"
```

**Reconciliation Error:**
```
ERROR controller.composite "Failed to reconcile composite resource" 
      composite="default/my-database" 
      error="failed to render composite: ..."
```

### Provider Logs

**Successful Resource Creation:**
```
INFO  provider.aws "Successfully created resource" 
      resource="S3Bucket" 
      name="my-bucket"
```

**Provider Error:**
```
ERROR provider.aws "Failed to create resource" 
      resource="S3Bucket" 
      error="AccessDenied: Access Denied"
```

### Composition Logs

**Successful Composition:**
```
INFO  composition "Successfully rendered composition" 
      composition="database-aws-postgresql" 
      xr="default/my-database"
```

**Composition Error:**
```
ERROR composition "Failed to render composition" 
      composition="database-aws-postgresql" 
      error="patch failed: ..."
```

## Common Log Messages

### Error Messages

**Reconciliation Errors:**
- `"Failed to reconcile"` - General reconciliation failure
- `"failed to render composite"` - Composition rendering failed
- `"failed to create managed resource"` - Resource creation failed
- `"failed to update managed resource"` - Resource update failed

**Provider Errors:**
- `"AccessDenied"` - Permission denied
- `"InvalidParameter"` - Invalid configuration
- `"ResourceNotFound"` - Resource doesn't exist
- `"Throttling"` - API rate limit exceeded

**Network Errors:**
- `"connection refused"` - Cannot connect to API
- `"timeout"` - Request timed out
- `"DNS lookup failed"` - DNS resolution failed

### Warning Messages

**Reconciliation Warnings:**
- `"Reconciliation taking longer than expected"` - Slow reconciliation
- `"Retrying after error"` - Retrying failed operation
- `"Resource not ready"` - Resource not yet ready

**Provider Warnings:**
- `"API rate limit approaching"` - Approaching rate limit
- `"Resource update in progress"` - Update still in progress

## Analyzing Logs

### Filter by Error Level

```bash
# Show only errors
kubectl logs -n crossplane-system -l app=crossplane | grep ERROR

# Show errors and warnings
kubectl logs -n crossplane-system -l app=crossplane | grep -E "ERROR|WARN"
```

### Filter by Component

```bash
# Reconciliation logs
kubectl logs -n crossplane-system -l app=crossplane | grep reconcile

# Provider logs
kubectl logs -n crossplane-system -l app=crossplane | grep provider

# Composition logs
kubectl logs -n crossplane-system -l app=crossplane | grep composition
```

### Filter by Resource

```bash
# Logs for specific XR
kubectl logs -n crossplane-system -l app=crossplane | grep "my-database"

# Logs for specific managed resource
kubectl logs -n crossplane-system -l app=crossplane | grep "S3Bucket/my-bucket"
```

### Time-Based Analysis

```bash
# Logs from last hour
kubectl logs -n crossplane-system -l app=crossplane --since=1h

# Logs between timestamps (using grep and timestamps in logs)
kubectl logs -n crossplane-system -l app=crossplane | grep "2024-01-01 10:00"
```

## Log Aggregation

### Using grep

```bash
# Count errors
kubectl logs -n crossplane-system -l app=crossplane | grep -c ERROR

# Unique error messages
kubectl logs -n crossplane-system -l app=crossplane | grep ERROR | sort | uniq

# Errors by resource
kubectl logs -n crossplane-system -l app=crossplane | grep ERROR | grep -oP 'resource="\K[^"]*'
```

### Using jq (for JSON logs)

```bash
# Parse JSON logs
kubectl logs -n crossplane-system -l app=crossplane -o json | jq 'select(.level=="ERROR")'

# Filter by component
kubectl logs -n crossplane-system -l app=crossplane -o json | jq 'select(.component=="controller.composite")'

# Extract error messages
kubectl logs -n crossplane-system -l app=crossplane -o json | jq -r 'select(.level=="ERROR") | .msg'
```

## Structured Logging

Crossplane uses structured logging with fields:

- `controller`: Controller name
- `resource`: Resource kind/name
- `composite`: Composite resource reference
- `error`: Error message
- `duration`: Operation duration
- `reconciler`: Reconciler name

Use these fields for filtering and analysis:

```bash
# Filter by controller
kubectl logs -n crossplane-system -l app=crossplane | grep 'controller="database"'

# Filter by resource
kubectl logs -n crossplane-system -l app=crossplane | grep 'resource="S3Bucket"'
```

## Debug Logging

Enable debug logging for more detailed information:

```yaml
# In Crossplane deployment
args:
  - --log-level=debug
```

Debug logs include:
- Detailed reconciliation steps
- Patch operations
- Provider API calls
- Internal state transitions

## Best Practices

1. **Start with Error Logs**: Filter for ERROR level first
2. **Use Context**: Look at logs around the error time
3. **Follow the Flow**: Trace reconciliation flow through logs
4. **Check Related Logs**: Check provider and function logs together
5. **Document Patterns**: Note recurring error patterns
6. **Use Tools**: Use log aggregation tools for production
7. **Set Alerts**: Alert on error patterns

## Log Retention

Consider log retention policies:

- **Development**: Short retention (1-7 days)
- **Production**: Longer retention (30-90 days)
- **Compliance**: Extended retention as required

Configure log rotation and retention in your logging solution.

## Tools for Log Analysis

- **kubectl logs**: Basic log viewing
- **stern**: Multi-pod log tailing
- **kail**: Kubernetes log viewer
- **kubetail**: Log tailing with colors
- **ELK Stack**: Enterprise log aggregation
- **Loki**: Grafana log aggregation
- **Datadog/New Relic**: Managed log solutions
