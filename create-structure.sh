#!/bin/bash

# Create complete directory structure for learning-crossplane

BASE_DIR="."

# Function to create directory and placeholder README
create_dir_with_readme() {
    local dir=$1
    local title=$2
    mkdir -p "$dir"
    cat > "$dir/README.md" << EOF
# $title

> This section is under development. Content coming soon.

## Overview

Documentation and examples for this topic will be added here.

## Contents

Check back soon for updates!
EOF
}

# Function to create empty placeholder file
create_placeholder() {
    local file=$1
    local comment=$2
    mkdir -p "$(dirname "$file")"
    echo "# $comment" > "$file"
    echo "# Placeholder file - to be populated with actual content" >> "$file"
}

echo "Creating learning-crossplane directory structure..."

# Root level files
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Willem van Heemstra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

cat > .gitignore << 'EOF'
# OS Files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
*~

# IDE & Editor Files
.vscode/
.idea/
*.swp
*.swo
*.swn
.project
.settings/
*.sublime-*

# Kubernetes
kubeconfig
*.kubeconfig
.kube/

# Crossplane
.crossplane/
*.xpkg
.up/
upbound.yaml

# Terraform (if used alongside)
*.tfstate
*.tfstate.*
.terraform/
*.tfvars
override.tf
override.tf.json

# Secrets & Credentials
*.key
*.pem
*.crt
*.p12
*.pfx
secrets/
credentials/
.env
.env.*

# Temporary Files
tmp/
temp/
*.tmp
*.log
*.bak

# Build & Package Files
dist/
build/
*.tar
*.tar.gz
*.zip
bin/
pkg/

# Testing
coverage/
*.test
test-results/

# Docker
.dockerignore

# Go
go.sum
vendor/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
*.egg-info/
.pytest_cache/

# Node
node_modules/
npm-debug.log
yarn-error.log
package-lock.json
yarn.lock

# Output directories
outputs/
rendered/
EOF

# 01-fundamentals
echo "Creating 01-fundamentals structure..."
create_dir_with_readme "01-fundamentals" "Crossplane Fundamentals"

mkdir -p "01-fundamentals/01-installation"
create_placeholder "01-fundamentals/01-installation/helm-install.yaml" "Helm installation configuration for Crossplane"
create_placeholder "01-fundamentals/01-installation/helm-values.yaml" "Custom Helm values for Crossplane installation"
cat > "01-fundamentals/01-installation/verify-installation.sh" << 'EOF'
#!/bin/bash
# Verify Crossplane installation

echo "Checking Crossplane pods..."
kubectl get pods -n crossplane-system

echo -e "\nChecking Crossplane CRDs..."
kubectl get crds | grep crossplane

echo -e "\nCrossplane version:"
kubectl get deployment crossplane -n crossplane-system -o jsonpath='{.spec.template.spec.containers[0].image}'

echo -e "\n\nInstallation verification complete!"
EOF
chmod +x "01-fundamentals/01-installation/verify-installation.sh"

mkdir -p "01-fundamentals/02-providers"
create_placeholder "01-fundamentals/02-providers/provider-aws.yaml" "AWS Provider configuration"
create_placeholder "01-fundamentals/02-providers/provider-azure.yaml" "Azure Provider configuration"
create_placeholder "01-fundamentals/02-providers/provider-gcp.yaml" "GCP Provider configuration"
create_placeholder "01-fundamentals/02-providers/provider-kubernetes.yaml" "Kubernetes Provider configuration"
create_placeholder "01-fundamentals/02-providers/provider-config.yaml" "Provider configuration examples"

mkdir -p "01-fundamentals/03-managed-resources"
create_dir_with_readme "01-fundamentals/03-managed-resources" "Managed Resources"
create_placeholder "01-fundamentals/03-managed-resources/s3-bucket.yaml" "S3 Bucket managed resource example"
create_placeholder "01-fundamentals/03-managed-resources/rds-instance.yaml" "RDS Instance managed resource example"
create_placeholder "01-fundamentals/03-managed-resources/vpc.yaml" "VPC managed resource example"

