#!/bin/bash

# Declare an associative array to store vars
declare -A vars

# Read key=value pairs from the file
while IFS='=' read -r key value; do
    [[ "$key" =~ ^[[:space:]]*# || -z "$key" ]] && continue  # skip comments/empty
    key=$(echo "$key" | xargs | tr '[:upper:]' '[:lower:]')  # trim & lowercase
    value=$(echo "$value" | xargs)
    vars["$key"]="$value"
done < vars.env

# Loop through and download
for name in "${!vars[@]}"; do
    version="${vars[$name]}"
    filename="${name}-artifact-${version}.zip"
    url="https://your-server.com/path/to/artifacts/${filename}"

    echo "⬇️ Downloading: $filename"
    curl -O "$url" || echo "⚠️ Failed to download $filename"
done

