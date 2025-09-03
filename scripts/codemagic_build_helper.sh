#!/bin/bash

# Codemagic Build Helper Scripts for gazago-app
# This script contains utility functions for the CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Setup Flutter environment
setup_flutter_environment() {
    local flavor=$1
    
    print_info "Setting up Flutter environment for flavor: $flavor"
    
    # Set up local.properties for Android
    echo "flutter.sdk=$HOME/programs/flutter" > "$CM_BUILD_DIR/android/local.properties"
    
    # Get Flutter packages
    print_info "Getting Flutter packages..."
    flutter packages pub get
    
    # Clean previous builds
    print_info "Cleaning previous builds..."
    flutter clean
    
    print_success "Flutter environment setup complete"
}

# Run code analysis
run_analysis() {
    local strict_mode=${1:-false}
    
    print_info "Running Flutter analyze..."
    
    if [ "$strict_mode" = "true" ]; then
        print_info "Running in strict mode (treating warnings as errors)"
        flutter analyze lib/ --fatal-infos
    else
        flutter analyze lib/
    fi
    
    print_success "Code analysis complete"
}

# Run tests
run_tests() {
    local coverage=${1:-false}
    
    print_info "Running Flutter tests..."
    
    if [ "$coverage" = "true" ]; then
        print_info "Running tests with coverage..."
        flutter test --coverage
        
        # Generate coverage report if lcov is available
        if command -v lcov &> /dev/null; then
            print_info "Generating coverage report..."
            genhtml coverage/lcov.info -o coverage/html
        fi
    else
        flutter test
    fi
    
    print_success "Tests complete"
}

# Build Android APK
build_android_apk() {
    local flavor=$1
    local target="lib/main_${flavor}.dart"
    
    print_info "Building Android APK for flavor: $flavor"
    
    flutter build apk \
        --flavor "$flavor" \
        --target "$target" \
        --release \
        --verbose
    
    # Verify APK was created
    local apk_path="build/app/outputs/flutter-apk/app-${flavor}-release.apk"
    if [ -f "$apk_path" ]; then
        print_success "APK build successful: $apk_path"
        
        # Get APK info
        local apk_size=$(du -h "$apk_path" | cut -f1)
        print_info "APK size: $apk_size"
    else
        print_error "APK build failed - file not found: $apk_path"
        exit 1
    fi
}

# Build Android App Bundle
build_android_aab() {
    local flavor=$1
    local target="lib/main_${flavor}.dart"
    
    print_info "Building Android App Bundle for flavor: $flavor"
    
    flutter build appbundle \
        --flavor "$flavor" \
        --target "$target" \
        --release \
        --verbose
    
    # Verify AAB was created
    local aab_path="build/app/outputs/bundle/${flavor}Release/app-${flavor}-release.aab"
    if [ -f "$aab_path" ]; then
        print_success "AAB build successful: $aab_path"
        
        # Get AAB info
        local aab_size=$(du -h "$aab_path" | cut -f1)
        print_info "AAB size: $aab_size"
    else
        print_error "AAB build failed - file not found: $aab_path"
        exit 1
    fi
}

# Build iOS
build_ios() {
    local flavor=$1
    local scheme=$2
    local configuration="Release-${flavor}"
    local target="lib/main_${flavor}.dart"
    local export_options="ios/export_options_${flavor}.plist"
    
    print_info "Building iOS for flavor: $flavor"
    
    # Build Flutter iOS
    print_info "Building Flutter iOS..."
    flutter build ios \
        --flavor "$flavor" \
        --target "$target" \
        --release \
        --no-codesign
    
    # Archive with Xcode
    print_info "Creating iOS archive..."
    xcodebuild -workspace ios/Runner.xcworkspace \
        -scheme "$scheme" \
        -configuration "$configuration" \
        -destination generic/platform=iOS \
        -archivePath build/ios/Runner.xcarchive \
        archive
    
    # Export IPA
    print_info "Exporting IPA..."
    xcodebuild -exportArchive \
        -archivePath build/ios/Runner.xcarchive \
        -exportPath build/ios/ipa \
        -exportOptionsPlist "$export_options"
    
    # Verify IPA was created
    local ipa_path="build/ios/ipa/gazago-app.ipa"
    if [ -f "$ipa_path" ]; then
        print_success "iOS build successful: $ipa_path"
        
        # Get IPA info
        local ipa_size=$(du -h "$ipa_path" | cut -f1)
        print_info "IPA size: $ipa_size"
    else
        print_error "iOS build failed - IPA not found"
        exit 1
    fi
}

# Update version number
update_version() {
    local version=$1
    local build_number=$2
    
    if [ -z "$version" ] || [ -z "$build_number" ]; then
        print_error "Version and build number are required"
        exit 1
    fi
    
    print_info "Updating version to $version+$build_number"
    
    # Update pubspec.yaml
    sed -i.bak "s/^version: .*/version: $version+$build_number/" pubspec.yaml
    
    print_success "Version updated successfully"
}

# Generate changelog
generate_changelog() {
    local from_tag=${1:-$(git describe --tags --abbrev=0)}
    local to_tag=${2:-HEAD}
    
    print_info "Generating changelog from $from_tag to $to_tag"
    
    git log --pretty=format:"- %s (%an)" "$from_tag..$to_tag" > CHANGELOG_TEMP.md
    
    if [ -s CHANGELOG_TEMP.md ]; then
        print_success "Changelog generated successfully"
        cat CHANGELOG_TEMP.md
    else
        print_warning "No changes found between $from_tag and $to_tag"
    fi
}

# Send notification to Slack
send_slack_notification() {
    local webhook_url=$1
    local message=$2
    local color=${3:-"good"}
    
    if [ -z "$webhook_url" ] || [ -z "$message" ]; then
        print_warning "Slack webhook URL or message is missing"
        return
    fi
    
    print_info "Sending Slack notification..."
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{
            \"attachments\": [
                {
                    \"color\": \"$color\",
                    \"text\": \"$message\"
                }
            ]
        }" \
        "$webhook_url"
    
    print_success "Slack notification sent"
}

# Main function to run based on arguments
main() {
    case "$1" in
        "setup")
            setup_flutter_environment "${2:-dev}"
            ;;
        "analyze")
            run_analysis "${2:-false}"
            ;;
        "test")
            run_tests "${2:-false}"
            ;;
        "build-apk")
            build_android_apk "${2:-dev}"
            ;;
        "build-aab")
            build_android_aab "${2:-dev}"
            ;;
        "build-ios")
            build_ios "${2:-dev}" "${3:-dev}"
            ;;
        "update-version")
            update_version "$2" "$3"
            ;;
        "changelog")
            generate_changelog "$2" "$3"
            ;;
        "slack")
            send_slack_notification "$2" "$3" "$4"
            ;;
        *)
            print_info "Usage: $0 {setup|analyze|test|build-apk|build-aab|build-ios|update-version|changelog|slack}"
            print_info "Examples:"
            print_info "  $0 setup dev"
            print_info "  $0 analyze true"
            print_info "  $0 test true"
            print_info "  $0 build-apk prod"
            print_info "  $0 build-ios prod prod"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"