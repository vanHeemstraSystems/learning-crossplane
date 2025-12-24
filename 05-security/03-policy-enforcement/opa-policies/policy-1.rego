# OPA Policy Examples
# These policies use Rego language for validation

# ============================================
# Policy 1: Require Environment Label
# ============================================

package crossplane.require_labels

# Deny if environment label is missing
deny[msg] {
    input.request.kind.kind == "DatabaseClaim"
    not input.request.object.metadata.labels.environment
    msg := "Label 'environment' is required for DatabaseClaim"
}

# Deny if environment label has invalid value
deny[msg] {
    input.request.kind.kind == "DatabaseClaim"
    input.request.object.metadata.labels.environment
    not valid_environment(input.request.object.metadata.labels.environment)
    msg := sprintf("Invalid environment '%v'. Valid values: development, staging, production", [input.request.object.metadata.labels.environment])
}

# Valid environment values
valid_environment(env) {
    env == "development"
}
valid_environment(env) {
    env == "staging"
}
valid_environment(env) {
    env == "production"
}

---
# ============================================
# Policy 2: Validate Database Schema
# ============================================

package crossplane.validate_database

# Deny if required fields are missing
deny[msg] {
    input.request.kind.kind == "DatabaseClaim"
    not input.request.object.spec.engine
    msg := "DatabaseClaim must specify 'engine' field"
}

deny[msg] {
    input.request.kind.kind == "DatabaseClaim"
    not input.request.object.spec.instanceClass
    msg := "DatabaseClaim must specify 'instanceClass' field"
}

# Deny if engine is invalid
deny[msg] {
    input.request.kind.kind == "DatabaseClaim"
    input.request.object.spec.engine
    not valid_engine(input.request.object.spec.engine)
    msg := sprintf("Invalid engine '%v'. Valid values: postgres, mysql, mongodb", [input.request.object.spec.engine])
}

# Valid engines
valid_engine(engine) {
    engine == "postgres"
}
valid_engine(engine) {
    engine == "mysql"
}
valid_engine(engine) {
    engine == "mongodb"
}

---
# ============================================
# Policy 3: Prevent Production Deletion
# ============================================

package crossplane.prevent_deletion

# Deny DELETE operations in production namespace
deny[msg] {
    input.request.operation == "DELETE"
    input.request.namespace == "production"
    msg := "Cannot delete resources in production namespace"
}

# Allow deletion if user is admin
allow {
    input.request.userInfo.groups[_] == "platform-admins"
}
