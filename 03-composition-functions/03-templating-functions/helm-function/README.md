# Helm Function

The Helm function allows you to use Helm charts for templating managed resources.

## Installation

The Helm function is typically installed as part of your Crossplane setup.

## Basic Usage

Use Helm charts in compositions:

```yaml
pipeline:
  - step: helm-template
    functionRef:
      name: function-helm
    input:
      chart: stable/nginx
      values:
        replicaCount: 3
```

See `helm-composition.yaml` for examples.
