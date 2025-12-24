# Monitoring Crossplane

Comprehensive monitoring is essential for operating Crossplane in production. This guide covers setting up metrics collection, dashboards, and alerting.

## Overview

Monitoring Crossplane involves:

- **Metrics Collection**: Prometheus metrics from Crossplane
- **Visualization**: Grafana dashboards for insights
- **Alerting**: Alerts for critical issues
- **Observability**: Complete visibility into platform health

## Prometheus Setup

### Installing Prometheus Operator

```bash
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
```

### ServiceMonitor for Crossplane

Create a ServiceMonitor to scrape Crossplane metrics:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: crossplane
  namespace: crossplane-system
spec:
  selector:
    matchLabels:
      app: crossplane
  endpoints:
    - port: metrics
      interval: 30s
```

## Key Metrics

### Crossplane Core Metrics

- **crossplane_reconcile_total**: Total reconciliations
- **crossplane_reconcile_duration_seconds**: Reconciliation duration
- **crossplane_reconcile_errors_total**: Reconciliation errors
- **crossplane_managed_resources**: Number of managed resources

### Provider Metrics

- **provider_api_requests_total**: Total API requests
- **provider_api_errors_total**: API errors
- **provider_resource_creation_duration_seconds**: Resource creation time
- **provider_health**: Provider health status

### XRD Metrics

- **xrd_reconcile_total**: XRD reconciliations
- **xr_reconcile_total**: XR reconciliations
- **composition_render_duration_seconds**: Composition rendering time

## Prometheus Rules

Define alerting rules for common issues. See [prometheus-rules.yaml](./prometheus-rules.yaml) for examples.

### Example Alert: High Error Rate

```yaml
- alert: HighReconciliationErrorRate
  expr: rate(crossplane_reconcile_errors_total[5m]) > 0.1
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "High reconciliation error rate"
    description: "Error rate is {{ $value }} errors/second"
```

## Grafana Dashboards

Create dashboards to visualize Crossplane metrics. See [grafana-dashboards/](./grafana-dashboards/) for examples.

### Dashboard Panels

Key panels to include:
- Reconciliation rate
- Error rate
- Resource counts
- Provider health
- Performance metrics

## Alerting

Set up alerts for critical issues. See [alerts.yaml](./alerts.yaml) for examples.

### Critical Alerts

- **Crossplane Down**: Crossplane pods not running
- **Provider Unhealthy**: Provider connection issues
- **High Error Rate**: Excessive reconciliation errors
- **Resource Creation Failing**: Resources failing to create

### Warning Alerts

- **Slow Reconciliation**: Slow reconciliation times
- **Capacity Warnings**: Resource capacity approaching limits
- **Performance Degradation**: Performance metrics degrading

## Best Practices

### 1. Collect All Metrics

Enable metrics for:
- Crossplane core
- All providers
- Compositions
- XRs

### 2. Use Appropriate Intervals

- **High-frequency metrics**: 15-30 second intervals
- **Standard metrics**: 1-5 minute intervals
- **Capacity metrics**: 5-15 minute intervals

### 3. Set Meaningful Alerts

- **Critical**: Immediate action required
- **Warning**: Attention needed soon
- **Info**: Informational only

### 4. Regular Dashboard Reviews

- Daily health checks
- Weekly trend analysis
- Monthly capacity reviews

## Troubleshooting Monitoring

### Metrics Not Appearing

```bash
# Check ServiceMonitor exists
kubectl get servicemonitor -n crossplane-system

# Check metrics endpoint
kubectl port-forward -n crossplane-system svc/crossplane 8080:8080
curl http://localhost:8080/metrics

# Check Prometheus targets
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Open http://localhost:9090/targets
```

### Alerts Not Firing

```bash
# Check alertmanager
kubectl get pods -n monitoring -l app=alertmanager

# Check alert rules
kubectl get prometheusrule -n monitoring

# Test alert query
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Open http://localhost:9090 and test query
```

## Examples

This directory contains example configurations:

- **prometheus-rules.yaml** - Prometheus alerting rules
- **grafana-dashboards/** - Grafana dashboard JSON files
- **alerts.yaml** - Alert configurations

## Next Steps

1. **Set up Prometheus** - Install and configure Prometheus
2. **Create Dashboards** - Build Grafana dashboards
3. **Configure Alerts** - Set up alerting rules
4. **Monitor Regularly** - Review metrics daily

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Crossplane Metrics](https://docs.crossplane.io/latest/reference/metrics/)

---

**Ready to troubleshoot?** Move to [Troubleshooting](../02-troubleshooting/)!
