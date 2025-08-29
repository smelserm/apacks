#!/bin/bash

# Development script to run both backend and client

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Apacks Development Environment${NC}"
echo -e "${YELLOW}This will start both the Go backend and React client${NC}"
echo ""

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${YELLOW}Error: Go is not installed${NC}"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Error: Node.js is not installed${NC}"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}Error: npm is not installed${NC}"
    exit 1
fi

echo -e "${BLUE}Installing client dependencies...${NC}"
cd client
npm install
cd ..

echo ""
echo -e "${GREEN}Starting services...${NC}"
echo -e "${YELLOW}Backend will run on: http://localhost:8080${NC}"
echo -e "${YELLOW}Client will run on: http://localhost:3000${NC}"
echo ""

# Function to cleanup background processes
cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down services...${NC}"
    kill $BACKEND_PID $CLIENT_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Start backend in background
echo -e "${BLUE}Starting Go backend...${NC}"
go run cmd/server/main.go &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 2

# Start client in background
echo -e "${BLUE}Starting React client...${NC}"
cd client
npm start &
CLIENT_PID=$!
cd ..

echo ""
echo -e "${GREEN}Both services are starting up...${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop both services${NC}"
echo ""

# Wait for both processes
wait $BACKEND_PID $CLIENT_PID
