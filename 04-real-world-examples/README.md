# Real-World Examples

Welcome to the Real-World Examples section! This module provides production-ready examples that demonstrate how to use Crossplane to build self-service platforms for common infrastructure needs.

## Overview

These examples show complete, working implementations of common platform engineering patterns using Crossplane. Each example includes:

- **XRD**: Custom API definition
- **Compositions**: Implementation patterns
- **Examples**: Sample usage
- **Documentation**: Complete guides

## What You'll Learn

By exploring these real-world examples, you will:

- ✅ See how to build complete self-service platforms
- ✅ Understand production-ready patterns
- ✅ Learn best practices from real implementations
- ✅ Get ready-to-use examples for your own platforms
- ✅ See how different use cases are solved

## Prerequisites

Before exploring these examples, ensure you have:

- Completed the [Fundamentals](../01-fundamentals/) section
- Completed the [Compositions](../02-compositions/) section
- Understanding of XRDs, Compositions, and XRs
- Optional: Understanding of [Composition Functions](../03-composition-functions/)

## Example Platforms

### 1. [Database Platform](./01-database-platform/)

A complete self-service database platform supporting multiple database engines (PostgreSQL, MySQL, MongoDB).

**Features:**
- Multi-engine support
- Environment-specific configurations
- Connection secret management
- Backup and monitoring integration

**Use Cases:**
- Developer self-service databases
- Multi-tenant database provisioning
- Database platform as a service

### 2. [Application Platform](./02-application-platform/)

A platform for deploying and managing applications with infrastructure.

**Features:**
- Application + infrastructure provisioning
- Environment management
- Resource scaling
- Health monitoring

**Use Cases:**
- Developer self-service deployments
- Microservices platform
- Application infrastructure automation

### 3. [Network Platform](./03-network-platform/)

A networking platform for provisioning VPCs, subnets, and security groups.

**Features:**
- VPC provisioning
- Subnet management
- Security group automation
- Network isolation

**Use Cases:**
- Multi-tenant networking
- Environment isolation
- Network automation

### 4. [Observability Platform](./04-observability-platform/)

A platform for deploying monitoring and logging infrastructure.

**Features:**
- Prometheus deployment
- Grafana dashboards
- Loki logging
- Alerting configuration

**Use Cases:**
- Centralized monitoring
- Application observability
- Infrastructure monitoring

### 5. [Multi-Cloud Platform](./05-multi-cloud/)

A platform that supports multiple cloud providers with the same API.

**Features:**
- Provider abstraction
- Multi-cloud deployments
- Provider selection logic
- Cloud-agnostic APIs

**Use Cases:**
- Multi-cloud strategies
- Cloud migration
- Vendor independence

## How to Use These Examples

### Step 1: Choose an Example

Select the example that matches your use case or learning goal.

### Step 2: Review the Structure

Each example includes:
- **XRD**: The API definition
- **Compositions**: Implementation details
- **Examples**: Sample usage
- **README**: Complete documentation

### Step 3: Install Prerequisites

Ensure you have:
- Crossplane installed
- Required providers installed
- Provider configurations set up

### Step 4: Deploy the Example

Follow the example's README to deploy:
1. Install the XRD
2. Install the Compositions
3. Create sample XRs
4. Verify resources are created

### Step 5: Customize

Adapt the example to your needs:
- Modify the XRD schema
- Update compositions
- Add your own logic

## Common Patterns

### Pattern 1: Multi-Engine Support

Same XRD, different compositions for different engines:
- Database: PostgreSQL, MySQL, MongoDB
- Storage: S3, Azure Blob, GCS
- Compute: EC2, Azure VM, GCE

### Pattern 2: Environment-Specific

Different compositions for different environments:
- Development: Small, cheap resources
- Staging: Medium resources
- Production: High-availability, secure resources

### Pattern 3: Multi-Cloud

Same XRD, different compositions for different clouds:
- AWS composition
- Azure composition
- GCP composition

## Best Practices Demonstrated

These examples demonstrate:

1. **Clear API Design**: Well-defined XRDs with validation
2. **Reusable Compositions**: Compositions that can be reused
3. **Environment Management**: Proper namespace and label usage
4. **Secret Management**: Secure handling of credentials
5. **Error Handling**: Proper error handling and status reporting
6. **Documentation**: Complete documentation for users

## Customization Guide

### Modifying XRDs

1. Update the schema in the XRD
2. Ensure backward compatibility if possible
3. Update compositions to handle new fields
4. Test with sample XRs

### Creating New Compositions

1. Start from an existing composition
2. Modify resource templates
3. Update patches
4. Test thoroughly

### Adding Functions

1. Identify where functions would help
2. Choose appropriate function type
3. Integrate into composition pipeline
4. Test function logic

## Troubleshooting

### XRD Not Working

- Verify XRD is installed: `kubectl get xrd`
- Check schema validation
- Review XRD status

### Composition Not Matching

- Verify composition references correct XRD
- Check composition mode (Pipeline vs Resources)
- Review composition status

### Resources Not Creating

- Check XR status: `kubectl describe xr <name>`
- Verify provider is healthy
- Check provider configuration
- Review managed resource events

## Next Steps

After exploring these examples:

1. **Adapt to Your Needs**: Customize examples for your use case
2. **Build Your Platform**: Create your own platform using these patterns
3. **Share Your Examples**: Contribute back to the community
4. **Production Deployment**: Learn about production patterns

## Contributing

Have a real-world example to share? We welcome contributions!

1. Follow the structure of existing examples
2. Include complete documentation
3. Provide working examples
4. Submit a pull request

## Resources

- [Crossplane Examples](https://github.com/crossplane/crossplane/tree/master/examples)
- [Community Examples](https://github.com/crossplane-contrib)
- [Platform Engineering Patterns](https://platformengineering.org/)

## Feedback

Found an issue or have suggestions? Please open an issue or submit a pull request!

---

**Ready to explore?** Start with [Database Platform](./01-database-platform/)!
