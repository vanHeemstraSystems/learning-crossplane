# GitOps with Crossplane

GitOps is a methodology for managing infrastructure and applications using Git as the single source of truth. This guide covers using GitOps tools (ArgoCD and Flux) with Crossplane.

## Overview

GitOps with Crossplane provides:

- **Declarative Infrastructure**: All configurations in Git
- **Automated Sync**: Automatic deployment from Git
- **Version Control**: Complete history of changes
- **Audit Trail**: All changes tracked in Git
- **Rollback**: Easy rollback to previous versions

## GitOps Principles

### 1. Git as Source of Truth

All Crossplane resources stored in Git:
- XRDs
- Compositions
- Provider Configs
- XRs (optional, can be generated)

### 2. Declarative Configuration

YAML files define desired state:
- No imperative commands
- Version controlled
- Reviewable changes

### 3. Automated Deployment

GitOps tools sync Git to cluster:
- Automatic synchronization
- Drift detection
- Self-healing

### 4. Continuous Reconciliation

GitOps tools continuously monitor:
- Compare Git state with cluster state
- Sync when differences detected
- Maintain desired state

## Repository Structure

Recommended Git repository structure:

```
crossplane-configs/
├── xrds/
│   ├── database-xrd.yaml
│   └── network-xrd.yaml
├── compositions/
│   ├── database/
│   │   ├── postgres-composition.yaml
│   │   └── mysql-composition.yaml
│   └── network/
│       └── vpc-composition.yaml
├── provider-configs/
│   └── aws-providerconfig.yaml
├── apps/
│   └── production/
│       └── databases.yaml
└── README.md
```

## ArgoCD Integration

ArgoCD is a declarative GitOps tool for Kubernetes.

### Installing ArgoCD

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Basic ArgoCD Application

See [argocd/application.yaml](./argocd/application.yaml) for a complete example.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crossplane-configs
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/crossplane-configs
    targetRevision: main
    path: .
  destination:
    server: https://kubernetes.default.svc
    namespace: crossplane-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### App of Apps Pattern

Manage multiple applications. See [argocd/app-of-apps.yaml](./argocd/app-of-apps.yaml) for example.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crossplane-apps
spec:
  source:
    repoURL: https://github.com/org/crossplane-configs
    targetRevision: main
    path: argocd/apps
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
```

## Flux Integration

Flux is a GitOps tool for continuous delivery.

### Installing Flux

```bash
# Install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash

# Install Flux in cluster
flux install --namespace=flux-system

# Create GitRepository
flux create source git crossplane-configs \
  --url=https://github.com/org/crossplane-configs \
  --branch=main \
  --interval=1m
```

### Flux Kustomization

See [flux/kustomization.yaml](./flux/kustomization.yaml) for example.

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: crossplane-configs
  namespace: flux-system
spec:
  interval: 10m
  path: ./
  prune: true
  sourceRef:
    kind: GitRepository
    name: crossplane-configs
  validation: client
```

### Flux HelmRelease

For Helm-based deployments. See [flux/helmrelease.yaml](./flux/helmrelease.yaml) for example.

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: crossplane
  namespace: crossplane-system
spec:
  interval: 1h
  chart:
    spec:
      chart: crossplane
      sourceRef:
        kind: HelmRepository
        name: crossplane-stable
      version: ">=1.14.0"
  values:
    replicaCount: 2
```

## Best Practices

### 1. Repository Organization

Organize by:
- Resource type (XRDs, Compositions)
- Environment (staging, production)
- Application (app-specific configs)

### 2. Branch Strategy

- **main**: Production
- **staging**: Staging environment
- **feature branches**: New features

### 3. Synchronization

- **Automatic**: For non-critical changes
- **Manual**: For production deployments
- **Scheduled**: For regular syncs

### 4. Pruning

Enable pruning to remove deleted resources:
```yaml
syncPolicy:
  automated:
    prune: true
```

### 5. Self-Healing

Enable self-healing to correct drift:
```yaml
syncPolicy:
  automated:
    selfHeal: true
```

## Workflow Examples

### Workflow 1: Deploy New Composition

1. Create composition YAML
2. Commit to Git
3. ArgoCD/Flux detects change
4. Syncs to cluster
5. Composition available

### Workflow 2: Update Existing Resource

1. Edit YAML in Git
2. Commit changes
3. Create PR for review
4. Merge after approval
5. GitOps tool syncs update

### Workflow 3: Rollback

1. Identify commit to rollback to
2. GitOps tool syncs to that revision
3. Cluster state matches previous version

## Troubleshooting

### Sync Issues

```bash
# Check ArgoCD application status
argocd app get crossplane-configs

# Check Flux kustomization status
flux get kustomizations

# Check sync errors
kubectl describe application crossplane-configs -n argocd
```

### Drift Detection

GitOps tools detect drift between Git and cluster:
- Manual changes detected
- Automatic correction (if enabled)
- Alerts for drift

## Examples

This directory contains example configurations:

- **argocd/application.yaml** - Basic ArgoCD application
- **argocd/app-of-apps.yaml** - App of Apps pattern
- **flux/kustomization.yaml** - Flux kustomization
- **flux/helmrelease.yaml** - Flux Helm release

## Next Steps

1. **Choose Tool**: Select ArgoCD or Flux
2. **Set Up Repository**: Organize your Git repository
3. **Configure Sync**: Set up GitOps tool
4. **Deploy**: Start syncing resources
5. **Monitor**: Monitor sync status

## Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Flux Documentation](https://fluxcd.io/docs/)
- [GitOps Best Practices](https://www.gitops.tech/)

---

**Ready for CI/CD?** Move to [GitHub Actions](../02-github-actions/)!
