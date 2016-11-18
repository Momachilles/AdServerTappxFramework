#!/bin/bash

# Merge Script

# 1
# Set bash script to exit immediately if any commands fail.
set -e

# Set the command line tools to Xcode 7.3.1
# sudo -S xcode-select -s /Applications/Xcode\ 7.3.1.app/Contents/Developer/

# 2
# Setup some constants for use later on.
PROJECT_NAME=$(find  *.xcodeproj -type d -depth 0)
FRAMEWORK_NAME=${PROJECT_NAME%.*}
echo "FRAMEWORK: ${FRAMEWORK_NAME}"
echo "============================================"
echo
#CONFIGURATION="Debug"
CONFIGURATION="Release"

TARGET=$FRAMEWORK_NAME
SRCROOT=$(xcodebuild -project $PROJECT_NAME -target $TARGET -configuration $CONFIGURATION -showBuildSettings | grep SRCROOT | cut -d'=' -f2 | sed -e 's/^[[:space:]]*//')
echo $SRCROOT
BUILD_PATH=${SRCROOT}/build

# 3
# If remnants from a previous build exist, delete them.
echo "Deleting previous builds in '$BUILD_PATH'"
if [ -d "$BUILD_PATH" ]; then
rm -rf "$BUILD_PATH"
fi

# 4
# Build the framework for device and for simulator (using
# all needed architectures).
xcodebuild clean build -target "${FRAMEWORK_NAME}" -configuration $CONFIGURATION -arch i386 -arch x86_64 only_active_arch=no defines_module=yes -iphoneos_deployment_target=7.0 -SHALLOW_BUNDLE=NO ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=YES -sdk "iphonesimulator"

# Set the command line tools to Xcode 8
# sudo -S xcode-select -s /Applications/Xcode.app/Contents/Developer/
