.PHONY: build run test clean deps lint format docker-build docker-run docker-clean docker-up

# Build variables
BINARY_NAME=apacks-server
BUILD_DIR=bin

# Build the application
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(BINARY_NAME) cmd/server/main.go

# Run the application
run:
	@echo "Running $(BINARY_NAME)..."
	go run cmd/server/main.go

# Run tests
test:
	@echo "Running tests..."
	go test -v ./...

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -f coverage.out

# Install dependencies
deps:
	@echo "Installing dependencies..."
	go mod tidy && go mod download
	
# Run linter
lint:
	@echo "Running linter..."
	golangci-lint run

# Format code
format:
	@echo "Formatting code..."
	go fmt ./...

# Run vet
vet:
	@echo "Running vet..."
	&& go vet ./...

# Development setup
dev-setup: deps format lint test

# Client commands
client-install:
	@echo "Installing client dependencies..."
	cd client && npm install

client-start:
	@echo "Starting React client..."
	cd client && npm start

client-build:
	@echo "Building React client..."
	cd client && npm run build

# Development with both backend and client
dev: client-install
	@echo "Starting development environment..."
	./scripts/dev.sh

# Production build
prod-build: clean build client-build

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	cd containers && ./build.sh --build

# Run Docker container
docker-run:
	@echo "Running Docker container..."
	cd containers && ./build.sh --run

# Clean Docker containers
docker-clean:
	@echo "Cleaning Docker containers..."
	cd containers && ./build.sh --clean

# Prune Docker
docker-prune: docker-clean
	@echo "Pruning Docker..."
	docker system prune -f --all --volumes

# Build and run Docker container
docker-up:
	@echo "Building and running Docker container..."
	cd containers && ./build.sh

# Build and run with Docker Compose
compose-up:
	@echo "Building and running Docker Compose..."
	cd containers && docker-compose up --build

# Run in background with Docker Compose
compose-up-d:
	@echo "Building and running Docker Compose in background..."
	cd containers && docker-compose up -d --build

# Stop and remove Docker Compose
compose-down:
	@echo "Stopping and removing Docker Compose..."
	cd containers && docker-compose down

