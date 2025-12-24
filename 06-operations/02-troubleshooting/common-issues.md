# Common Crossplane Issues and Solutions

This document provides solutions to common issues encountered when operating Crossplane.

## Issue 1: Resources Stuck in "Creating" Status

### Symptoms
- XR or managed resource remains in "Creating" status for extended period
- No progress visible in status or events
- Reconciliation continues but resource never becomes ready

### Diagnosis

```bash
# Check XR status and conditions
kubectl describe xr <name> -n <namespace>

# Check events
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Check provider logs
kubectl logs -n crossplane-system -l provider=<provider-name> --tail=100

# Check managed resource status
kubectl get managed -n <namespace>
kubectl describe managed <resource-name> -n <namespace>
```

### Common Causes and Solutions

#### 1. Invalid Provider Credentials

**Cause:** Provider cannot authenticate with cloud provider

**Solution:**
```bash
# Check provider config
kubectl get providerconfig -A

# Check credentials secret
kubectl get secret <credential-secret> -n crossplane-system

# Verify credentials are valid
# For AWS: Check IAM permissions
# For Azure: Check service principal
# For GCP: Check service account key
```

#### 2. Insufficient Permissions

**Cause:** Provider credentials don't have required permissions

**Solution:**
- Review IAM policies / roles
- Add missing permissions
- Test with minimal required permissions first

#### 3. Invalid Resource Configuration

**Cause:** Resource specification contains invalid values

**Solution:**
```bash
# Check XR spec
kubectl get xr <name> -n <namespace> -o yaml

# Validate against XRD schema
kubectl get xrd <xrd-name> -o yaml

# Check composition patches
kubectl get composition <name> -o yaml
```

#### 4. Provider API Issues

**Cause:** Cloud provider API is experiencing issues

**Solution:**
- Check cloud provider status page
- Check provider logs for API errors
- Retry after some time

## Issue 2: Provider Not Ready

### Symptoms
- Provider shows "NotReady" status
- ProviderRevision shows error conditions
- Resources cannot be created or updated

### Diagnosis

```bash
# Check provider status
kubectl get providers
kubectl describe provider <name>

# Check provider revision
kubectl get providerrevisions
kubectl describe providerrevision <name>

# Check provider pod
kubectl get pods -n crossplane-system -l provider=<provider-name>
kubectl logs -n crossplane-system -l provider=<provider-name>
```

### Common Causes and Solutions

#### 1. Invalid Provider Image

**Cause:** Provider image cannot be pulled or is invalid

**Solution:**
```bash
# Check image pull errors
kubectl describe pod <provider-pod> -n crossplane-system

# Verify image exists and is accessible
# Check image pull secrets if using private registry
```

#### 2. Provider Configuration Errors

**Cause:** Provider configuration is invalid

**Solution:**
```bash
# Check provider configuration
kubectl get providerconfig -A -o yaml

# Validate YAML syntax
# Check required fields are present
```

#### 3. Resource Limits

**Cause:** Provider pod hit resource limits

**Solution:**
```bash
# Check pod resource usage
kubectl top pod -n crossplane-system

# Increase resource limits in provider deployment
```

## Issue 3: Composition Not Rendering

### Symptoms
- XR created but no managed resources created
- Composition status shows errors
- XR stuck without resource references

### Diagnosis

```bash
# Check XR status
kubectl get xr <name> -n <namespace> -o yaml

# Check composition
kubectl get composition <name> -o yaml

# Check composition logs
kubectl logs -n crossplane-system -l app=crossplane | grep composition

# Check function logs if using functions
kubectl logs -n crossplane-system -l function=<function-name>
```

### Common Causes and Solutions

#### 1. Composition Not Matching

**Cause:** No composition matches the XR

**Solution:**
```bash
# Check composition matchLabels
kubectl get composition <name> -o yaml | grep matchLabels

# Check XR labels
kubectl get xr <name> -n <namespace> -o yaml | grep labels

# Ensure labels match
```

#### 2. Invalid Patches

**Cause:** Patch configuration is invalid

**Solution:**
```bash
# Review composition patches
kubectl get composition <name> -o yaml

# Check patch paths exist in XR spec
# Validate patch types are correct
# Test patches incrementally
```

#### 3. Function Errors

**Cause:** Composition function failing

**Solution:**
```bash
# Check function status
kubectl get functions
kubectl logs -n crossplane-system -l function=<function-name>

# Review function configuration
# Check function input/output
```

## Issue 4: Resources Not Updating

### Symptoms
- Changes to XR spec don't propagate
- Managed resources don't reflect XR changes
- Update reconciliation not occurring

### Diagnosis

```bash
# Check XR generation
kubectl get xr <name> -n <namespace> -o jsonpath='{.metadata.generation}'
kubectl get xr <name> -n <namespace> -o jsonpath='{.status.observedGeneration}'

# Check reconciliation status
kubectl describe xr <name> -n <namespace> | grep -A 10 Conditions

# Check managed resource spec
kubectl get managed <name> -o yaml
```

### Common Causes and Solutions

#### 1. Reconciliation Paused

**Cause:** Reconciliation is paused on resource

**Solution:**
```bash
# Check pause annotation
kubectl get xr <name> -n <namespace> -o jsonpath='{.metadata.annotations.crossplane\.io/paused}'

# Remove pause annotation
kubectl annotate xr <name> -n <namespace> crossplane.io/paused- --overwrite
```

#### 2. Update Policy

**Cause:** Update policy prevents updates

**Solution:**
```bash
# Check update policy
kubectl get managed <name> -o jsonpath='{.spec.updatePolicy}'

# Review update policy configuration
# Consider changing to Automatic if Manual
```

#### 3. Immutable Fields Changed

**Cause:** Trying to change immutable fields

**Solution:**
- Identify immutable fields
- Delete and recreate resource if necessary
- Use deletion policy to retain cloud resource

## Issue 5: Provider Connection Errors

### Symptoms
- Provider shows connection errors
- API calls failing
- Timeout errors in logs

### Diagnosis

```bash
# Check provider logs
kubectl logs -n crossplane-system -l provider=<provider-name> | grep -i error

# Check network connectivity
kubectl exec -n crossplane-system <provider-pod> -- curl -v <api-endpoint>

# Check DNS resolution
kubectl exec -n crossplane-system <provider-pod> -- nslookup <api-endpoint>
```

### Common Causes and Solutions

#### 1. Network Policies

**Cause:** Network policies blocking outbound connections

**Solution:**
```bash
# Check network policies
kubectl get networkpolicies -n crossplane-system

# Allow outbound connections to provider APIs
```

#### 2. Proxy Configuration

**Cause:** Proxy not configured correctly

**Solution:**
- Configure proxy environment variables
- Update provider deployment with proxy settings

#### 3. DNS Issues

**Cause:** DNS resolution failing

**Solution:**
- Check DNS configuration
- Verify CoreDNS is running
- Check DNS resolution from provider pod

## General Troubleshooting Tips

1. **Check Logs First**: Always start with logs to understand the issue
2. **Review Events**: Kubernetes events provide useful context
3. **Validate Configurations**: Ensure all YAML is valid
4. **Test Incrementally**: Make changes incrementally to isolate issues
5. **Check Dependencies**: Ensure all prerequisites are met
6. **Review Documentation**: Check official documentation for known issues
7. **Community Resources**: Check GitHub issues and discussions

## Getting Help

If issues persist:

1. Gather diagnostic information using debug commands
2. Check Crossplane GitHub issues
3. Review Crossplane documentation
4. Ask in Crossplane Slack/Discord
5. Create a minimal reproduction case
6. File an issue with detailed information
