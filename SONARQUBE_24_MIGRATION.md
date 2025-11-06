# SonarQube 24.12 Compatibility Guide

This guide explains how to make the Flutter plugin work with SonarQube 24.12.0.100206 Community Edition.

## What Changed

The plugin has been updated with the following changes to support SonarQube 24.12:

1. **SonarQube API Version**: Updated from 7.9 to 10.8.0.96604
2. **Java Version**: Updated from Java 9 to Java 17 (required by SonarQube 10.x+)
3. **Packaging Plugin**: Updated from 1.18.0.372 to 1.23.0.740
4. **File Suffix Configuration**: Added proper file suffix registration (fixes issue #212)

## Prerequisites

- **Java 17 or higher** (required for SonarQube 10.x+)
- **Maven 3.6+** (for building the plugin)
- **SonarQube 24.12.0.100206** or compatible version

## Building the Plugin

### Option 1: Using the Build Script (Recommended)

```bash
# Install Maven if not already installed
brew install maven

# Run the build script
./build-plugin.sh
```

### Option 2: Manual Build

```bash
# Clean and build the plugin
mvn clean package -DskipTests

# The plugin JAR will be created at:
# sonar-flutter-plugin/target/sonar-flutter-plugin-0.0.5.jar
```

## Installing the Plugin

1. **Copy the plugin** to your SonarQube plugins directory:

   ```bash
   cp sonar-flutter-plugin/target/sonar-flutter-plugin-0.0.5.jar \
      $SONARQUBE_HOME/extensions/plugins/
   ```

2. **Remove old version** (if it exists):

   ```bash
   rm $SONARQUBE_HOME/extensions/plugins/sonar-flutter-plugin-*.jar.old
   ```

3. **Restart SonarQube**:

   ```bash
   # If using SonarQube as a service
   sudo systemctl restart sonarqube
   
   # Or if running manually
   $SONARQUBE_HOME/bin/[OS]/sonar.sh restart
   ```

4. **Verify installation**:
   - Log in to SonarQube web interface
   - Go to Administration → Marketplace → Installed
   - Look for "Flutter" plugin in the list

## Testing the Plugin

Create a simple Flutter project and run analysis:

```bash
# In your Flutter project
flutter pub get
flutter test --machine --coverage > tests.output

# Create sonar-project.properties
cat > sonar-project.properties << EOF
sonar.projectKey=flutter_test
sonar.projectName=Flutter Test
sonar.projectVersion=1.0
sonar.sources=lib,pubspec.yaml
sonar.tests=test
sonar.sourceEncoding=UTF-8
EOF

# Run SonarQube analysis
sonar-scanner
```

## Troubleshooting

### Issue: Plugin fails to load

**Symptoms**: SonarQube logs show plugin loading errors

**Solution**:

- Ensure you're using Java 17 or higher
- Check SonarQube logs at `$SONARQUBE_HOME/logs/sonar.log`
- Verify the plugin JAR is not corrupted

### Issue: Dart files not being analyzed

**Symptoms**: No Dart files appear in SonarQube analysis

**Solution**:

- Ensure `pubspec.yaml` is included in `sonar.sources`
- Add explicit file suffix configuration in `sonar-project.properties`:

  ```properties
  sonar.dart.file.suffixes=.dart
  ```

### Issue: Build fails with Java version error

**Symptoms**: Maven build fails with "unsupported class file version"

**Solution**:

```bash
# Check Java version
java -version

# Should show Java 17 or higher
# If not, install Java 17:
brew install openjdk@17

# Set JAVA_HOME
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
```

## Key Differences from v0.0.4 Release

The changes made for SonarQube 24.12 compatibility:

| Component | v0.0.4 Release | Updated Version |
|-----------|----------------|-----------------|
| SonarQube API | 7.9 | 10.8.0.96604 |
| Java Version | 9 | 17 |
| Packaging Plugin | 1.18.0.372 | 1.23.0.740 |
| File Registration | Basic | Enhanced with suffix config |

## Additional Resources

- [SonarQube Plugin API](https://docs.sonarsource.com/sonarqube/latest/extension-guide/developing-a-plugin/)
- [Flutter Plugin Documentation](https://github.com/insideapp-oss/sonar-flutter)
- [SonarQube 10.x Migration Guide](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/upgrade-the-server/upgrade-guide/)

## Support

If you encounter issues:

1. Check the [GitHub Issues](https://github.com/insideapp-oss/sonar-flutter/issues)
2. Review SonarQube logs for detailed error messages
3. Verify all prerequisites are met (Java 17, Maven, correct SonarQube version)
