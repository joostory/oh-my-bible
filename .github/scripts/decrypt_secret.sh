#!/bin/sh

openssl aes-256-cbc -K $BUILD_KEY -iv $BUILD_IV -a \
  -in android/key.properties.enc -out android/key.properties -d

openssl aes-256-cbc -K $BUILD_KEY -iv $BUILD_IV -a \
  -in android/app/google-services.json.enc -out android/app/google-services.json -d

openssl aes-256-cbc -K $BUILD_KEY -iv $BUILD_IV -a \
  -in android/app/holybible.keystore.enc -out android/app/holybible.keystore -d

openssl aes-256-cbc -K $BUILD_KEY -iv $BUILD_IV -a \
  -in ios/Runner/GoogleService-Info.plist.enc -out ios/Runner/GoogleService-Info.plist -d
