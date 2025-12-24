# Go Templating Function

The Go templating function uses Go's text/template package to generate managed resources dynamically.

## Installation

Install the Go templating function:

```bash
kubectl apply -f function-config.yaml
```

## Basic Usage

### Simple Template

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: network-go-template
spec:
  compositeTypeRef:
    apiVersion: network.example.org/v1alpha1
    kind: Network
  mode: Pipeline
  pipeline:
    - step: template
      functionRef:
        name: function-go-templating
      input:
        source: Inline
        inline:
          template: |
            apiVersion: ec2.aws.crossplane.io/v1beta1
            kind: VPC
            metadata:
              name: {{ .spec.name }}
            spec:
              forProvider:
                cidrBlock: {{ .spec.cidr }}
                region: {{ .spec.region }}
```

See `template-examples.yaml` for complete examples.

## Template Syntax

### Variables

Access XR fields:

```go
{{ .spec.cidr }}
{{ .metadata.name }}
{{ .spec.environment }}
```

### Conditionals

```go
{{ if eq .spec.environment "production" }}
  multiAz: true
{{ else }}
  multiAz: false
{{ end }}
```

### Loops

```go
{{ range .spec.subnets }}
- name: {{ .name }}
  cidr: {{ .cidr }}
{{ end }}
```

## Examples

See `template-examples.yaml` for comprehensive examples.
