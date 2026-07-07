# Quick Build Reference Card

## Build All Requested Platforms
```bash
cd packages/opencode
bun run script/build-custom-platforms.ts
```

## Output (6 Binaries)
```
dist/
├── opencode-windows-arm64/bin/opencode.exe      ← Windows ARM
├── opencode-linux-arm64/bin/opencode            ← Linux ARM (glibc)
├── opencode-linux-arm64-musl/bin/opencode       ← Linux ARM (musl/Alpine)
├── opencode-darwin-arm64/bin/opencode           ← macOS Apple Silicon
├── opencode-darwin-x64/bin/opencode             ← macOS Intel
└── opencode-darwin-x64-baseline/bin/opencode    ← macOS Intel (no AVX2)
```

## Test Binaries
```bash
# Current platform (auto-tested during build)
./dist/opencode-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)/bin/opencode --version

# Specific platforms
./dist/opencode-darwin-arm64/bin/opencode --version
./dist/opencode-linux-arm64/bin/opencode --version
./dist/opencode-windows-arm64/bin/opencode.exe --version
```

## Install Locally
```bash
# Linux ARM64
sudo cp dist/opencode-linux-arm64/bin/opencode /usr/local/bin/

# macOS Apple Silicon
sudo cp dist/opencode-darwin-arm64/bin/opencode /usr/local/bin/

# Verify
opencode --version
```

## Create Release Archives
```bash
cd dist

# macOS/Windows (ZIP)
zip -r opencode-darwin-arm64.zip opencode-darwin-arm64/bin/*
zip -r opencode-windows-arm64.zip opencode-windows-arm64/bin/*

# Linux (tar.gz)
tar -czf opencode-linux-arm64.tar.gz opencode-linux-arm64/bin/*
tar -czf opencode-linux-arm64-musl.tar.gz opencode-linux-arm64-musl/bin/*
```

## Upload to GitHub Releases
```bash
export GH_REPO="colinquek/opencode"
gh release upload v1.17.14 dist/*.zip dist/*.tar.gz --clobber
```

## Build Time Estimates
- **First build**: 5-10 minutes
- **Cached build**: 3-5 minutes
- **Per binary**: ~30-60 seconds

## Disk Space Required
- **Total**: ~250-350 MB for all 6 binaries
- **Per binary**: ~40-60 MB average

## Key Files
- **Build script**: `packages/opencode/script/build-custom-platforms.ts`
- **Output**: `packages/opencode/dist/`
- **Documentation**: `BUILD-COMPLETE-SUMMARY.md`

## Troubleshooting
```bash
# Clean rebuild
rm -rf dist node_modules
bun install
bun run script/build-custom-platforms.ts

# macOS: Fix permissions
xattr -cr dist/opencode-darwin-*/bin/opencode

# Linux: Fix permissions
chmod +x dist/opencode-linux-*/bin/opencode
```

---
**Quick Start**: Just run `bun run script/build-custom-platforms.ts` and wait ~5 minutes!
