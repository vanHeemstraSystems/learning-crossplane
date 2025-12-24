# Templating Functions

Templating functions allow you to use template engines (Go templates, KCL, Helm) to dynamically generate managed resources from XR inputs.

## What are Templating Functions?

Templating functions are Composition Functions that:

- **Use template engines** to generate resources
- **Support dynamic generation** based on XR inputs
- **Enable complex logic** through templating
- **Provide flexibility** for resource generation

## Available Templating Functions

### 1. Go Templating Function

Uses Go's text/template package for templating.

**Use when:**
- You need text-based templating
- You're familiar with Go templates
- You want simple, flexible templating

See [go-templating/](./go-templating/) for examples.

### 2. KCL Function

Uses KCL (Kubernetes Configuration Language) for templating.

**Use when:**
- You need type-safe templating
- You want validation built-in
- You prefer a domain-specific language

See [kcl-function/](./kcl-function/) for examples.

### 3. Helm Function

Uses Helm charts for templating.

**Use when:**
- You have existing Helm charts
- You want to reuse Helm templates
- You need Helm's templating capabilities

See [helm-function/](./helm-function/) for examples.

## Choosing a Templating Function

### Go Templates

**Pros:**
- Simple and flexible
- Widely understood
- Good for text generation

**Cons:**
- Limited type safety
- Can be verbose for complex logic

### KCL

**Pros:**
- Type-safe
- Built-in validation
- Domain-specific for Kubernetes

**Cons:**
- Learning curve
- Less flexible than Go templates

### Helm

**Pros:**
- Reuse existing charts
- Rich templating functions
- Well-documented

**Cons:**
- Requires Helm charts
- Can be complex

## Best Practices

1. **Choose the Right Tool**: Match template engine to your needs
2. **Keep Templates Simple**: Complex templates are hard to maintain
3. **Test Thoroughly**: Test templates with various inputs
4. **Document Templates**: Document template logic
5. **Version Templates**: Version your template functions

## Examples

This directory contains examples for each templating function:

- **go-templating/** - Go template examples
- **kcl-function/** - KCL examples
- **helm-function/** - Helm examples

## Next Steps

Now that you understand templating functions:

1. **Custom Functions** - Write your own templating functions
2. **Advanced Patterns** - Use templates in advanced scenarios
3. **Production Patterns** - Deploy templating in production

## Additional Resources

- [Go Templates Documentation](https://pkg.go.dev/text/template)
- [KCL Documentation](https://kcl-lang.io/)
- [Helm Documentation](https://helm.sh/docs/)

---

**Ready to write custom functions?** Move to [Custom Functions](../04-custom-functions/)!
