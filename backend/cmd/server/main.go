package main

import (
	"apacks/backend/internal/api"
	"apacks/backend/internal/config"
	"apacks/backend/pkg/logger"
)

func main() {
	// Initialize logger
	logger := logger.New()

	// Load configuration
	cfg, err := config.Load()
	if err != nil {
		logger.Fatal("Failed to load configuration", err)
	}

	// Initialize and start server
	server := api.NewServer(cfg, logger)

	logger.Info("Starting server on port: %s", cfg.Server.Port)
	if err := server.Start(); err != nil {
		logger.Fatal("Failed to start server", err)
	}
}
