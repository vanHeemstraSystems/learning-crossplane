# Learning Crossplane

A comprehensive learning resource for Crossplane v2.1+, the cloud-native control plane framework for building platforms without writing code.

- [References](./REFERENCES.md)

![Crossplane Logo](https://crossplane.io/images/crossplane-logo.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Crossplane Version](https://img.shields.io/badge/Crossplane-v2.1+-blue.svg)](https://github.com/crossplane/crossplane)
[![CNCF Graduated](https://img.shields.io/badge/CNCF-Graduated-green.svg)](https://www.cncf.io/projects/crossplane/)

## 📚 Table of Contents

- [About This Repository](#about-this-repository)
- [What is Crossplane](#what-is-crossplane)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Learning Path](#learning-path)
- [Key Concepts](#key-concepts)
- [Hands-On Labs](#hands-on-labs)
- [Best Practices](#best-practices)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

## About This Repository

This repository serves as a structured learning resource for mastering Crossplane, covering everything from basic concepts to advanced composition functions and production deployments. It includes practical examples, hands-on labs, and real-world patterns for building cloud-native control planes.

**Current Crossplane Version Coverage:** v2.1 (November 2025)
**Status:** CNCF Graduated Project (October 28, 2025)

## What is Crossplane

Crossplane is a framework for building cloud-native control planes without needing to write code. It provides:

- **Universal Control Plane**: Orchestrate applications and infrastructure across any cloud
- **Declarative API**: Define resources using familiar Kubernetes patterns
- **Extensible Backend**: Build control planes using providers and composition functions
- **Configurable Frontend**: Control the schema of your declarative API
- **Platform Engineering**: Enable self-service infrastructure for development teams

### Key Features in Crossplane v2.1

- **Namespaced Composite Resources**: XRs are now namespaced by default
- **Simplified Architecture**: No more need for Claims abstraction
- **Enhanced Composition Functions**: Advanced templating with Python, Go, KCL, and more
- **Better Application Support**: First-class support for managing apps alongside infrastructure
- **Improved Developer Experience**: Streamlined workflows and better tooling

## Prerequisites

### Required Knowledge

- Basic understanding of Kubernetes concepts (Pods, Services, Deployments)
- Familiarity with YAML syntax
- Command-line interface (CLI) experience
- Basic cloud infrastructure concepts

### Required Tools

- **Kubernetes Cluster**: v1.25+ (can use kind, minikube, or cloud provider)
- **kubectl**: v1.25+ ([Installation Guide](https://kubernetes.io/docs/tasks/tools/))
- **Crossplane CLI**: v1.17+ ([Installation Guide](https://docs.crossplane.io/latest/cli/)) **Note**: ([Installation with WinGet](https://winget.ragerworks.com/package/Crossplane.CrossplaneCli))
- **Docker**: v24+ (for testing composition functions)
- **Helm**: v3.0+ (for Crossplane installation) **Note**: ([Installation with PowerShell](https://powershellcommands.com/install-helm-on-windows-powershell))

### Optional Tools

- **k9s**: Terminal UI for Kubernetes
- **yq**: YAML processor **Note**: [(Installation with WinGet](https://winget.ragerworks.com/package/MikeFarah.yq))
- **jq**: JSON processor **Note**: [(Installation with Chocolatey](https://bobbyhadz.com/blog/install-and-use-jq-on-windows))
- **VS Code**: With Kubernetes and YAML extensions

## Directory Structure

```
learning-crossplane/
│
├── README.md                          # This file
├── LICENSE                            # MIT License
├── .gitignore                        # Git ignore patterns
│
├── 01-fundamentals/                  # Crossplane fundamentals
│   ├── README.md                     # Fundamentals overview
│   ├── 01-installation/              # Installation methods
│   │   ├── helm-install.yaml
│   │   ├── helm-values.yaml
│   │   └── verify-installation.sh
│   ├── 02-providers/                 # Provider basics
│   │   ├── provider-aws.yaml
│   │   ├── provider-azure.yaml
│   │   ├── provider-gcp.yaml
│   │   ├── provider-kubernetes.yaml
│   │   └── provider-config.yaml
│   ├── 03-managed-resources/         # Managed resources
│   │   ├── s3-bucket.yaml
│   │   ├── rds-instance.yaml
│   │   ├── vpc.yaml
│   │   └── README.md
│   └── 04-basic-concepts/            # Core concepts
│       ├── crds.yaml
│       ├── custom-resources.yaml
│       └── resource-lifecycle.md
│
├── 02-compositions/                  # Composition fundamentals
│   ├── README.md                     # Composition overview
│   ├── 01-xrd-basics/                # XRD fundamentals
│   │   ├── simple-xrd.yaml
│   │   ├── namespaced-xrd.yaml
│   │   ├── cluster-scoped-xrd.yaml
│   │   └── schema-definition.yaml
│   ├── 02-basic-compositions/        # Basic compositions
│   │   ├── patch-and-transform.yaml
│   │   ├── resource-templates.yaml
│   │   └── composition-metadata.yaml
│   ├── 03-composite-resources/       # Working with XRs
│   │   ├── namespaced-xr.yaml
│   │   ├── cluster-xr.yaml
│   │   ├── xr-status.yaml
│   │   └── README.md
│   └── 04-v2-migration/              # v1 to v2 migration
│       ├── legacy-composition.yaml
│       ├── v2-composition.yaml
│       └── migration-guide.md
│
├── 03-composition-functions/         # Composition functions
│   ├── README.md                     # Functions overview
│   ├── 01-patch-and-transform/       # P&T function
│   │   ├── function-install.yaml
│   │   ├── simple-transform.yaml
│   │   ├── conditional-patching.yaml
│   │   └── examples/
│   ├── 02-function-pipeline/         # Function pipelines
│   │   ├── pipeline-composition.yaml
│   │   ├── multi-function.yaml
│   │   └── function-chaining.yaml
│   ├── 03-templating-functions/      # Template-based functions
│   │   ├── go-templating/
│   │   │   ├── function-config.yaml
│   │   │   └── template-examples.yaml
│   │   ├── kcl-function/
│   │   │   ├── function-install.yaml
│   │   │   └── kcl-examples/
│   │   └── helm-function/
│   │       └── helm-composition.yaml
│   ├── 04-custom-functions/          # Writing custom functions
│   │   ├── python-function/
│   │   │   ├── function.py
│   │   │   ├── Dockerfile
│   │   │   ├── requirements.txt
│   │   │   └── README.md
│   │   ├── go-function/
│   │   │   ├── main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   └── function-testing/
│   │       ├── test-inputs.yaml
│   │       └── render-tests.sh
│   └── 05-advanced-patterns/         # Advanced function patterns
│       ├── conditional-logic.yaml
│       ├── loops-iteration.yaml
│       ├── external-data.yaml
│       └── error-handling.yaml
│
├── 04-real-world-examples/           # Production-ready examples
│   ├── README.md                     # Examples overview
│   ├── 01-database-platform/         # Database self-service
│   │   ├── xrd/
│   │   │   └── database-xrd.yaml
│   │   ├── compositions/
│   │   │   ├── postgres-composition.yaml
│   │   │   ├── mysql-composition.yaml
│   │   │   └── mongodb-composition.yaml
│   │   ├── claims/
│   │   │   └── sample-database.yaml
│   │   └── README.md
│   ├── 02-application-platform/      # App deployment platform
│   │   ├── xrd/
│   │   │   └── app-xrd.yaml
│   │   ├── composition/
│   │   │   └── app-composition.yaml
│   │   ├── examples/
│   │   │   ├── frontend-app.yaml
│   │   │   └── backend-app.yaml
│   │   └── README.md
│   ├── 03-network-platform/          # Network infrastructure
│   │   ├── vpc-xrd.yaml
│   │   ├── vpc-composition.yaml
│   │   ├── subnet-composition.yaml
│   │   └── security-group-composition.yaml
│   ├── 04-observability-platform/    # Monitoring & logging
│   │   ├── monitoring-xrd.yaml
│   │   ├── prometheus-composition.yaml
│   │   ├── grafana-composition.yaml
│   │   └── loki-composition.yaml
│   └── 05-multi-cloud/               # Multi-cloud patterns
│       ├── provider-selection.yaml
│       ├── aws-composition.yaml
│       ├── azure-composition.yaml
│       └── gcp-composition.yaml
│
├── 05-security/                      # Security best practices
│   ├── README.md                     # Security overview
│   ├── 01-rbac/                      # Access control
│   │   ├── roles.yaml
│   │   ├── rolebindings.yaml
│   │   └── service-accounts.yaml
│   ├── 02-secrets-management/        # Secrets handling
│   │   ├── external-secrets.yaml
│   │   ├── sealed-secrets.yaml
│   │   └── vault-integration.yaml
│   ├── 03-policy-enforcement/        # Policy as code
│   │   ├── opa-policies/
│   │   ├── kyverno-policies/
│   │   └── admission-control.yaml
│   └── 04-compliance/                # Compliance patterns
│       ├── audit-logging.yaml
│       └── compliance-checks.yaml
│
├── 06-operations/                    # Operational excellence
│   ├── README.md                     # Operations overview
│   ├── 01-monitoring/                # Monitoring setup
│   │   ├── prometheus-rules.yaml
│   │   ├── grafana-dashboards/
│   │   └── alerts.yaml
│   ├── 02-troubleshooting/           # Debug procedures
│   │   ├── debug-commands.sh
│   │   ├── common-issues.md
│   │   └── logs-analysis.md
│   ├── 03-backup-restore/            # DR procedures
│   │   ├── backup-strategy.md
│   │   └── restore-procedures.md
│   ├── 04-upgrades/                  # Upgrade strategies
│   │   ├── upgrade-checklist.md
│   │   ├── rollback-plan.md
│   │   └── version-migration.yaml
│   └── 05-performance/               # Performance tuning
│       ├── scaling-config.yaml
│       └── optimization-guide.md
│
├── 07-ci-cd-integration/             # CI/CD pipelines
│   ├── README.md                     # CI/CD overview
│   ├── 01-gitops/                    # GitOps workflows
│   │   ├── argocd/
│   │   │   ├── application.yaml
│   │   │   └── app-of-apps.yaml
│   │   └── flux/
│   │       ├── kustomization.yaml
│   │       └── helmrelease.yaml
│   ├── 02-github-actions/            # GitHub workflows
│   │   ├── validate-composition.yaml
│   │   ├── test-functions.yaml
│   │   └── deploy-crossplane.yaml
│   ├── 03-gitlab-ci/                 # GitLab pipelines
│   │   └── .gitlab-ci.yaml
│   └── 04-testing/                   # Automated testing
│       ├── composition-tests/
│       ├── function-tests/
│       └── integration-tests/
│
├── 08-advanced-topics/               # Advanced scenarios
│   ├── README.md                     # Advanced topics overview
│   ├── 01-custom-providers/          # Building providers
│   │   ├── provider-template/
│   │   └── upjet-provider/
│   ├── 02-function-development/      # Advanced function dev
│   │   ├── sdk-usage/
│   │   ├── grpc-implementation/
│   │   └── optimization-patterns/
│   ├── 03-webhooks/                  # Validation webhooks
│   │   ├── admission-webhook.yaml
│   │   └── validation-logic.go
│   └── 04-event-driven/              # Event-driven patterns
│       ├── triggers.yaml
│       └── event-handlers/
│
├── 09-reference/                     # Reference materials
│   ├── README.md                     # Reference overview
│   ├── 01-api-reference/             # API documentation
│   │   ├── xrd-api.md
│   │   ├── composition-api.md
│   │   └── function-api.md
│   ├── 02-cli-reference/             # CLI commands
│   │   ├── crossplane-cli.md
│   │   └── kubectl-crossplane.md
│   ├── 03-glossary/                  # Terms & definitions
│   │   └── glossary.md
│   └── 04-cheat-sheets/              # Quick references
│       ├── commands.md
│       ├── patterns.md
│       └── troubleshooting.md
│
├── 10-labs/                          # Hands-on laboratories
│   ├── README.md                     # Labs overview
│   ├── lab-01-installation/          # Lab 1: Setup
│   │   ├── instructions.md
│   │   ├── lab-files/
│   │   └── solutions/
│   ├── lab-02-first-composition/     # Lab 2: Basic composition
│   │   ├── instructions.md
│   │   ├── lab-files/
│   │   └── solutions/
│   ├── lab-03-functions/             # Lab 3: Functions
│   │   ├── instructions.md
│   │   ├── lab-files/
│   │   └── solutions/
│   ├── lab-04-database-platform/     # Lab 4: Database platform
│   │   ├── instructions.md
│   │   ├── lab-files/
│   │   └── solutions/
│   └── lab-05-production/            # Lab 5: Production
│       ├── instructions.md
│       ├── lab-files/
│       └── solutions/
│
├── 11-case-studies/                  # Real-world case studies
│   ├── README.md                     # Case studies overview
│   ├── platform-team-adoption/       # Platform engineering
│   ├── multi-tenant-saas/            # SaaS platforms
│   ├── hybrid-cloud/                 # Hybrid deployments
│   └── edge-computing/               # Edge scenarios
│
├── scripts/                          # Utility scripts
│   ├── install-crossplane.sh
│   ├── setup-providers.sh
│   ├── validate-compositions.sh
│   ├── cleanup.sh
│   └── test-functions.sh
│
├── docs/                             # Additional documentation
│   ├── architecture/                 # Architecture guides
│   │   ├── control-plane-design.md
│   │   └── composition-patterns.md
│   ├── tutorials/                    # Step-by-step tutorials
│   │   ├── getting-started.md
│   │   ├── building-platforms.md
│   │   └── advanced-compositions.md
│   └── videos/                       # Video resources
│       └── video-links.md
│
└── examples/                         # Quick reference examples
    ├── simple-s3-bucket/
    ├── complete-database/
    ├── app-deployment/
    └── multi-resource-composition/
```

## Getting Started

### Quick Start (5 minutes)

1. **Install Crossplane**:
   ```bash
   # Create a Kubernetes cluster (if needed)
   kind create cluster --name crossplane-playground
   
   # Install Crossplane using Helm
   helm repo add crossplane-stable https://charts.crossplane.io/stable
   helm repo update
   helm install crossplane \
     --namespace crossplane-system \
     --create-namespace \
     crossplane-stable/crossplane
   ```

2. **Verify Installation**:
   ```bash
   kubectl get pods -n crossplane-system
   ```

3. **Install Crossplane CLI**:
   ```bash
   curl -sL "https://raw.githubusercontent.com/crossplane/crossplane/main/install.sh" | sh
   sudo mv crossplane /usr/local/bin
   ```

4. **Run Your First Example**:
   ```bash
   cd 01-fundamentals/01-installation
   ./verify-installation.sh
   ```

### Detailed Setup

See [01-fundamentals/README.md](01-fundamentals/README.md) for comprehensive installation and setup instructions.

## Learning Path

### 🌱 Beginner Track (Weeks 1-2)

**Goal**: Understand Crossplane fundamentals and basic resource management

1. **Fundamentals** (`01-fundamentals/`)
   - Install Crossplane
   - Understand providers and managed resources
   - Learn about Custom Resource Definitions (CRDs)
   
2. **Basic Compositions** (`02-compositions/01-xrd-basics/`)
   - Create your first XRD
   - Build simple compositions
   - Deploy composite resources

**Lab**: Complete `10-labs/lab-01-installation/` and `lab-02-first-composition/`

### 🌿 Intermediate Track (Weeks 3-4)

**Goal**: Master composition functions and build reusable platform APIs

1. **Composition Functions** (`03-composition-functions/`)
   - Work with Patch & Transform
   - Build function pipelines
   - Use templating functions (KCL, Go templates)
   
2. **Real-World Patterns** (`04-real-world-examples/`)
   - Database self-service platform
   - Application deployment automation
   - Network infrastructure management

**Lab**: Complete `10-labs/lab-03-functions/` and `lab-04-database-platform/`

### 🌳 Advanced Track (Weeks 5-6)

**Goal**: Implement production-ready control planes with security and operations

1. **Security & Compliance** (`05-security/`)
   - RBAC and access control
   - Secrets management
   - Policy enforcement
   
2. **Operations** (`06-operations/`)
   - Monitoring and observability
   - Troubleshooting patterns
   - Backup and disaster recovery
   
3. **CI/CD Integration** (`07-ci-cd-integration/`)
   - GitOps workflows
   - Automated testing
   - Deployment pipelines

**Lab**: Complete `10-labs/lab-05-production/`

### 🚀 Expert Track (Ongoing)

**Goal**: Extend Crossplane and contribute to the ecosystem

1. **Advanced Topics** (`08-advanced-topics/`)
   - Build custom providers
   - Develop custom functions
   - Implement webhooks
   
2. **Community Contribution**
   - Contribute to open-source functions
   - Share composition patterns
   - Write blog posts and tutorials

## Key Concepts

### Composite Resource Definition (XRD)

Defines the schema for your custom API:

```yaml
apiVersion: apiextensions.crossplane.io/v2
kind: CompositeResourceDefinition
metadata:
  name: databases.example.io
spec:
  scope: Namespaced  # New in v2: Namespaced by default
  group: example.io
  names:
    kind: Database
    plural: databases
  versions:
  - name: v1
    served: true
    referenceable: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              size:
                type: string
                enum: [small, medium, large]
              engine:
                type: string
                enum: [postgres, mysql]
```

### Composition

Templates that define what resources to create:

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: database-aws
spec:
  compositeTypeRef:
    apiVersion: example.io/v1
    kind: Database
  mode: Pipeline  # Use function pipeline
  pipeline:
  - step: patch-and-transform
    functionRef:
      name: crossplane-contrib-function-patch-and-transform
    input:
      apiVersion: pt.fn.crossplane.io/v1beta1
      kind: Resources
      resources:
      - name: rds-instance
        base:
          apiVersion: rds.aws.crossplane.io/v1alpha1
          kind: Instance
          spec:
            forProvider:
              engine: postgres
```

### Composition Functions

Extend composition with custom logic:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Function
metadata:
  name: function-patch-and-transform
spec:
  package: xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2
```

Popular functions:
- **function-patch-and-transform**: Traditional P&T compositions
- **function-go-templating**: Go template-based composition
- **function-kcl**: KCL language for composition
- **function-auto-ready**: Automatic readiness detection
- **Custom functions**: Written in Go or Python

### What's New in Crossplane v2

- **Namespaced XRs**: Composite resources are namespaced by default
- **No More Claims**: Simplified architecture removes the claim abstraction
- **Better App Support**: First-class support for managing applications
- **Backward Compatible**: v1 compositions continue to work

## Hands-On Labs

Each lab includes:
- Detailed step-by-step instructions
- Starter files and templates
- Complete solutions
- Validation tests

### Available Labs

1. **Lab 1**: Installation & Setup (30 min)
2. **Lab 2**: First Composition (45 min)
3. **Lab 3**: Composition Functions (60 min)
4. **Lab 4**: Database Platform (90 min)
5. **Lab 5**: Production Deployment (120 min)

See `10-labs/README.md` for detailed lab instructions.

## Best Practices

### Composition Design

✅ **DO**:
- Use meaningful, descriptive names for XRDs and compositions
- Version your XRDs appropriately
- Leverage function pipelines for complex logic
- Document composition behavior in annotations
- Use namespaced XRs unless you need cluster scope

❌ **DON'T**:
- Embed sensitive data directly in compositions
- Create overly complex single compositions
- Skip validation schemas in XRDs
- Mix v1 and v2 patterns in the same platform

### Security

- Use RBAC to restrict access to compositions
- Leverage external secrets management
- Implement policy enforcement with OPA or Kyverno
- Enable audit logging
- Regularly scan provider images

### Operations

- Monitor composition reconciliation metrics
- Set up alerting for composition failures
- Implement backup strategies for XR state
- Test compositions with `crossplane render`
- Use GitOps for composition lifecycle

### Function Development

- Write comprehensive tests for custom functions
- Use the official SDKs (Go, Python)
- Document function inputs clearly
- Handle errors gracefully
- Consider performance implications

## Resources

### Official Documentation

- [Crossplane Documentation](https://docs.crossplane.io/)
- [Crossplane GitHub](https://github.com/crossplane/crossplane)
- [API Reference](https://doc.crds.dev/github.com/crossplane/crossplane)
- [Crossplane Blog](https://blog.crossplane.io/)

### Community

- [Crossplane Slack](https://slack.crossplane.io/)
- [Community Meetings](https://github.com/crossplane/crossplane#get-involved)
- [YouTube Channel](https://www.youtube.com/c/Crossplane)
- [Twitter/X](https://twitter.com/crossplane_io)

### Learning Materials

- [Crossplane Book on LeanPub](https://leanpub.com/crossplane)
- [Technology Conversations Blog](https://technologyconversations.wordpress.com/)
- [Viktor Farcic's Tutorials](https://www.youtube.com/@DevOpsToolkit)
- [Upbound Academy](https://www.upbound.io/academy)

### Tools & Extensions

- [Crossplane CLI](https://docs.crossplane.io/latest/cli/)
- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=Upbound.upbound)
- [Crossplane Migrator](https://github.com/crossplane-contrib/crossplane-migrator)
- [kubectl crossplane plugin](https://github.com/crossplane/crossplane/tree/master/cmd/crank)

### Providers

- [AWS Provider](https://marketplace.upbound.io/providers/upbound/provider-aws/)
- [Azure Provider](https://marketplace.upbound.io/providers/upbound/provider-azure/)
- [GCP Provider](https://marketplace.upbound.io/providers/upbound/provider-gcp/)
- [Kubernetes Provider](https://marketplace.upbound.io/providers/crossplane-contrib/provider-kubernetes/)
- [Provider Index](https://marketplace.upbound.io/)

### Composition Functions

- [Function Registry](https://marketplace.upbound.io/?category=functions)
- [function-patch-and-transform](https://github.com/crossplane-contrib/function-patch-and-transform)
- [function-go-templating](https://github.com/crossplane-contrib/function-go-templating)
- [function-kcl](https://github.com/crossplane-contrib/function-kcl)
- [function-auto-ready](https://github.com/crossplane-contrib/function-auto-ready)

## Contributing

Contributions are welcome! This is a learning resource for the community.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-example`)
3. Add your example or improvement
4. Ensure documentation is updated
5. Submit a pull request

### Contribution Guidelines

- Follow existing directory structure
- Include comprehensive README files
- Add comments to complex YAML
- Provide working examples
- Test all configurations before submitting
- Follow Crossplane best practices

### What to Contribute

- New composition examples
- Custom function implementations
- Real-world case studies
- Improved documentation
- Bug fixes and clarifications
- Additional labs and tutorials

## Roadmap

### Planned Content

- [ ] Advanced multi-cloud patterns
- [ ] Service mesh integration examples
- [ ] Cost optimization strategies
- [ ] Disaster recovery blueprints
- [ ] Edge computing scenarios
- [ ] Machine learning platform examples

### Stay Updated

Watch this repository for updates as Crossplane evolves. Major updates planned for:
- Crossplane v2.2 (February 2026)
- Crossplane v2.3 (May 2026)

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- Crossplane maintainers and community
- CNCF for hosting the project
- All contributors to this learning resource
- The platform engineering community

## Author

**Willem van Heemstra**
- Security Domain Expert & Cloud Engineer
- Focus: DevSecOps, Cloud Security, Platform Engineering
- Location: Eersel, Netherlands

---

**⭐ If you find this resource helpful, please star the repository!**

**🤝 Contributions and feedback are always welcome!**

**📧 Questions? Open an issue or join the [Crossplane Slack](https://slack.crossplane.io/)**

---

*Last Updated: December 24, 2025*
*Crossplane Version: v2.1 (November 2025)*
*CNCF Status: Graduated Project (October 2025)*