mkdir -p "01-fundamentals/04-basic-concepts"
create_placeholder "01-fundamentals/04-basic-concepts/crds.yaml" "Custom Resource Definitions examples"
create_placeholder "01-fundamentals/04-basic-concepts/custom-resources.yaml" "Custom Resources examples"
cat > "01-fundamentals/04-basic-concepts/resource-lifecycle.md" << 'EOF'
# Resource Lifecycle

## Overview
Understanding how Crossplane manages resource lifecycle.

## Topics
- Resource creation
- Updates and patches
- Deletion and cleanup
- Finalizers
- Status conditions

## Coming Soon
Detailed documentation on resource lifecycle management.
EOF

# 02-compositions
echo "Creating 02-compositions structure..."
create_dir_with_readme "02-compositions" "Compositions"

mkdir -p "02-compositions/01-xrd-basics"
create_placeholder "02-compositions/01-xrd-basics/simple-xrd.yaml" "Simple XRD example"
create_placeholder "02-compositions/01-xrd-basics/namespaced-xrd.yaml" "Namespaced XRD (v2)"
create_placeholder "02-compositions/01-xrd-basics/cluster-scoped-xrd.yaml" "Cluster-scoped XRD"
create_placeholder "02-compositions/01-xrd-basics/schema-definition.yaml" "XRD schema definition example"

mkdir -p "02-compositions/02-basic-compositions"
create_placeholder "02-compositions/02-basic-compositions/patch-and-transform.yaml" "Basic patch and transform composition"
create_placeholder "02-compositions/02-basic-compositions/resource-templates.yaml" "Resource templates example"
create_placeholder "02-compositions/02-basic-compositions/composition-metadata.yaml" "Composition metadata example"

mkdir -p "02-compositions/03-composite-resources"
create_dir_with_readme "02-compositions/03-composite-resources" "Composite Resources"
create_placeholder "02-compositions/03-composite-resources/namespaced-xr.yaml" "Namespaced composite resource"
create_placeholder "02-compositions/03-composite-resources/cluster-xr.yaml" "Cluster-scoped composite resource"
create_placeholder "02-compositions/03-composite-resources/xr-status.yaml" "XR with status fields"

mkdir -p "02-compositions/04-v2-migration"
create_placeholder "02-compositions/04-v2-migration/legacy-composition.yaml" "Legacy v1 composition"
create_placeholder "02-compositions/04-v2-migration/v2-composition.yaml" "Migrated v2 composition"
cat > "02-compositions/04-v2-migration/migration-guide.md" << 'EOF'
# v1 to v2 Migration Guide

## Overview
Guide for migrating from Crossplane v1 to v2.

## Key Changes
- Namespaced XRs by default
- No more Claims abstraction
- Improved application support

## Migration Steps
Coming soon!
EOF

# 03-composition-functions
echo "Creating 03-composition-functions structure..."
create_dir_with_readme "03-composition-functions" "Composition Functions"

mkdir -p "03-composition-functions/01-patch-and-transform"
create_placeholder "03-composition-functions/01-patch-and-transform/function-install.yaml" "P&T function installation"
create_placeholder "03-composition-functions/01-patch-and-transform/simple-transform.yaml" "Simple transform example"
create_placeholder "03-composition-functions/01-patch-and-transform/conditional-patching.yaml" "Conditional patching example"
mkdir -p "03-composition-functions/01-patch-and-transform/examples"
create_placeholder "03-composition-functions/01-patch-and-transform/examples/example-1.yaml" "P&T example 1"

mkdir -p "03-composition-functions/02-function-pipeline"
create_placeholder "03-composition-functions/02-function-pipeline/pipeline-composition.yaml" "Pipeline composition example"
create_placeholder "03-composition-functions/02-function-pipeline/multi-function.yaml" "Multi-function pipeline"
create_placeholder "03-composition-functions/02-function-pipeline/function-chaining.yaml" "Function chaining example"

