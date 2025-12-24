# Observability Platform

A complete platform for deploying monitoring and logging infrastructure, enabling centralized observability for applications and infrastructure.

## Overview

This example demonstrates how to build an observability platform that:

- Deploys Prometheus for metrics collection
- Sets up Grafana for visualization
- Configures Loki for log aggregation
- Provides ready-to-use dashboards
- Enables application monitoring

## Architecture

```
Developer creates Monitoring XR
    ↓
XRD validates input
    ↓
Composition creates:
  - Prometheus deployment
  - Grafana deployment
  - Loki deployment
  - Service monitors
  - Dashboards
    ↓
Observability stack ready
```

## Components

### 1. XRD (Custom API)

Defines the Monitoring API:
- Monitoring configuration
- Retention settings
- Alerting rules
- Dashboard configuration

See [monitoring-xrd.yaml](./monitoring-xrd.yaml)

### 2. Compositions

Different compositions for different components:
- **Prometheus**: Metrics collection
- **Grafana**: Visualization
- **Loki**: Log aggregation

See composition files in this directory.

## Installation

### Step 1: Install XRD

```bash
kubectl apply -f monitoring-xrd.yaml
```

### Step 2: Install Compositions

```bash
kubectl apply -f prometheus-composition.yaml
kubectl apply -f grafana-composition.yaml
kubectl apply -f loki-composition.yaml
```

### Step 3: Create Monitoring Stack

```yaml
apiVersion: monitoring.example.org/v1alpha1
kind: Monitoring
metadata:
  name: production-monitoring
  namespace: production
spec:
  prometheus:
    enabled: true
    retention: 30d
  grafana:
    enabled: true
  loki:
    enabled: true
```

## Features

### Prometheus Integration

- Automatic service discovery
- Custom metrics collection
- Alert rule management
- Long-term storage support

### Grafana Dashboards

- Pre-configured dashboards
- Custom dashboard support
- Data source configuration
- User management

### Loki Logging

- Log aggregation
- Log querying
- Log retention
- Multi-tenant support

## Usage Examples

### Full Observability Stack

```yaml
apiVersion: monitoring.example.org/v1alpha1
kind: Monitoring
metadata:
  name: full-stack
  namespace: production
spec:
  prometheus:
    enabled: true
    retention: 90d
    storage: 100Gi
  grafana:
    enabled: true
    dashboards:
      - name: kubernetes
      - name: applications
  loki:
    enabled: true
    retention: 30d
```

## Best Practices Demonstrated

1. **Centralized Monitoring**: Single source of truth
2. **Resource Management**: Proper resource limits
3. **Retention Policies**: Configurable retention
4. **Integration**: Easy integration with applications

## Troubleshooting

### Prometheus Not Scraping

```bash
# Check Prometheus status
kubectl get pods -l app=prometheus

# Check service monitors
kubectl get servicemonitor
```

### Grafana Not Accessible

```bash
# Check Grafana service
kubectl get svc grafana

# Check ingress
kubectl get ingress grafana
```

## Next Steps

1. **Customize**: Adapt to your monitoring needs
2. **Add Dashboards**: Create custom dashboards
3. **Alerting**: Configure alerting rules
4. **Production**: Deploy in your production environment

---

**Ready for multi-cloud?** Check out [Multi-Cloud Platform](../05-multi-cloud/)!
