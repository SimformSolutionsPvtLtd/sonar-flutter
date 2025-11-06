#!/bin/bash

# Build script for SonarQube Flutter Plugin
# This script builds the plugin compatible with SonarQube 24.12+

echo "=========================================="
echo "Building SonarQube Flutter Plugin"
echo "=========================================="

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven is not installed."
    echo "Please install Maven first:"
    echo "  brew install maven"
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "Error: Java 17 or higher is required."
    echo "Current Java version: $JAVA_VERSION"
    exit 1
fi

echo "Java version: OK"
echo "Maven version: $(mvn -version | head -n 1)"
echo ""

# Clean and build
echo "Building plugin..."
mvn clean package -DskipTests

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Build successful!"
    echo "=========================================="
    echo ""
    echo "Plugin location:"
    echo "  $(pwd)/sonar-flutter-plugin/target/sonar-flutter-plugin-0.0.5.jar"
    echo ""
    echo "To install the plugin:"
    echo "  1. Copy the JAR file to: \$SONARQUBE_HOME/extensions/plugins/"
    echo "  2. Restart SonarQube"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "Build failed!"
    echo "=========================================="
    exit 1
fi