mkdir -p "03-composition-functions/03-templating-functions/go-templating"
create_placeholder "03-composition-functions/03-templating-functions/go-templating/function-config.yaml" "Go templating function config"
create_placeholder "03-composition-functions/03-templating-functions/go-templating/template-examples.yaml" "Go template examples"

mkdir -p "03-composition-functions/03-templating-functions/kcl-function"
create_placeholder "03-composition-functions/03-templating-functions/kcl-function/function-install.yaml" "KCL function installation"
mkdir -p "03-composition-functions/03-templating-functions/kcl-function/kcl-examples"
create_placeholder "03-composition-functions/03-templating-functions/kcl-function/kcl-examples/basic.k" "Basic KCL example"

mkdir -p "03-composition-functions/03-templating-functions/helm-function"
create_placeholder "03-composition-functions/03-templating-functions/helm-function/helm-composition.yaml" "Helm-based composition"

mkdir -p "03-composition-functions/04-custom-functions/python-function"
create_placeholder "03-composition-functions/04-custom-functions/python-function/function.py" "Python function implementation"
create_placeholder "03-composition-functions/04-custom-functions/python-function/Dockerfile" "Python function Dockerfile"
create_placeholder "03-composition-functions/04-custom-functions/python-function/requirements.txt" "Python dependencies"
create_dir_with_readme "03-composition-functions/04-custom-functions/python-function" "Python Composition Function"

mkdir -p "03-composition-functions/04-custom-functions/go-function"
create_placeholder "03-composition-functions/04-custom-functions/go-function/main.go" "Go function implementation"
create_placeholder "03-composition-functions/04-custom-functions/go-function/go.mod" "Go module definition"
create_placeholder "03-composition-functions/04-custom-functions/go-function/Dockerfile" "Go function Dockerfile"
create_dir_with_readme "03-composition-functions/04-custom-functions/go-function" "Go Composition Function"

mkdir -p "03-composition-functions/04-custom-functions/function-testing"
create_placeholder "03-composition-functions/04-custom-functions/function-testing/test-inputs.yaml" "Function test inputs"
cat > "03-composition-functions/04-custom-functions/function-testing/render-tests.sh" << 'EOF'
#!/bin/bash
# Test composition functions using crossplane render

echo "Testing composition functions..."
crossplane render xr.yaml composition.yaml functions.yaml
EOF
chmod +x "03-composition-functions/04-custom-functions/function-testing/render-tests.sh"

mkdir -p "03-composition-functions/05-advanced-patterns"
create_placeholder "03-composition-functions/05-advanced-patterns/conditional-logic.yaml" "Conditional logic in functions"
create_placeholder "03-composition-functions/05-advanced-patterns/loops-iteration.yaml" "Loops and iteration examples"
create_placeholder "03-composition-functions/05-advanced-patterns/external-data.yaml" "External data integration"
create_placeholder "03-composition-functions/05-advanced-patterns/error-handling.yaml" "Error handling patterns"

# 04-real-world-examples
echo "Creating 04-real-world-examples structure..."
create_dir_with_readme "04-real-world-examples" "Real-World Examples"

mkdir -p "04-real-world-examples/01-database-platform/xrd"
mkdir -p "04-real-world-examples/01-database-platform/compositions"
mkdir -p "04-real-world-examples/01-database-platform/claims"
create_placeholder "04-real-world-examples/01-database-platform/xrd/database-xrd.yaml" "Database XRD"
create_placeholder "04-real-world-examples/01-database-platform/compositions/postgres-composition.yaml" "PostgreSQL composition"
create_placeholder "04-real-world-examples/01-database-platform/compositions/mysql-composition.yaml" "MySQL composition"
create_placeholder "04-real-world-examples/01-database-platform/compositions/mongodb-composition.yaml" "MongoDB composition"
create_placeholder "04-real-world-examples/01-database-platform/claims/sample-database.yaml" "Sample database claim"
create_dir_with_readme "04-real-world-examples/01-database-platform" "Database Platform"

