#!/bin/sh

BUILD_DIR="Build"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

xcodebuild clean archive -project "GPUImage.xcodeproj" -scheme "GPUImage_iOS" -configuration Release -sdk iphonesimulator -destination "generic/platform=iOS Simulator" -archivePath "$BUILD_DIR/GPUImage.iOS-simulator.xcarchive" ONLY_ACTIVE_ARCH=NO SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES || exit 1

xcodebuild clean archive -project "GPUImage.xcodeproj" -scheme "GPUImage_iOS" -configuration Release -sdk iphoneos -destination "generic/platform=iOS" -archivePath "$BUILD_DIR/GPUImage.iOS.xcarchive" ONLY_ACTIVE_ARCH=NO SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES || exit 1


# Find the symbol map file since its name always changes
BCSYMBOLMAP_FILE=$(ls $DIR/$BUILD_DIR/GPUImage.iOS.xcarchive/BCSymbolMaps/*.bcsymbolmap | head -1)

# For some reason we had to include the full path for symbols in order to find them
# Source --> https://developer.apple.com/forums/thread/655768?answerId=624348022#624348022
xcodebuild -create-xcframework -framework "$BUILD_DIR/GPUImage.iOS.xcarchive/Products/Library/Frameworks/GPUImage.framework" -debug-symbols "$DIR/$BUILD_DIR/GPUImage.iOS.xcarchive/dSYMs/GPUImage.framework.dSYM" -debug-symbols $BCSYMBOLMAP_FILE -framework "$BUILD_DIR/GPUImage.iOS-simulator.xcarchive/Products/Library/Frameworks/GPUImage.framework" -debug-symbols "$DIR/$BUILD_DIR/GPUImage.iOS-simulator.xcarchive/dSYMs/GPUImage.framework.dSYM" -output "$BUILD_DIR/GPUImage.xcframework" || exit 1

open $BUILD_DIR
