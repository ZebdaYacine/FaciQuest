#!/bin/bash

# Exit on any error
set -e

# ==========================================
# CONFIGURATION - PLEASE UPDATE THESE VALUES
# ==========================================
FIREBASE_APP_ID="1:976687439846:ios:cb8f5493da34d207844027"
TESTERS_GROUP="testers" # Or comma-separated emails
RELEASE_NOTES="New iOS test build"

echo "Building Flutter IPA..."
# Note: This will build an ad-hoc IPA which is required for Firebase App Distribution
# Ensure you have a valid Apple Developer account and provisioning profiles set up.
flutter build ipa --release --export-method ad-hoc

echo "Deploying to Firebase App Distribution..."
# The output path might vary slightly depending on your Xcode configuration,
# but it typically defaults to build/ios/ipa/*.ipa
IPA_PATH=$(find build/ios/ipa -name "*.ipa" | head -n 1)

if [ -z "$IPA_PATH" ]; then
    echo "Error: Could not find built IPA file in build/ios/ipa/"
    exit 1
fi

firebase appdistribution:distribute "$IPA_PATH" \
  --app "$FIREBASE_APP_ID" \
  --release-notes "$RELEASE_NOTES" \
  --groups "$TESTERS_GROUP"

echo "iOS Deployment Complete!"