mkdir -p "04-real-world-examples/02-application-platform/xrd"
mkdir -p "04-real-world-examples/02-application-platform/composition"
mkdir -p "04-real-world-examples/02-application-platform/examples"
create_placeholder "04-real-world-examples/02-application-platform/xrd/app-xrd.yaml" "Application XRD"
create_placeholder "04-real-world-examples/02-application-platform/composition/app-composition.yaml" "Application composition"
create_placeholder "04-real-world-examples/02-application-platform/examples/frontend-app.yaml" "Frontend app example"
create_placeholder "04-real-world-examples/02-application-platform/examples/backend-app.yaml" "Backend app example"
create_dir_with_readme "04-real-world-examples/02-application-platform" "Application Platform"

mkdir -p "04-real-world-examples/03-network-platform"
create_placeholder "04-real-world-examples/03-network-platform/vpc-xrd.yaml" "VPC XRD"
create_placeholder "04-real-world-examples/03-network-platform/vpc-composition.yaml" "VPC composition"
create_placeholder "04-real-world-examples/03-network-platform/subnet-composition.yaml" "Subnet composition"
create_placeholder "04-real-world-examples/03-network-platform/security-group-composition.yaml" "Security group composition"

mkdir -p "04-real-world-examples/04-observability-platform"
create_placeholder "04-real-world-examples/04-observability-platform/monitoring-xrd.yaml" "Monitoring XRD"
create_placeholder "04-real-world-examples/04-observability-platform/prometheus-composition.yaml" "Prometheus composition"
create_placeholder "04-real-world-examples/04-observability-platform/grafana-composition.yaml" "Grafana composition"
create_placeholder "04-real-world-examples/04-observability-platform/loki-composition.yaml" "Loki composition"

mkdir -p "04-real-world-examples/05-multi-cloud"
create_placeholder "04-real-world-examples/05-multi-cloud/provider-selection.yaml" "Provider selection logic"
create_placeholder "04-real-world-examples/05-multi-cloud/aws-composition.yaml" "AWS-specific composition"
create_placeholder "04-real-world-examples/05-multi-cloud/azure-composition.yaml" "Azure-specific composition"
create_placeholder "04-real-world-examples/05-multi-cloud/gcp-composition.yaml" "GCP-specific composition"

# 05-security
echo "Creating 05-security structure..."
create_dir_with_readme "05-security" "Security"

mkdir -p "05-security/01-rbac"
create_placeholder "05-security/01-rbac/roles.yaml" "RBAC roles"
create_placeholder "05-security/01-rbac/rolebindings.yaml" "Role bindings"
create_placeholder "05-security/01-rbac/service-accounts.yaml" "Service accounts"

mkdir -p "05-security/02-secrets-management"
create_placeholder "05-security/02-secrets-management/external-secrets.yaml" "External Secrets integration"
create_placeholder "05-security/02-secrets-management/sealed-secrets.yaml" "Sealed Secrets integration"
create_placeholder "05-security/02-secrets-management/vault-integration.yaml" "HashiCorp Vault integration"

mkdir -p "05-security/03-policy-enforcement/opa-policies"
mkdir -p "05-security/03-policy-enforcement/kyverno-policies"
create_placeholder "05-security/03-policy-enforcement/opa-policies/policy-1.rego" "OPA policy example"
create_placeholder "05-security/03-policy-enforcement/kyverno-policies/policy-1.yaml" "Kyverno policy example"
create_placeholder "05-security/03-policy-enforcement/admission-control.yaml" "Admission control configuration"

mkdir -p "05-security/04-compliance"
create_placeholder "05-security/04-compliance/audit-logging.yaml" "Audit logging configuration"
create_placeholder "05-security/04-compliance/compliance-checks.yaml" "Compliance check policies"

# 06-operations
echo "Creating 06-operations structure..."
create_dir_with_readme "06-operations" "Operations"

