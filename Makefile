.PHONY: build run test clean deps lint format docker-build-apacks-server docker-run-apacks-server docker-clean-apacks-server docker-up

# Build variables
BINARY_NAME=apacks-server
BUILD_DIR=bin

# Build the application
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(BINARY_NAME) backend/cmd/server/main.go

# Run the application
run:
	@echo "Running $(BINARY_NAME)..."
	go run backend/cmd/server/main.go

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
docker-build-apacks-server:
	@echo "Building Docker image..."
	../../containers/backend/apacks-server/build.sh --build

# Run Docker container
docker-run-apacks-server:
	@echo "Running Docker container..."
	../../containers/backend/apacks-server/build.sh --run

# Clean Docker containers
docker-clean-apacks-server:
	@echo "Cleaning Docker containers..."
	../../containers/backend/apacks-server/build.sh --clean

# Build and run Docker container
docker-up-apacks-server:
	@echo "Building and running Docker container..."
	../../containers/backend/apacks-server/build.sh

