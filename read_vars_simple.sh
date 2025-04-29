#!/bin/bash

while IFS='=' read -r key value; do
    [[ "$key" =~ ^[[:space:]]*# || -z "$key" ]] && continue
    key=$(echo "$key" | xargs | tr '[:upper:]' '[:lower:]')
    value=$(echo "$value" | xargs)

    filename="${key}-artifact-${value}.zip"
    url="https://your-server.com/artifacts/${filename}"

    echo "Downloading $filename..."
    curl -O "$url" || echo "Failed to download $filename"
done < vars.env
