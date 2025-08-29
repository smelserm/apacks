.PHONY: build run test clean deps lint format docker-build docker-run

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
	cd backend && go test -v ./...

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	cd backend
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
	cd backend && go mod tidy && go mod download
	
# Run linter
lint:
	@echo "Running linter..."
	cd backend && golangci-lint run

# Format code
format:
	@echo "Formatting code..."
	cd backend && go fmt ./...

# Run vet
vet:
	@echo "Running vet..."
	cd backend && go vet ./...

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	cd backend && docker build -t $(BINARY_NAME) .

# Run Docker container
docker-run:
	@echo "Running Docker container..."
	docker run -p 8080:8080 $(BINARY_NAME)

# Development setup
dev-setup: deps format lint test

# Frontend commands
frontend-install:
	@echo "Installing frontend dependencies..."
	cd frontend && npm install

frontend-start:
	@echo "Starting React frontend..."
	cd frontend && npm start

frontend-build:
	@echo "Building React frontend..."
	cd frontend && npm run build

# Development with both backend and frontend
dev: frontend-install
	@echo "Starting development environment..."
	./scripts/dev.sh

# Production build
prod-build: clean build frontend-build
