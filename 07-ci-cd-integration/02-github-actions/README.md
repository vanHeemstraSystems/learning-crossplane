# GitHub Actions for Crossplane

GitHub Actions provides CI/CD capabilities directly in GitHub. This guide covers creating workflows for validating, testing, and deploying Crossplane resources.

## Overview

GitHub Actions workflows for Crossplane can:

- **Validate**: Check YAML syntax and schema
- **Test**: Run automated tests
- **Deploy**: Automate deployments
- **Notify**: Send notifications on events

## Workflow Structure

GitHub Actions workflows use YAML files in `.github/workflows/`:

```yaml
name: Workflow Name
on:
  push:
    branches: [main]
jobs:
  job-name:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Step Name
        run: command
```

## Common Workflows

### 1. Validation Workflow

Validates YAML syntax and Crossplane resources. See [validate-composition.yaml](./validate-composition.yaml) for example.

**Triggers:**
- Pull requests
- Pushes to branches

**Actions:**
- Validate YAML syntax
- Check schema compliance
- Run policy checks

### 2. Testing Workflow

Runs automated tests. See [test-functions.yaml](./test-functions.yaml) for example.

**Triggers:**
- Pull requests
- Pushes to main

**Actions:**
- Run unit tests
- Run integration tests
- Generate test reports

### 3. Deployment Workflow

Deploys Crossplane resources. See [deploy-crossplane.yaml](./deploy-crossplane.yaml) for example.

**Triggers:**
- Pushes to main
- Manual triggers
- Tags

**Actions:**
- Deploy to staging
- Deploy to production
- Verify deployment

## Best Practices

### 1. Validate Before Merge

Run validation on all pull requests:
```yaml
on:
  pull_request:
    branches: [main]
```

### 2. Use Matrix Testing

Test against multiple Kubernetes versions:
```yaml
strategy:
  matrix:
    k8s-version: [1.27, 1.28, 1.29]
```

### 3. Cache Dependencies

Cache kubectl and other tools:
```yaml
- uses: actions/cache@v3
  with:
    path: ~/.kubectl
    key: kubectl-${{ runner.os }}
```

### 4. Secure Secrets

Use GitHub Secrets for sensitive data:
```yaml
env:
  KUBECONFIG: ${{ secrets.KUBECONFIG }}
```

### 5. Conditional Steps

Run steps conditionally:
```yaml
if: github.ref == 'refs/heads/main'
```

## Examples

This directory contains example workflows:

- **validate-composition.yaml** - Validation workflow
- **test-functions.yaml** - Testing workflow
- **deploy-crossplane.yaml** - Deployment workflow

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)

---

**Ready for GitLab?** Move to [GitLab CI](../03-gitlab-ci/)!
