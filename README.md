# Apacks Go Server

A well-structured Go server application with clean architecture, following best practices for scalability and maintainability.

## Project Structure

```
apacks
|── backend/
├── cmd/
│   └── server/          # Application entry point
├── internal/            # Private application code
│   ├── api/            # HTTP server and routing
│   ├── config/         # Configuration management
│   ├── database/       # Database connection and setup
│   ├── handlers/       # HTTP request handlers
│   ├── middleware/     # HTTP middleware
│   ├── models/         # Data models
│   ├── repository/     # Data access layer
│   ├── services/       # Business logic
│   └── utils/          # Internal utilities
├── pkg/                # Public packages
│   ├── auth/           # Authentication utilities
│   ├── logger/         # Logging package
│   └── validator/      # Validation utilities
├── frontend/           # React frontend application
│   ├── public/         # Static files
│   ├── src/            # React source code
│   │   ├── components/ # React components
│   │   ├── context/    # React context
│   │   └── ...         # Other React files
│   └── package.json    # Frontend dependencies
├── api/                # API documentation
│   └── v1/
├── docs/               # Project documentation
├── scripts/            # Build and deployment scripts
├── test/               # Test files
│   ├── unit/           # Unit tests
│   ├── integration/    # Integration tests
│   └── e2e/            # End-to-end tests
├── deployments/        # Deployment configurations
├── go.mod              # Go module file
└── README.md           # This file
```

## Features

- **Clean Architecture**: Separation of concerns with layered architecture
- **Gin Framework**: Fast HTTP web framework
- **GORM**: Object-Relational Mapping for database operations
- **PostgreSQL**: Primary database
- **JWT Authentication**: Token-based authentication
- **Structured Logging**: JSON-formatted logs with logrus
- **Configuration Management**: Environment-based configuration
- **CORS Support**: Cross-Origin Resource Sharing middleware
- **Health Checks**: Built-in health check endpoints
- **Error Handling**: Comprehensive error handling and recovery
- **React Frontend**: Modern web interface with React 18
- **Responsive Design**: Mobile-friendly UI with modern CSS
- **Client-Side Routing**: React Router for seamless navigation

## Getting Started

### Prerequisites

#### Option 1: Local Development
- go 1.25.0 or higher
- PostgreSQL database
- Node.js 16+ and npm (for frontend)
- Make (optional, for build scripts)

#### Option 2: Dev Container (Recommended)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Installation

#### Option 1: Dev Container (Recommended)

1. Clone the repository:
```bash
git clone <repository-url>
cd apacks
```

2. Open in VS Code and install the Dev Containers extension

3. Open Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) and select "Dev Containers: Reopen in Container"

4. Wait for the container to build and start

5. The environment will be automatically set up with all dependencies installed

#### Option 2: Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd apacks
```

2. Install Go dependencies:
```bash
go mod tidy
```

3. Install frontend dependencies:
```bash
cd frontend
npm install
cd ..
```

4. Set up environment variables:
```bash
cp env.example .env
# Edit .env with your configuration
```

5. Run the server:
```bash
go run backend/cmd/server/main.go
```

6. Start the React frontend (in a new terminal):
```bash
cd frontend
npm start
```

### Environment Variables

Create a `.env` file with the following variables:

```env
# Server Configuration
SERVER_PORT=8080
SERVER_HOST=localhost

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=apacks
DB_SSLMODE=disable

# JWT Configuration
JWT_SECRET=your-secret-key
```

## API Endpoints

### Public Endpoints

- `GET /health` - Health check
- `GET /api/v1/ping` - Ping endpoint

### Protected Endpoints

- `GET /api/v1/user` - Get user information (requires JWT token)

## Frontend

The React frontend provides a modern web interface for the application:

- **URL**: http://localhost:3000
- **Features**: User authentication, profile display, responsive design
- **Tech Stack**: React 18, React Router, Context API, modern CSS

See [frontend/README.md](frontend/README.md) for detailed frontend documentation.

## Development

### Quick Start (Dev Container)

If using the dev container, simply run:
```bash
make dev
```

This will start both the Go backend and React frontend automatically.

### Running Tests

```bash
# Run all tests
go test ./...

# Run tests with coverage
go test -cover ./...

# Run specific test
cd backend && go test ./internal/handlers

# Run frontend tests
cd frontend && npm test
```

### Building

```bash
# Build for current platform
go build -o bin/server cmd/server/main.go

# Build for specific platform
GOOS=linux GOARCH=amd64 go build -o bin/server-linux cmd/server/main.go
```

### Code Quality

```bash
# Format code
go fmt ./...

# Run linter
golangci-lint run

# Run vet
go vet ./...
```

## Development Container

This project includes a complete development container setup that provides a consistent environment for both Go and React development.

### Features

- **go 1.25.0** with all essential development tools
- **Node.js 18** with npm and development utilities
- **PostgreSQL 15** database for development
- **VS Code Extensions** pre-installed for Go and React development
- **Docker & Docker Compose** for containerized development

### Getting Started with Dev Container

1. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open the project in VS Code
3. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) and select "Dev Containers: Reopen in Container"
4. Wait for the container to build and start

See [.devcontainer/README.md](.devcontainer/README.md) for detailed documentation.

## Deployment

### Docker

```bash
# Build Docker image
docker build -t apacks-server .

# Run container
docker run -p 8080:8080 apacks-server
```

### Kubernetes

Deployment configurations are available in the `deployments/` directory.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
