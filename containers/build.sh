#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="apacks-server"
TAG="latest"
CONTEXT_PATH="../."
DOCKERFILE_PATH="./Dockerfile"
CONTAINER_NAME="apacks-server"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check Docker DNS resolution
check_docker_dns() {
    print_status "Checking Docker DNS resolution..."
    if docker run --rm alpine:latest nslookup host.docker.internal >/dev/null 2>&1; then
        print_status "Docker DNS resolution working correctly"
        return 0
    else
        print_warning "Docker DNS resolution check failed - this may cause connectivity issues"
        return 1
    fi
}

# Function to build Docker image
build_image() {
    print_status "Building Docker image: $IMAGE_NAME:$TAG"
    print_status "Context: $CONTEXT_PATH"
    print_status "Dockerfile: $DOCKERFILE_PATH"

    if docker build -t "$IMAGE_NAME:$TAG" -f "$DOCKERFILE_PATH" "$CONTEXT_PATH"; then
        print_status "Docker image built successfully!"
        print_status "Image: $IMAGE_NAME:$TAG"
        return 0
    else
        print_error "Failed to build Docker image"
        return 1
    fi
}

# Function to run container
run_container() {
    print_status "Running container: $IMAGE_NAME:$TAG"
    print_status "Port mapping: 8080:8080"
    print_status "Container name: $CONTAINER_NAME"

    # Check if port 8080 is already in use
    if lsof -i :8080 >/dev/null 2>&1; then
        print_warning "Port 8080 is already in use. Attempting to free it..."
        # Try to stop any existing containers using port 8080
        docker ps -q --filter "publish=8080" | xargs -r docker stop >/dev/null 2>&1
        sleep 2
    fi

    # Run container with proper environment variables and host configuration
    if docker run -d \
        --name "$CONTAINER_NAME" \
        -p 8080:8080 \
        --add-host host.docker.internal:host-gateway \
        -e ENV=production \
        -e SERVER_HOST=0.0.0.0 \
        -e JWT_SECRET=thesecretkey \
        "$IMAGE_NAME:$TAG"; then

        print_status "Container started successfully!"
        print_status "Container name: $CONTAINER_NAME"
        print_status "Access your application at: http://localhost:8080"

        # Wait a moment for the container to start
        sleep 3

        # Test if the container is responding
        if docker exec "$CONTAINER_NAME" wget --no-verbose --tries=1 --spider http://localhost:8080/health >/dev/null 2>&1; then
            print_status "Health check passed - container is ready!"
        else
            print_warning "Health check failed - container may still be starting up"
        fi

        print_status "Container logs (last 10 lines):"
        docker logs --tail 10 "$CONTAINER_NAME" 2>/dev/null || print_warning "Could not retrieve container logs"

        return 0
    else
        print_error "Failed to start container"
        return 1
    fi
}

# Function to stop and remove container
cleanup_container() {
    print_status "Cleaning up existing container..."

    # Stop container if running
    if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        docker stop "$CONTAINER_NAME" >/dev/null 2>&1
        print_status "Stopped running container: $CONTAINER_NAME"
    fi

    # Remove container if exists
    if docker ps -a -q -f name="$CONTAINER_NAME" | grep -q .; then
        docker rm "$CONTAINER_NAME" >/dev/null 2>&1
        print_status "Removed existing container: $CONTAINER_NAME"
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -b, --build     Build Docker image only"
    echo "  -r, --run       Run Docker container only"
    echo "  -c, --clean     Clean up existing containers"
    echo "  -h, --help      Show this help message"
    echo ""
    echo "If no options are provided, the script will build and run the container."
}

# Parse command line arguments
BUILD_ONLY=false
RUN_ONLY=false
CLEAN_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--build)
            BUILD_ONLY=true
            shift
            ;;
        -r|--run)
            RUN_ONLY=true
            shift
            ;;
        -c|--clean)
            CLEAN_ONLY=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution logic
main() {
    cd "$(dirname "$0")" || exit 1

    if [ "$CLEAN_ONLY" = true ]; then
        cleanup_container
        print_status "Cleanup completed"
        exit 0
    fi

    if [ "$BUILD_ONLY" = true ]; then
        build_image
        exit $?
    fi

    if [ "$RUN_ONLY" = true ]; then
        check_docker_dns
        cleanup_container
        run_container
        exit $?
    fi

    # Default behavior: build and run
    check_docker_dns
    cleanup_container
    if build_image; then
        run_container
    else
        exit 1
    fi
}

# Run main function
main "$@"
