# GitLab CI/CD for Crossplane

GitLab CI/CD provides powerful pipeline capabilities for Crossplane deployments. This guide covers setting up GitLab CI pipelines for validating, testing, and deploying Crossplane resources.

## Overview

GitLab CI/CD for Crossplane enables:

- **Automated Pipelines**: Run on every push and merge
- **Validation**: Check YAML syntax and schemas
- **Testing**: Run automated tests
- **Deployment**: Deploy to multiple environments
- **Integration**: Seamless GitLab integration

## Pipeline Configuration

GitLab CI uses `.gitlab-ci.yml` in the repository root. See [.gitlab-ci.yml](./.gitlab-ci.yaml) for complete example.

### Basic Structure

```yaml
stages:
  - validate
  - test
  - deploy

validate:
  stage: validate
  script:
    - kubectl apply --dry-run=client -f .
```

## Pipeline Stages

### Stage 1: Validate

Validate YAML syntax and Crossplane resources:
- YAML syntax validation
- XRD validation
- Composition validation
- Schema compliance

### Stage 2: Test

Run automated tests:
- Unit tests
- Integration tests
- Function tests
- Policy tests

### Stage 3: Deploy

Deploy to environments:
- Deploy to staging
- Deploy to production (manual)
- Verify deployment

## Best Practices

### 1. Use Stages

Organize jobs into stages:
```yaml
stages:
  - validate
  - test
  - build
  - deploy
```

### 2. Use Artifacts

Pass artifacts between stages:
```yaml
artifacts:
  paths:
    - build/
  expire_in: 1 week
```

### 3. Cache Dependencies

Cache kubectl and tools:
```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .kubectl/
```

### 4. Use Variables

Store configuration in GitLab CI/CD variables:
```yaml
variables:
  KUBECTL_VERSION: "latest"
```

### 5. Conditional Execution

Run jobs conditionally:
```yaml
rules:
  - if: $CI_COMMIT_BRANCH == "main"
```

## Environment Configuration

### Staging Environment

```yaml
deploy:staging:
  stage: deploy
  environment:
    name: staging
    url: https://staging.example.com
```

### Production Environment

```yaml
deploy:production:
  stage: deploy
  environment:
    name: production
    url: https://production.example.com
  when: manual
```

## Examples

This directory contains example configurations:

- **.gitlab-ci.yaml** - Complete pipeline example

## Additional Resources

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [.gitlab-ci.yml Reference](https://docs.gitlab.com/ee/ci/yaml/)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)

---

**Ready to test?** Move to [Testing](../04-testing/)!
