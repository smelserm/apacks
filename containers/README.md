# Apacks Docker Setup

This directory contains the Docker configuration for the Apacks Go application using a multistage build with distroless images.

## Files

- `Dockerfile` - Multistage Dockerfile using Go 1.25.0 and distroless
- `docker-compose.yml` - Docker Compose configuration for easy deployment
- `.dockerignore` - Files to exclude from Docker build context
- `build.sh` - Build script for easy Docker operations
- `README.md` - This documentation

## Features

- **Multistage Build**: Uses Go 1.25.0 for building and distroless for runtime
- **Static Linking**: CGO disabled for better compatibility with distroless
- **Optimized Image**: Minimal final image size using distroless base
- **Security**: Distroless images contain no shell or package manager
- **Health Checks**: Built-in health check support

## Usage

### Using the Build Script

The easiest way to build and run the container is using the provided build script:

```bash
# Build and run (default)
./containers/build.sh

# Build only
./containers/build.sh --build

# Run only (builds if image doesn't exist)
./containers/build.sh --run

# Clean up containers
./containers/build.sh --clean
```

### Using Docker Compose

```bash
# Build and run
docker-compose -f containers/docker-compose.yml up --build

# Run in background
docker-compose -f containers/docker-compose.yml up -d --build

# Stop and remove
docker-compose -f containers/docker-compose.yml down
```

### Using Docker Directly

```bash
# Build the image
docker build -t apacks-server -f containers/Dockerfile .

# Run the container
docker run -d -p 8080:8080 --name apacks-server apacks-server
```

## Environment Variables

The application supports the following environment variables (add them to the docker-compose.yml or pass with `-e`):

```yaml
environment:
  - ENV=production
  - DATABASE_URL=your_database_url
  - JWT_SECRET=your_jwt_secret
  # Add other environment variables as needed
```

## Ports

- **8080**: Main application port (configurable in your Go application)

## Health Checks

The container includes a health check that tests the `/health` endpoint. Make sure your Go application implements this endpoint for proper health monitoring.

## Security

This setup uses Google's distroless images which provide:

- No shell access
- No package manager
- Minimal attack surface
- Static binary execution only

## Troubleshooting

### Build Issues

1. **Go modules**: Make sure `go.mod` and `go.sum` are present in the project root
2. **Dependencies**: Run `go mod tidy` if you encounter dependency issues
3. **Context**: The build context is set to the parent directory (`..`)

### Runtime Issues

1. **Port conflicts**: Make sure port 8080 is available
2. **Environment**: Check that required environment variables are set
3. **Database**: Ensure database connectivity if your app requires it

### Container Issues

```bash
# View container logs
docker logs apacks-server

# Access container (for debugging - note: distroless has no shell)
docker exec -it apacks-server /bin/sh  # This will fail in distroless

# Debug with a shell-enabled image temporarily
# Change the base image in Dockerfile to gcr.io/distroless/static-debian12:debug
```

## Development vs Production

For development, you might want to:

1. Use a different base image with shell access
2. Mount source code as volumes
3. Enable hot reloading

The current setup is optimized for production deployments.
