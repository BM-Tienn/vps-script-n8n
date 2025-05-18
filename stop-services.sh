#!/bin/bash

# stop-services.sh - Script to stop n8n, caddy, and portainer services
# Based on the self-hosted-ai-starter-kit

# Exit on error
set -e

echo "=== Stopping Services ==="
# No longer need GPU profile selection as Ollama is removed
# echo "Choose your GPU profile:"
# echo "1) NVIDIA GPU"
# echo "2) AMD GPU (Linux only)"
# echo "3) CPU only (no GPU acceleration)"
# echo "4) No Ollama in Docker"

# read -p "Enter your choice (1-4): " gpu_choice

# case $gpu_choice in
#     1)
#         profile="gpu-nvidia"
#         ;;
#     2)
#         profile="gpu-amd"
#         ;;
#     3)
#         profile="cpu"
#         ;;
#     4)
#         profile="none"
#         ;;
#     *)
#         echo "Invalid choice. Defaulting to CPU profile..."
#         profile="cpu"
#         ;;
# esac

# Always use 'none' profile as we don't have Ollama
profile="none"

echo "Stopping all services"
# Remove Supabase reference and profile flag
docker compose -p localai -f docker-compose.yml down
# Original command:
# docker compose -p localai --profile $profile -f docker-compose.yml -f supabase/docker/docker-compose.yml down

echo ""
echo "=== All Services Stopped ==="
echo ""
