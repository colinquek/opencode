#!/bin/bash

# Build all platforms: Windows, Linux, macOS
# Usage: ./scripts/build-all-platforms.sh

set -e

echo "=========================================="
echo "Building OpenCode for All Platforms"
echo "=========================================="
echo ""

cd "$(dirname "$0")/.."

# Check if Bun is installed
if ! command -v bun &> /dev/null; then
    echo "❌ Bun is not installed. Install it first:"
    echo "   curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

echo "✓ Bun version: $(bun --version)"
echo ""

# Navigate to opencode package
cd packages/opencode

echo "=========================================="
echo "Step 1: Install Dependencies"
echo "=========================================="
echo "Installing cross-platform native modules..."
bun install --os="*" --cpu="*" @opentui/core
bun install --os="*" --cpu="*" @parcel/watcher
bun install --os="*" --cpu="*" @ff-labs/fff-bun
echo "✓ Dependencies installed"
echo ""

echo "=========================================="
echo "Step 2: Build All Platform Binaries"
echo "=========================================="
echo "This will create 15 build targets:"
echo "  - macOS: arm64, x64, x64-baseline"
echo "  - Linux: arm64, x64, x64-baseline, musl variants"
echo "  - Windows: arm64, x64, x64-baseline"
echo ""
echo "Starting build..."
echo ""

# Run the build (without --single flag to build all platforms)
bun run script/build.ts

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo ""
echo "Output directory: dist/"
echo ""
echo "Available binaries:"
ls -lh dist/ | grep "^d" | awk '{print "  - " $9}'
echo ""

# Show platform-specific binaries
for platform in darwin linux windows; do
    echo "$platform binaries:"
    ls -lh dist/opencode-${platform}-*/bin/opencode* 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}' || echo "  (none found)"
    echo ""
done

echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo "1. Test binaries on respective platforms"
echo "2. For release: export GH_REPO and run build again"
echo "3. Binaries will be uploaded to GitHub Releases"
echo ""
echo "Example test command:"
echo "  ./dist/opencode-darwin-arm64/bin/opencode --version"
echo ""
