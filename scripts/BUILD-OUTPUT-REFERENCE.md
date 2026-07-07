# Build Output Reference

## Expected Build Artifacts

After running `bun run build` (without `--single` flag), you should see:

### macOS Binaries (3 targets)
```
dist/opencode-darwin-arm64/bin/opencode      # Apple Silicon (M1/M2/M3)
dist/opencode-darwin-x64/bin/opencode        # Intel Macs
dist/opencode-darwin-x64-baseline/bin/opencode  # Intel (no AVX2)
```

### Linux Binaries (6 targets)
```
dist/opencode-linux-arm64/bin/opencode           # ARM64 (Raspberry Pi, etc.)
dist/opencode-linux-x64/bin/opencode             # Standard x64 (glibc)
dist/opencode-linux-x64-baseline/bin/opencode    # x64 (no AVX2)
dist/opencode-linux-arm64-musl/bin/opencode      # ARM64 musl (Alpine)
dist/opencode-linux-x64-musl/bin/opencode        # x64 musl (Alpine)
dist/opencode-linux-x64-musl-baseline/bin/opencode  # x64 musl (no AVX2)
```

### Windows Binaries (3 targets)
```
dist/opencode-windows-arm64/bin/opencode.exe      # ARM64 Windows
dist/opencode-windows-x64/bin/opencode.exe        # Standard x64
dist/opencode-windows-x64-baseline/bin/opencode.exe  # x64 (no AVX2)
```

### Release Archives (if GH_REPO is set)
```
dist/opencode-darwin-arm64.zip
dist/opencode-darwin-x64.zip
dist/opencode-darwin-x64-baseline.zip
dist/opencode-linux-arm64.tar.gz
dist/opencode-linux-x64.tar.gz
dist/opencode-linux-x64-baseline.tar.gz
dist/opencode-linux-arm64-musl.tar.gz
dist/opencode-linux-x64-musl.tar.gz
dist/opencode-linux-x64-musl-baseline.tar.gz
dist/opencode-windows-arm64.zip
dist/opencode-windows-x64.zip
dist/opencode-windows-x64-baseline.zip
```

## Desktop App Builds

Separate from CLI binaries, the Electron desktop app produces:

### macOS
```
dist/opencode-desktop-darwin-arm64.dmg    # Apple Silicon installer
dist/opencode-desktop-darwin-x64.dmg      # Intel installer
dist/opencode-desktop-darwin-*.zip        # Portable zip
```

### Windows
```
dist/opencode-desktop-win-x64.exe         # NSIS installer
dist/opencode-desktop-win-arm64.exe       # ARM64 installer
```

### Linux
```
dist/opencode-desktop-linux-x64.AppImage  # Universal AppImage
dist/opencode-desktop-linux-x64.deb       # Debian/Ubuntu package
dist/opencode-desktop-linux-x64.rpm       # Fedora/RHEL package
```

## File Sizes (Approximate)

Based on typical Bun-compiled binaries:

- **macOS**: ~40-60 MB per binary
- **Linux**: ~35-50 MB per binary
- **Windows**: ~45-65 MB per binary (includes .exe wrapper)

Total for all 15 targets: **~600-900 MB**

## Verification Commands

### Check Binary Architecture
```bash
# macOS
file dist/opencode-darwin-*/bin/opencode

# Linux
file dist/opencode-linux-*/bin/opencode

# Windows (from WSL)
file dist/opencode-windows-*/bin/opencode.exe
```

### Test Execution
```bash
# Current platform
./dist/opencode-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)/bin/opencode --version

# Specific platform
./dist/opencode-darwin-arm64/bin/opencode --version
./dist/opencode-linux-x64/bin/opencode --version
```

### Check Dependencies (Linux/macOS)
```bash
# macOS
otool -L dist/opencode-darwin-*/bin/opencode

# Linux
ldd dist/opencode-linux-*/bin/opencode
```

## Build Time Estimates

On a typical development machine:

- **First build** (with dependencies): ~5-10 minutes
- **Subsequent builds** (cached): ~2-5 minutes
- **Single platform** (`--single` flag): ~1-2 minutes

Factors affecting build time:
- Network speed (downloading Bun artifacts)
- CPU cores (parallel compilation)
- Web UI embedding (adds ~30-60 seconds)
- Sourcemaps (adds ~20-30% to build time)

## Common Issues

### "Command not found: bun"
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash
```

### "Cannot find module '@opentui/core'"
```bash
# Install cross-platform dependencies
bun install --os="*" --cpu="*"
```

### "Build failed: ENOENT"
```bash
# Clean and rebuild
rm -rf dist node_modules
bun install
bun run build
```

### "Binary won't execute on macOS"
```bash
# macOS may block unsigned binaries
xattr -cr dist/opencode-darwin-*/bin/opencode

# Or use codesign for development
codesign --sign - dist/opencode-darwin-*/bin/opencode
```

## Distribution

### Manual Installation
```bash
# Extract and move to PATH
tar -xzf dist/opencode-linux-x64.tar.gz
sudo mv opencode /usr/local/bin/

# Verify
opencode --version
```

### npm/npx Installation
```bash
# After building, the dist folders are npm packages
npm install -g ./dist/opencode-darwin-arm64
```

### GitHub Releases
```bash
# Set repository and build
export GH_REPO="colinquek/opencode"
bun run build

# Binaries automatically uploaded to GitHub Releases
```

## Platform-Specific Notes

### macOS
- Requires Xcode command line tools for native modules
- Binaries may need `xattr -cr` to run on first use
- Notarization required for distribution outside App Store

### Linux
- glibc binaries work on most distros (Ubuntu, Debian, Fedora, etc.)
- musl binaries for Alpine Linux and containers
- AppImage works on most modern distros

### Windows
- Requires Windows 10/11
- Defender may flag unsigned binaries
- NSIS installer provides better UX than zip extraction
