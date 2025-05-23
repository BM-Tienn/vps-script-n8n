#!/bin/bash

# update-services.sh - Script to update n8n, caddy, and portainer services
# Based on the self-hosted-ai-starter-kit

# Exit on error
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    # Read the file line by line and export valid variable assignments
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        if [[ $line =~ ^[[:space:]]*$ || $line =~ ^[[:space:]]*# ]]; then
            continue
        fi
        # Only process lines with an equals sign (variable assignments)
        if [[ $line == *"="* ]]; then
            # Extract variable name (everything before the first =)
            var_name=$(echo "$line" | cut -d= -f1)
            # Extract variable value (everything after the first =)
            var_value=$(echo "$line" | cut -d= -f2-)
            # Export the variable
            export "$var_name"="$var_value"
        fi
    done < .env
fi

echo "=== Updating Services ==="
# We no longer need GPU profiles as Ollama is not used
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

# Use 'none' profile as the default since we only have n8n, caddy, and portainer
profile="none"

echo "Step 1: Stopping all services"
docker compose -p localai -f docker-compose.yml down
# Removing the Supabase reference as we no longer need it
# docker compose -p localai --profile $profile -f docker-compose.yml -f supabase/docker/docker-compose.yml down

echo "Step 2: Pulling latest versions of all containers"
docker compose -p localai -f docker-compose.yml pull
# Removing the Supabase reference as we no longer need it
# docker compose -p localai --profile $profile -f docker-compose.yml -f supabase/docker/docker-compose.yml pull

echo "Step 3: Starting services again"
python3 start_services.py --profile none

echo ""
echo "=== Services Updated and Started ==="
echo ""
echo "Services should now be available at:"

# Check if domain variables are set, otherwise use localhost with ports
if [ -n "$N8N_HOSTNAME" ]; then
    echo "- n8n: https://$N8N_HOSTNAME"
else
    echo "- n8n: http://localhost:5678"
fi

# Comment out services we no longer use
# if [ -n "$WEBUI_HOSTNAME" ]; then
#     echo "- Open WebUI: https://$WEBUI_HOSTNAME"
# else
#     echo "- Open WebUI: http://localhost:3000"
# fi

# if [ -n "$FLOWISE_HOSTNAME" ]; then
#     echo "- Flowise: https://$FLOWISE_HOSTNAME"
# else
#     echo "- Flowise: http://localhost:3001"
# fi

# if [ -n "$SUPABASE_HOSTNAME" ]; then
#     echo "- Supabase: https://$SUPABASE_HOSTNAME"
# else
#     echo "- Supabase: http://localhost:8000"
# fi

# if [ -n "$OLLAMA_HOSTNAME" ]; then
#     echo "- Ollama: https://$OLLAMA_HOSTNAME"
# else
#     echo "- Ollama: http://localhost:11434"
# fi

if [ -n "$PORTAINER_HOSTNAME" ]; then
    echo "- Portainer: https://$PORTAINER_HOSTNAME"
else
    echo "- Portainer: http://localhost:9001"
fi

echo ""
echo "If you've configured domains in the .env file, your services will be available at those domains."
echo ""
