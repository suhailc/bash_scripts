#!/bin/bash

# Usage: ./compare_env_files.sh file1.env file2.env
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <env_file_1> <env_file_2>"
    exit 1
fi

file1="$1"
file2="$2"

# Load files into associative arrays
declare -A env1 env2

# Function to read vars from a file into an associative array
read_env_file() {
    local file="$1"
    local -n env_array=$2
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^[[:space:]]*# || -z "$key" ]] && continue
        key=$(echo "$key" | xargs)   # trim
        value=$(echo "$value" | xargs)
        env_array["$key"]="$value"
    done < "$file"
}

read_env_file "$file1" env1
read_env_file "$file2" env2

# Compare variables
echo "🔍 Comparing environment files: $file1 vs $file2"

for key in "${!env1[@]}"; do
    if [[ -z "${env2[$key]+_}" ]]; then
        echo "❌ Removed: $key=${env1[$key]}"
    elif [[ "${env1[$key]}" != "${env2[$key]}" ]]; then
        echo "🔄 Changed: $key"
        echo "   Old: ${env1[$key]}"
        echo "   New: ${env2[$key]}"
    fi
done

for key in "${!env2[@]}"; do
    if [[ -z "${env1[$key]+_}" ]]; then
        echo "➕ Added: $key=${env2[$key]}"
    fi
done

