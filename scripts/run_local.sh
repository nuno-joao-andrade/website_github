#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Navigate to the project root (parent of scripts directory)
cd "$SCRIPT_DIR/.."

echo "Creating local server configuration..."

# Install/Update dependencies to ensure everything is fresh
echo "Checking dependencies..."
bundle install

# Start the server with live reload enabled
echo "Starting local server at http://localhost:4000..."
bundle exec jekyll serve --livereload