mkdir -p "06-operations/01-monitoring"
mkdir -p "06-operations/01-monitoring/grafana-dashboards"
create_placeholder "06-operations/01-monitoring/prometheus-rules.yaml" "Prometheus recording rules"
create_placeholder "06-operations/01-monitoring/alerts.yaml" "Alert rules"
create_placeholder "06-operations/01-monitoring/grafana-dashboards/dashboard-1.json" "Grafana dashboard"

mkdir -p "06-operations/02-troubleshooting"
cat > "06-operations/02-troubleshooting/debug-commands.sh" << 'EOF'
#!/bin/bash
# Common Crossplane debugging commands

echo "=== Crossplane Pods ==="
kubectl get pods -n crossplane-system

echo -e "\n=== Composition Functions ==="
kubectl get functions

echo -e "\n=== Providers ==="
kubectl get providers

echo -e "\n=== XRDs ==="
kubectl get xrd

echo -e "\n=== Compositions ==="
kubectl get compositions
EOF
chmod +x "06-operations/02-troubleshooting/debug-commands.sh"

cat > "06-operations/02-troubleshooting/common-issues.md" << 'EOF'
# Common Issues and Solutions

## Overview
Common problems and their solutions when working with Crossplane.

## Coming Soon
- Provider installation issues
- Composition debugging
- Resource reconciliation problems
- Performance issues
EOF

cat > "06-operations/02-troubleshooting/logs-analysis.md" << 'EOF'
# Logs Analysis

## Overview
How to analyze Crossplane logs for troubleshooting.

## Coming Soon
Detailed guide on log analysis techniques.
EOF

mkdir -p "06-operations/03-backup-restore"
cat > "06-operations/03-backup-restore/backup-strategy.md" << 'EOF'
# Backup Strategy

## Overview
Strategies for backing up Crossplane state and configurations.

## Coming Soon
Detailed backup and restore procedures.
EOF

cat > "06-operations/03-backup-restore/restore-procedures.md" << 'EOF'
# Restore Procedures

## Overview
Step-by-step restore procedures.

## Coming Soon
Detailed restore documentation.
EOF

mkdir -p "06-operations/04-upgrades"
cat > "06-operations/04-upgrades/upgrade-checklist.md" << 'EOF'
# Upgrade Checklist

## Pre-Upgrade
- [ ] Review release notes
- [ ] Backup current state
- [ ] Test in non-production

## During Upgrade
- [ ] Monitor pod status
- [ ] Check logs

## Post-Upgrade
- [ ] Verify functionality
- [ ] Update documentation
EOF

cat > "06-operations/04-upgrades/rollback-plan.md" << 'EOF'
# Rollback Plan

## Overview
Procedures for rolling back Crossplane upgrades.

## Coming Soon
Detailed rollback procedures.
EOF

create_placeholder "06-operations/04-upgrades/version-migration.yaml" "Version migration configurations"

mkdir -p "06-operations/05-performance"
create_placeholder "06-operations/05-performance/scaling-config.yaml" "Scaling configuration"
cat > "06-operations/05-performance/optimization-guide.md" << 'EOF'
# Performance Optimization Guide

## Overview
Best practices for optimizing Crossplane performance.

## Coming Soon
Detailed optimization techniques.
EOF

# 07-ci-cd-integration
echo "Creating 07-ci-cd-integration structure..."
create_dir_with_readme "07-ci-cd-integration" "CI/CD Integration"

mkdir -p "07-ci-cd-integration/01-gitops/argocd"
mkdir -p "07-ci-cd-integration/01-gitops/flux"
create_placeholder "07-ci-cd-integration/01-gitops/argocd/application.yaml" "ArgoCD Application"
create_placeholder "07-ci-cd-integration/01-gitops/argocd/app-of-apps.yaml" "ArgoCD App of Apps"
create_placeholder "07-ci-cd-integration/01-gitops/flux/kustomization.yaml" "Flux Kustomization"
create_placeholder "07-ci-cd-integration/01-gitops/flux/helmrelease.yaml" "Flux HelmRelease"

