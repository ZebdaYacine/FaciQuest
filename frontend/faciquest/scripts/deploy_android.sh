#!/bin/bash

# Exit on any error
set -e

# ==========================================
# CONFIGURATION - PLEASE UPDATE THESE VALUES
# ==========================================
FIREBASE_APP_ID="1:976687439846:android:9809d10ea3fd52e5844027"
TESTERS_GROUP="testers" # Or comma-separated emails
RELEASE_NOTES="New Android test build"

echo "Building Flutter APK..."
flutter build apk --release

echo "Deploying to Firebase App Distribution..."
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app "$FIREBASE_APP_ID" \
  --release-notes "$RELEASE_NOTES" \
  --groups "$TESTERS_GROUP"

echo "Android Deployment Complete!"
