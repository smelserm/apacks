#!/bin/bash

# Build script for Apacks Go Server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build variables
BINARY_NAME="apacks-server"
BUILD_DIR="bin"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME=$(date -u '+%Y-%m-%d_%H:%M:%S')
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

echo -e "${GREEN}Building ${BINARY_NAME}...${NC}"
echo -e "${YELLOW}Version: ${VERSION}${NC}"
echo -e "${YELLOW}Build Time: ${BUILD_TIME}${NC}"
echo -e "${YELLOW}Commit Hash: ${COMMIT_HASH}${NC}"

# Create build directory
mkdir -p ${BUILD_DIR}

# Build flags
LDFLAGS="-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME} -X main.CommitHash=${COMMIT_HASH}"

# # Build for current platform
# echo -e "${GREEN}Building for current platform...${NC}"
# go build -ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME} cmd/server/main.go

# # Build for Linux
# echo -e "${GREEN}Building for Linux...${NC}"
# GOOS=linux GOARCH=amd64 go build -ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-linux-amd64 cmd/server/main.go

# Build for macOS
echo -e "${GREEN}Building for macOS...${NC}"
GOOS=darwin GOARCH=amd64 go build -ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-darwin-amd64 backend/cmd/server/main.go

# # Build for Windows
# echo -e "${GREEN}Building for Windows...${NC}"
# GOOS=windows GOARCH=amd64 go build -ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe cmd/server/main.go

echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${YELLOW}Binaries created in ${BUILD_DIR}/ directory${NC}"