mkdir -p "07-ci-cd-integration/02-github-actions"
create_placeholder "07-ci-cd-integration/02-github-actions/validate-composition.yaml" "GitHub Action: Validate Composition"
create_placeholder "07-ci-cd-integration/02-github-actions/test-functions.yaml" "GitHub Action: Test Functions"
create_placeholder "07-ci-cd-integration/02-github-actions/deploy-crossplane.yaml" "GitHub Action: Deploy Crossplane"

mkdir -p "07-ci-cd-integration/03-gitlab-ci"
create_placeholder "07-ci-cd-integration/03-gitlab-ci/.gitlab-ci.yaml" "GitLab CI Pipeline"

mkdir -p "07-ci-cd-integration/04-testing/composition-tests"
mkdir -p "07-ci-cd-integration/04-testing/function-tests"
mkdir -p "07-ci-cd-integration/04-testing/integration-tests"
create_placeholder "07-ci-cd-integration/04-testing/composition-tests/test-1.yaml" "Composition test"
create_placeholder "07-ci-cd-integration/04-testing/function-tests/test-1.yaml" "Function test"
create_placeholder "07-ci-cd-integration/04-testing/integration-tests/test-1.yaml" "Integration test"

# 08-advanced-topics
echo "Creating 08-advanced-topics structure..."
create_dir_with_readme "08-advanced-topics" "Advanced Topics"

mkdir -p "08-advanced-topics/01-custom-providers/provider-template"
mkdir -p "08-advanced-topics/01-custom-providers/upjet-provider"
create_placeholder "08-advanced-topics/01-custom-providers/provider-template/provider.go" "Custom provider template"
create_placeholder "08-advanced-topics/01-custom-providers/upjet-provider/config.go" "Upjet provider config"

mkdir -p "08-advanced-topics/02-function-development/sdk-usage"
mkdir -p "08-advanced-topics/02-function-development/grpc-implementation"
mkdir -p "08-advanced-topics/02-function-development/optimization-patterns"
create_placeholder "08-advanced-topics/02-function-development/sdk-usage/example.go" "SDK usage example"
create_placeholder "08-advanced-topics/02-function-development/grpc-implementation/server.go" "gRPC server implementation"
create_placeholder "08-advanced-topics/02-function-development/optimization-patterns/pattern-1.md" "Optimization pattern"

mkdir -p "08-advanced-topics/03-webhooks"
create_placeholder "08-advanced-topics/03-webhooks/admission-webhook.yaml" "Admission webhook config"
create_placeholder "08-advanced-topics/03-webhooks/validation-logic.go" "Validation logic"

mkdir -p "08-advanced-topics/04-event-driven"
mkdir -p "08-advanced-topics/04-event-driven/event-handlers"
create_placeholder "08-advanced-topics/04-event-driven/triggers.yaml" "Event triggers"
create_placeholder "08-advanced-topics/04-event-driven/event-handlers/handler-1.go" "Event handler"

# 09-reference
echo "Creating 09-reference structure..."
create_dir_with_readme "09-reference" "Reference"

mkdir -p "09-reference/01-api-reference"
cat > "09-reference/01-api-reference/xrd-api.md" << 'EOF'
# XRD API Reference

## Overview
Complete API reference for Composite Resource Definitions.

## Coming Soon
Detailed API documentation.
EOF

cat > "09-reference/01-api-reference/composition-api.md" << 'EOF'
# Composition API Reference

## Overview
Complete API reference for Compositions.

## Coming Soon
Detailed API documentation.
EOF

cat > "09-reference/01-api-reference/function-api.md" << 'EOF'
# Function API Reference

## Overview
Complete API reference for Composition Functions.

## Coming Soon
Detailed API documentation.
EOF

mkdir -p "09-reference/02-cli-reference"
cat > "09-reference/02-cli-reference/crossplane-cli.md" << 'EOF'
# Crossplane CLI Reference

## Overview
Complete CLI command reference.

## Coming Soon
Detailed CLI documentation.
EOF

