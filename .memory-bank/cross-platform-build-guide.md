# Cross-Platform Build Guide

## Overview
The build system supports **Windows, Linux, and macOS** out of the box. No refactoring needed.

## Build Targets

### macOS (Darwin)
- `opencode-darwin-arm64` - Apple Silicon (M1/M2/M3)
- `opencode-darwin-x64` - Intel Macs
- `opencode-darwin-x64-baseline` - Intel Macs (no AVX2)

### Linux
- `opencode-linux-arm64` - ARM64 (Raspberry Pi, ARM servers)
- `opencode-linux-x64` - Standard x64 (glibc)
- `opencode-linux-x64-baseline` - x64 (no AVX2)
- `opencode-linux-arm64-musl` - ARM64 musl libc
- `opencode-linux-x64-musl` - x64 musl libc
- `opencode-linux-x64-musl-baseline` - x64 musl (no AVX2)

### Windows
- `opencode-windows-arm64` - ARM64 Windows
- `opencode-windows-x64` - Standard x64
- `opencode-windows-x64-baseline` - x64 (no AVX2)

## Build Commands

### Build All Platforms
```bash
cd packages/opencode
bun run build
```

This generates **all 15 targets** listed above.

### Build Current Platform Only (Faster)
```bash
cd packages/opencode
bun run build --single
```

Generates only the binary for your current OS/architecture.

### Build with Sourcemaps
```bash
bun run build --sourcemaps
```

### Build Without Embedding Web UI
```bash
bun run build --skip-embed-web-ui
```

## Output Structure

After building all platforms:
```
dist/
├── opencode-darwin-arm64/
│   └── bin/
│       └── opencode
├── opencode-darwin-x64/
│   └── bin/
│       └── opencode
├── opencode-linux-x64/
│   └── bin/
│       └── opencode
├── opencode-windows-x64/
│   └── bin/
│       └── opencode.exe
└── ... (12 more targets)
```

## macOS-Specific Notes

### Code Signing & Notarization
For distribution on macOS:
1. Binaries are built with `hardenedRuntime: true`
2. Electron app uses `notarize: true` flag
3. Requires Apple Developer ID for production builds

### Running on macOS
```bash
# After building
./dist/opencode-darwin-arm64/bin/opencode --version

# Or install globally
npm install -g ./dist/opencode-darwin-arm64
```

### Native Dependencies
The build automatically handles:
- `@opentui/core` - Terminal UI native bindings
- `@parcel/watcher` - File system watcher (darwin-arm64/x64)
- `@lydell/node-pty` - Pseudo-terminal (for desktop app)

All platform-specific binaries are included via optionalDependencies.

## Platform Detection in Code

The codebase uses proper platform checks:
```typescript
// Path separators
path.join(dir, "file")  // Auto-detects / or \

// Platform-specific logic
if (process.platform === "win32") {
  // Windows-specific
} else if (process.platform === "darwin") {
  // macOS-specific
} else {
  // Linux/Unix
}

// Binary extensions
const ext = process.platform === "win32" ? ".exe" : ""
```

## Troubleshooting

### Build Fails on macOS
```bash
# Ensure Xcode command line tools are installed
xcode-select --install

# Install Bun if not present
curl -fsSL https://bun.sh/install | bash

# Clean and rebuild
rm -rf dist node_modules
bun install
bun run build
```

### Missing Native Modules
```bash
# Reinstall with all platform targets
bun install --os="*" --cpu="*"
```

### Binary Won't Run on macOS
```bash
# Check architecture
uname -m  # arm64 or x86_64

# Match binary to architecture
./dist/opencode-darwin-$(uname -m)/bin/opencode
```

## Desktop App Builds

For the Electron desktop app:

```bash
cd packages/desktop

# Build for current platform
bun run build
bun run package

# Build for specific platform
bun run package:mac    # macOS
bun run package:win    # Windows
bun run package:linux  # Linux
```

Output:
- macOS: `dist/opencode-desktop-darwin-*.dmg`
- Windows: `dist/opencode-desktop-win-*.exe`
- Linux: `dist/opencode-desktop-linux-*.AppImage`

## Release Builds

For production releases (requires `GH_REPO` env var):
```bash
export GH_REPO="colinquek/opencode"
bun run build
```

This will:
1. Build all 15 targets
2. Create `.tar.gz` (Linux) or `.zip` (macOS/Windows) archives
3. Upload to GitHub Releases

## Architecture Decisions

### Why 15 Build Targets?
- **3 OS families**: Windows, Linux, macOS
- **2 CPU architectures**: x64, ARM64
- **Baseline variants**: For older CPUs without AVX2
- **Linux libc variants**: glibc (standard) and musl (Alpine)

### Why Not Use `--single` for Releases?
The `--single` flag builds only for the current platform. This is:
- ✅ Faster for local development
- ❌ Not suitable for releases (need all platforms)

### Why Embedded Web UI?
The default build embeds the web UI into the binary for:
- Single-file distribution
- No external dependencies
- Faster startup (no separate server)

Use `--skip-embed-web-ui` for development to avoid rebuilding the web UI every time.

## References
- Build script: `packages/opencode/script/build.ts`
- Desktop config: `packages/desktop/electron-builder.config.ts`
- Platform checks: `packages/opencode/src/**/*.ts` (search for `process.platform`)
