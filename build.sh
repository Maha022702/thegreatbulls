#!/bin/bash
set -e

echo "=== Starting Fresh Build ==="
echo "Current directory: $(pwd)"
echo "Listing files:"
ls -la

# FORCE clean everything
echo "Cleaning ALL build artifacts..."
rm -rf build 2>/dev/null || true
rm -rf .dart_tool 2>/dev/null || true
rm -rf flutter 2>/dev/null || true

# Install Flutter fresh
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Verify Flutter installation
echo "Flutter version:"
flutter --version

# Disable analytics
flutter config --no-analytics

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build for web (release mode)
echo "Building for web..."
flutter build web --release

echo "=== Build Output ==="
ls -la build/web/
echo "=== Build completed successfully! ==="

echo "Build completed successfully!"