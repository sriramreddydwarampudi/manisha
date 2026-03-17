#!/bin/bash
# Automated APK builder for Termux

echo "Building APK in Termux..."

# Set environment
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
export PATH=$JAVA_HOME/bin:$PATH

# Update aapt2 in Gradle cache (run every time to be safe)
echo "Updating aapt2 in Gradle cache..."
find ~/.gradle -name 'aapt2-*-linux.jar' -type f 2>/dev/null | xargs -I{} jar -u -f {} -C /usr/bin aapt2 2>/dev/null || true

# Build
echo "Building APK..."
./gradlew clean assembleDebug --no-daemon

# Check result
if [ -f app/build/outputs/apk/debug/app-debug.apk ]; then
    # Copy to Downloads
    cp app/build/outputs/apk/debug/app-debug.apk /storage/emulated/0/Download/
    SIZE=$(ls -lh app/build/outputs/apk/debug/app-debug.apk | awk '{print $5}')
    echo "✅ Success! APK ($SIZE) copied to Downloads folder"
    echo "Install from your phone's Downloads folder"
else
    echo "❌ Build failed - check output above"
fi
