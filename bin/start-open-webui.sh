#!/bin/bash

CONTAINER_NAME="open-webui-bundled"
IMAGE_NAME="ghcr.io/open-webui/open-webui:ollama"
PORT="3000"
MODEL="deepseek-r1:7b"

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi


# Check if container exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME already exists."
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Container is already running."
    else
        echo "Starting existing container..."
        docker start "$CONTAINER_NAME"
    fi
else
    # Run the container
    echo "Starting new container..."

    # Check for NVIDIA GPU support
    GPU_FLAG=""
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA GPU detected, enabling GPU support..."
        GPU_FLAG="--gpus=all"
    fi

    docker run -d $GPU_FLAG \
        -p $PORT:8080 \
        -v open-webui:/app/backend/data \
        -v ollama:/root/.ollama \
        --name "$CONTAINER_NAME" \
        --restart always \
        "$IMAGE_NAME"
fi

echo "Waiting for Ollama service to initialize (15s)..."
sleep 15

echo "Pulling model: $MODEL inside the container..."
echo "This may take a while depending on your internet connection."
docker exec -it "$CONTAINER_NAME" ollama pull "$MODEL"

echo ""
echo "-----------------------------------------------------"
echo "Success! Open WebUI is running."
echo "Access it at: http://localhost:$PORT"
echo "The model '$MODEL' should be available in the dropdown."
echo "-----------------------------------------------------"