cat > "09-reference/02-cli-reference/kubectl-crossplane.md" << 'EOF'
# kubectl crossplane Plugin

## Overview
kubectl crossplane plugin reference.

## Coming Soon
Detailed plugin documentation.
EOF

mkdir -p "09-reference/03-glossary"
cat > "09-reference/03-glossary/glossary.md" << 'EOF'
# Crossplane Glossary

## Terms

### XRD (Composite Resource Definition)
Defines the schema for composite resources.

### XR (Composite Resource)
An instance of a composite resource.

### Composition
Template defining what resources to create.

### Function
Extension for composition logic.

### Provider
Extends Crossplane with cloud platform support.

### Managed Resource (MR)
Infrastructure resource managed by Crossplane.

## Coming Soon
Comprehensive glossary of terms.
EOF

mkdir -p "09-reference/04-cheat-sheets"
cat > "09-reference/04-cheat-sheets/commands.md" << 'EOF'
# Command Cheat Sheet

## Installation
```bash
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
```

## Common Commands
```bash
# List XRDs
kubectl get xrd

# List Compositions
kubectl get compositions

# List Providers
kubectl get providers

# Check composition
crossplane render xr.yaml composition.yaml functions.yaml
```

## Coming Soon
Complete command reference.
EOF

cat > "09-reference/04-cheat-sheets/patterns.md" << 'EOF'
# Common Patterns Cheat Sheet

## Coming Soon
Common composition patterns and snippets.
EOF

cat > "09-reference/04-cheat-sheets/troubleshooting.md" << 'EOF'
# Troubleshooting Cheat Sheet

## Coming Soon
Quick troubleshooting reference.
EOF

# 10-labs
echo "Creating 10-labs structure..."
create_dir_with_readme "10-labs" "Hands-On Labs"

for lab in "lab-01-installation" "lab-02-first-composition" "lab-03-functions" "lab-04-database-platform" "lab-05-production"; do
    mkdir -p "10-labs/$lab/lab-files"
    mkdir -p "10-labs/$lab/solutions"
    
    cat > "10-labs/$lab/instructions.md" << EOF
# $lab

## Objectives
Learn key Crossplane concepts through hands-on practice.

## Prerequisites
- Kubernetes cluster
- kubectl installed
- Crossplane CLI installed

## Instructions
Coming soon!

## Verification
Steps to verify completion.

## Solutions
See solutions/ directory for reference implementations.
EOF

    create_placeholder "10-labs/$lab/lab-files/placeholder.yaml" "Lab files placeholder"
    create_placeholder "10-labs/$lab/solutions/solution.yaml" "Lab solution"
done

# 11-case-studies
echo "Creating 11-case-studies structure..."
create_dir_with_readme "11-case-studies" "Case Studies"

for study in "platform-team-adoption" "multi-tenant-saas" "hybrid-cloud" "edge-computing"; do
    mkdir -p "11-case-studies/$study"
    cat > "11-case-studies/$study/README.md" << EOF
# ${study//-/ }

## Overview
Real-world case study.

## Challenge
The problem that needed solving.

## Solution
How Crossplane was implemented.

## Results
Outcomes and benefits.

## Coming Soon
Detailed case study documentation.
EOF
done

# scripts
echo "Creating scripts..."
mkdir -p scripts

cat > scripts/install-crossplane.sh << 'EOF'
#!/bin/bash
# Install Crossplane using Helm

set -e

NAMESPACE=${1:-crossplane-system}

echo "Installing Crossplane to namespace: $NAMESPACE"

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane \
  --namespace $NAMESPACE \
  --create-namespace \
  crossplane-stable/crossplane

echo "Waiting for Crossplane to be ready..."
kubectl wait --for=condition=ready pod -l app=crossplane -n $NAMESPACE --timeout=300s

echo "Crossplane installed successfully!"
EOF
chmod +x scripts/install-crossplane.sh

cat > scripts/setup-providers.sh << 'EOF'
#!/bin/bash
# Setup common Crossplane providers

