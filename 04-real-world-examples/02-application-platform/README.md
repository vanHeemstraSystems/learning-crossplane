# Application Platform

A complete platform for deploying applications with their required infrastructure, enabling developers to deploy full-stack applications with a single API call.

## Overview

This example demonstrates how to build an application platform that:

- Provisions application infrastructure (compute, networking, storage)
- Deploys application containers
- Manages application configuration
- Provides environment-specific deployments

## Architecture

```
Developer creates Application XR
    ↓
XRD validates input
    ↓
Composition creates:
  - Compute resources (EKS, AKS, GKE)
  - Networking (Load Balancer, Ingress)
  - Storage (Volumes, ConfigMaps)
  - Application deployment
    ↓
Application ready for use
```

## Components

### 1. XRD (Custom API)

Defines the Application API:
- Application configuration
- Resource requirements
- Environment settings
- Scaling configuration

See [xrd/app-xrd.yaml](./xrd/app-xrd.yaml)

### 2. Composition

Creates all resources needed for an application:
- Kubernetes deployment
- Service
- Ingress/Load Balancer
- ConfigMaps and Secrets
- Persistent volumes

See [composition/app-composition.yaml](./composition/app-composition.yaml)

### 3. Example Applications

Sample applications showing different use cases:
- Backend API
- Frontend web app

See [examples/](./examples/) directory

## Installation

### Step 1: Install XRD

```bash
kubectl apply -f xrd/app-xrd.yaml
```

Verify:

```bash
kubectl get xrd applications.app.example.org
```

### Step 2: Install Composition

```bash
kubectl apply -f composition/app-composition.yaml
```

Verify:

```bash
kubectl get composition app-platform
```

### Step 3: Deploy an Application

```bash
kubectl apply -f examples/backend-app.yaml
```

Monitor:

```bash
kubectl get application backend-api -w
kubectl describe application backend-api
```

## Usage Examples

### Backend API Application

```yaml
apiVersion: app.example.org/v1alpha1
kind: Application
metadata:
  name: backend-api
  namespace: production
spec:
  image: myregistry/backend-api:v1.0.0
  replicas: 3
  cpu: "500m"
  memory: "512Mi"
  environment: production
  ports:
    - port: 8080
      protocol: TCP
  env:
    - name: DATABASE_URL
      valueFrom:
        secretKeyRef:
          name: db-connection
          key: url
```

### Frontend Web Application

```yaml
apiVersion: app.example.org/v1alpha1
kind: Application
metadata:
  name: frontend-web
  namespace: production
spec:
  image: myregistry/frontend:v1.0.0
  replicas: 2
  cpu: "200m"
  memory: "256Mi"
  environment: production
  ports:
    - port: 80
      protocol: TCP
  ingress:
    enabled: true
    host: app.example.com
```

## Features

### Automatic Infrastructure

The platform automatically creates:
- Kubernetes Deployment
- Service for internal access
- Ingress for external access
- ConfigMaps for configuration
- Persistent volumes for storage

### Environment Management

Different configurations per environment:
- **Development**: Single replica, minimal resources
- **Staging**: Multiple replicas, medium resources
- **Production**: High availability, auto-scaling

### Resource Scaling

Automatic scaling based on:
- CPU utilization
- Memory usage
- Custom metrics

### Health Monitoring

Built-in health checks:
- Liveness probes
- Readiness probes
- Startup probes

## Customization

### Adding Custom Resources

Extend the composition to create additional resources:

```yaml
resources:
  - name: custom-resource
    base:
      apiVersion: custom.example.org/v1
      kind: CustomResource
```

### Environment-Specific Configurations

Use patches to configure based on environment:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.environment
    toFieldPath: spec.replicas
    transforms:
      - type: map
        map:
          development: 1
          staging: 2
          production: 3
```

## Best Practices Demonstrated

1. **Complete Stack**: Application + infrastructure in one API
2. **Environment Awareness**: Different configs per environment
3. **Resource Management**: Proper resource limits
4. **Health Checks**: Built-in monitoring
5. **Scaling**: Automatic scaling support

## Troubleshooting

### Application Not Deploying

```bash
# Check Application status
kubectl describe application my-app

# Check Deployment
kubectl get deployment -l app=my-app

# Check Pods
kubectl get pods -l app=my-app
```

### Resources Not Creating

```bash
# Check XR status
kubectl get application my-app -o yaml

# Check composition match
kubectl get composition app-platform
```

## Next Steps

1. **Customize**: Adapt to your application needs
2. **Add Features**: Add monitoring, logging, etc.
3. **Multi-Cloud**: Support multiple Kubernetes clusters
4. **Production**: Deploy in your production environment

## Additional Resources

- [Kubernetes Provider](https://marketplace.upbound.io/providers/upbound/provider-kubernetes/)
- [Application Patterns](https://docs.crossplane.io/latest/concepts/composition/)

---

**Ready for the next example?** Check out [Network Platform](../03-network-platform/)!
