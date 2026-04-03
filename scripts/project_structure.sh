#!/bin/bash

echo "🚀 Setting up Flutter Project Structure..."

# Check if lib folder exists
if [ ! -d "lib" ]; then
  echo "❌ Error: lib folder not found. Run this inside a Flutter project."
  exit 1
fi

# ---------------- CORE ----------------
mkdir -p lib/core/constants
mkdir -p lib/core/routing
mkdir -p lib/core/services
mkdir -p lib/core/config

touch lib/core/constants/app_colors.dart
touch lib/core/constants/app_assets.dart
touch lib/core/constants/app_fonts.dart
touch lib/core/constants/app_strings.dart
touch lib/core/constants/app_enum.dart

touch lib/core/routing/app_routes.dart
touch lib/core/routing/route_names.dart
touch lib/core/routing/app_router.dart

touch lib/core/services/api_client.dart
touch lib/core/services/api_interceptor.dart

touch lib/core/config/url_config.dart

# ---------------- DATA ----------------
mkdir -p lib/data/models
mkdir -p lib/data/repositories
mkdir -p lib/data/providers

# ---------------- FEATURES ----------------
mkdir -p lib/features/sample_feature/presentation/bloc
mkdir -p lib/features/sample_feature/presentation/view
mkdir -p lib/features/sample_feature/presentation/widgets
mkdir -p lib/features/sample_feature/domain/repositories
mkdir -p lib/features/sample_feature/data

# ---------------- WIDGETS ----------------
mkdir -p lib/widgets/buttons
mkdir -p lib/widgets/inputs
mkdir -p lib/widgets/loaders
mkdir -p lib/widgets/common

echo "✅ Structure created successfully!"