set -e

echo "Installing common providers..."
# Add provider installation logic here

echo "Providers setup complete!"
EOF
chmod +x scripts/setup-providers.sh

cat > scripts/validate-compositions.sh << 'EOF'
#!/bin/bash
# Validate all composition files

set -e

echo "Validating compositions..."

find . -name "*composition*.yaml" -type f | while read file; do
    echo "Validating: $file"
    kubectl apply --dry-run=client -f "$file" || echo "Failed: $file"
done

echo "Validation complete!"
EOF
chmod +x scripts/validate-compositions.sh

cat > scripts/cleanup.sh << 'EOF'
#!/bin/bash
# Cleanup Crossplane installation

set -e

echo "This will remove Crossplane and all related resources!"
read -p "Are you sure? (yes/no) " -n 3 -r
echo

if [[ $REPLY =~ ^yes$ ]]; then
    helm uninstall crossplane -n crossplane-system
    kubectl delete namespace crossplane-system
    echo "Cleanup complete!"
else
    echo "Cleanup cancelled."
fi
EOF
chmod +x scripts/cleanup.sh

cat > scripts/test-functions.sh << 'EOF'
#!/bin/bash
# Test composition functions using crossplane render

set -e

if [ $# -lt 3 ]; then
    echo "Usage: $0 <xr.yaml> <composition.yaml> <functions.yaml>"
    exit 1
fi

XR=$1
COMPOSITION=$2
FUNCTIONS=$3

echo "Testing composition function..."
crossplane render "$XR" "$COMPOSITION" "$FUNCTIONS"

echo "Test complete!"
EOF
chmod +x scripts/test-functions.sh

# docs
echo "Creating docs structure..."
mkdir -p docs/architecture
mkdir -p docs/tutorials
mkdir -p docs/videos

cat > docs/architecture/control-plane-design.md << 'EOF'
# Control Plane Design

## Overview
Architectural patterns for designing Crossplane control planes.

## Coming Soon
Detailed architecture documentation.
EOF

cat > docs/architecture/composition-patterns.md << 'EOF'
# Composition Patterns

## Overview
Common patterns for building compositions.

## Coming Soon
Pattern library and examples.
EOF

cat > docs/tutorials/getting-started.md << 'EOF'
# Getting Started with Crossplane

## Overview
Step-by-step getting started guide.

## Coming Soon
Complete beginner tutorial.
EOF

cat > docs/tutorials/building-platforms.md << 'EOF'
# Building Platforms with Crossplane

## Overview
How to build self-service platforms.

## Coming Soon
Platform building tutorial.
EOF

cat > docs/tutorials/advanced-compositions.md << 'EOF'
# Advanced Compositions

## Overview
Advanced composition techniques.

## Coming Soon
Advanced tutorial content.
EOF

cat > docs/videos/video-links.md << 'EOF'
# Video Resources

## Official Resources
- [Crossplane YouTube Channel](https://www.youtube.com/c/Crossplane)

## Community Tutorials
Coming soon!

## Conference Talks
Coming soon!
EOF

# examples
echo "Creating examples structure..."
mkdir -p examples/simple-s3-bucket
mkdir -p examples/complete-database
mkdir -p examples/app-deployment
mkdir -p examples/multi-resource-composition

for example in simple-s3-bucket complete-database app-deployment multi-resource-composition; do
    cat > "examples/$example/README.md" << EOF
# ${example//-/ }

## Description
Quick reference example.

## Files
- XRD
- Composition
- Example XR

## Usage
\`\`\`bash
kubectl apply -f .
\`\`\`

## Coming Soon
Complete example files.
EOF
    create_placeholder "examples/$example/xrd.yaml" "Example XRD"
    create_placeholder "examples/$example/composition.yaml" "Example Composition"
    create_placeholder "examples/$example/example-xr.yaml" "Example XR"
done

echo "Directory structure created successfully!"
echo "Total directories and files created:"
find . -type d | wc -l
find . -type f | wc -l
