# Dockerfile for Go Composition Function

FROM golang:1.21-alpine AS builder

WORKDIR /build

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY main.go .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o function main.go

# Final image
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /function
COPY --from=builder /build/function .
ENTRYPOINT ["./function"]
