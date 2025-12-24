# Crossplane Fundamentals

Welcome to the Crossplane Fundamentals section! This module provides a comprehensive introduction to Crossplane, covering everything you need to know to get started with building cloud-native control planes.

## Overview

Crossplane is a framework for building cloud-native control planes without writing code. It extends Kubernetes to enable you to manage infrastructure and applications using the same declarative API patterns you're already familiar with.

### What You'll Learn

By completing this fundamentals section, you will:

- ✅ Understand what Crossplane is and why it exists
- ✅ Install and configure Crossplane in your Kubernetes cluster
- ✅ Install and configure providers for cloud resources
- ✅ Create and manage managed resources (infrastructure as code)
- ✅ Understand core Crossplane concepts and resource lifecycle
- ✅ Be ready to move on to advanced topics like Compositions

## Prerequisites

Before starting, ensure you have:

- A working Kubernetes cluster (v1.25+)
- `kubectl` configured to access your cluster
- Basic understanding of Kubernetes concepts (Pods, Deployments, Services)
- Familiarity with YAML syntax
- Basic knowledge of cloud infrastructure concepts

## Learning Path

This fundamentals section is organized into four progressive modules:

### 1. [Installation](./01-installation/)

Learn how to install Crossplane in your Kubernetes cluster using Helm, verify the installation, and configure basic settings.

**Topics Covered:**
- Helm installation methods
- Configuration options
- Verification and troubleshooting
- Upgrading Crossplane

**Estimated Time:** 15-20 minutes

### 2. [Providers](./02-providers/)

Providers are Crossplane's way of connecting to external systems (cloud providers, databases, etc.). Learn how to install and configure providers.

**Topics Covered:**
- What are providers
- Installing providers (AWS, Azure, GCP, Kubernetes)
- Configuring provider credentials
- Provider health and status

**Estimated Time:** 30-40 minutes

### 3. [Managed Resources](./03-managed-resources/)

Managed resources are the building blocks of infrastructure in Crossplane. Learn how to create and manage cloud resources declaratively.

**Topics Covered:**
- Understanding managed resources
- Creating S3 buckets, RDS instances, VPCs
- Resource lifecycle management
- Monitoring and troubleshooting

**Estimated Time:** 45-60 minutes

### 4. [Basic Concepts](./04-basic-concepts/)

Deep dive into core Crossplane concepts that form the foundation for advanced topics.

**Topics Covered:**
- Custom Resource Definitions (CRDs)
- Resource lifecycle and reconciliation
- Status conditions
- Finalizers and deletion

**Estimated Time:** 30-40 minutes

## Quick Start

If you're eager to get started quickly, follow this minimal path:

1. **Install Crossplane** (5 min)
   ```bash
   cd 01-installation
   # Follow the installation guide
   ```

2. **Install a Provider** (5 min)
   ```bash
   cd ../02-providers
   # Install AWS provider (or your preferred cloud)
   ```

3. **Create Your First Resource** (10 min)
   ```bash
   cd ../03-managed-resources
   # Create an S3 bucket
   ```

## Key Concepts

Before diving in, here are some essential concepts to understand:

### Control Plane vs Data Plane

- **Control Plane**: Crossplane runs in your Kubernetes cluster and manages the desired state
- **Data Plane**: The actual cloud resources (S3 buckets, databases, etc.) that exist in your cloud provider

### Declarative vs Imperative

Crossplane follows Kubernetes' declarative model:
- You declare **what** you want (a bucket, a database)
- Crossplane figures out **how** to create it
- Crossplane continuously reconciles to ensure the actual state matches desired state

### Providers

Providers are Crossplane's connection to external systems. They:
- Translate Crossplane resources to cloud provider APIs
- Handle authentication and authorization
- Monitor resource health and status

### Managed Resources

Managed resources are Kubernetes Custom Resources that represent infrastructure:
- They follow the same patterns as native Kubernetes resources
- They can be created, updated, and deleted using `kubectl`
- They have status fields showing the current state

## Hands-On Practice

Each module includes hands-on exercises. We recommend:

1. **Follow along** with the examples in each module
2. **Experiment** by modifying the YAML files
3. **Observe** the behavior using `kubectl` commands
4. **Troubleshoot** when things don't work as expected

## Common Issues

### Provider Not Ready

If a provider shows as "Not Ready":
- Check provider pod logs: `kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=<provider-name>`
- Verify provider configuration credentials
- Check network connectivity to cloud provider APIs

### Resources Stuck in "Creating"

If resources remain in "Creating" state:
- Check managed resource events: `kubectl describe <resource-type> <resource-name>`
- Review provider logs for errors
- Verify IAM permissions for the provider

### Installation Issues

If Crossplane doesn't install correctly:
- Verify Kubernetes version (v1.25+ required)
- Check cluster resources (CPU/memory)
- Review Helm installation logs

## Next Steps

After completing the fundamentals:

1. **Compositions** - Learn to create reusable infrastructure patterns
2. **Composite Resources** - Build custom APIs for your platform
3. **Composition Functions** - Use Python, Go, or KCL for advanced logic
4. **Production Patterns** - Deploy Crossplane in production environments

## Resources

- [Official Crossplane Documentation](https://docs.crossplane.io/)
- [Crossplane GitHub](https://github.com/crossplane/crossplane)
- [Crossplane Community Slack](https://slack.crossplane.io/)
- [Crossplane YouTube Channel](https://www.youtube.com/c/Crossplane)

## Feedback

Found an issue or have suggestions? Please open an issue or submit a pull request!

---

**Ready to begin?** Start with [Installation](./01-installation/)!
