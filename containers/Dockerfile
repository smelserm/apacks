# Build stage
FROM golang:1.25.0-alpine AS builder

# Install necessary build tools
RUN apk add --no-cache git ca-certificates tzdata

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

COPY ./go.mod ./go.sum ./

# Download dependencies
RUN go mod download

# Copy the backend source code
COPY ./apacks-server ./

# Build the application
# CGO_ENABLED=0 for static linking (required for distroless)
# -ldflags="-w -s" for smaller binary size
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s" \
    -o apacks-server \
    ./cmd/server/main.go

# Final stage using distroless
FROM gcr.io/distroless/static-debian12

# Copy the binary from builder stage
COPY --from=builder /app/apacks-server /

# Copy CA certificates for HTTPS requests
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy timezone data
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Expose port (adjust if your app uses a different port)
EXPOSE 8080

# Set the binary as the entrypoint
ENTRYPOINT ["/apacks-server"]
