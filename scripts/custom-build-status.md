# Custom Platform Build - 2026-07-07

## Build Configuration

**Requested Platforms:**
- ✅ Windows: ARM64 only
- ✅ Linux: ARM64 only (glibc + musl)
- ✅ macOS: All architectures (ARM64 + x64 + x64 baseline)

**Total Targets:** 6 binaries

## Build Targets

### Windows (1 target)
- `opencode-windows-arm64` - Windows on ARM devices (Surface Pro X, etc.)

### Linux (2 targets)
- `opencode-linux-arm64` - Standard ARM64 (Raspberry Pi 4, ARM servers, AWS Graviton)
- `opencode-linux-arm64-musl` - Alpine Linux ARM64

### macOS (3 targets)
- `opencode-darwin-arm64` - Apple Silicon (M1/M2/M3 Macs)
- `opencode-darwin-x64` - Intel Macs
- `opencode-darwin-x64-baseline` - Intel Macs without AVX2 support

## Build Command

```bash
cd packages/opencode
bun run script/build-custom-platforms.ts
```

## Expected Output

```
dist/
├── opencode-windows-arm64/
│   └── bin/
│       └── opencode.exe
├── opencode-linux-arm64/
│   └── bin/
│       └── opencode
├── opencode-linux-arm64-musl/
│   └── bin/
│       └── opencode
├── opencode-darwin-arm64/
│   └── bin/
│       └── opencode
├── opencode-darwin-x64/
│   └── bin/
│       └── opencode
└── opencode-darwin-x64-baseline/
    └── bin/
        └── opencode
```

## Build Process

1. **Web UI Bundle** - Embeds web app into binary (~30-60 seconds)
2. **Dependency Installation** - Cross-platform native modules
3. **Binary Compilation** - 6 targets built sequentially
4. **Smoke Test** - Tests binary for current platform
5. **Package Metadata** - Creates package.json for each target

## Estimated Build Time

- **First build**: 5-10 minutes (includes dependency download)
- **Cached build**: 3-5 minutes
- **Per target**: ~30-60 seconds each

## Use Cases

### Windows ARM64
- Surface Pro X
- Windows on ARM laptops
- ARM-based Windows tablets
- Parallels on Apple Silicon (running Windows ARM)

### Linux ARM64
- Raspberry Pi 4/5 (64-bit OS)
- AWS Graviton instances
- Azure ARM VMs
- Oracle Cloud ARM instances
- ARM-based home servers

### macOS ARM64 (Apple Silicon)
- MacBook Air M1/M2/M3
- MacBook Pro M1/M2/M3
- iMac M1/M3
- Mac mini M1/M2
- Mac Studio M1/M2
- MacBook Pro M4 (future)

### macOS x64 (Intel)
- MacBook Pro (Intel, 2019 and earlier)
- MacBook Air (Intel, 2020 and earlier)
- iMac (Intel, 2020 and earlier)
- Mac mini (Intel, 2020 and earlier)
- Mac Pro (Intel, 2019 and earlier)

## Why Not x64 for Windows/Linux?

**Decision Rationale:**
- **Windows ARM64**: Growing market (Surface devices, ARM laptops), can run x64 apps via emulation
- **Linux ARM64**: Dominant in cloud (Graviton, ARM servers), Raspberry Pi, edge computing
- **macOS**: Need both ARM64 (new Macs) and x64 (legacy Intel Macs) for full coverage

**Benefits:**
- Faster build times (6 targets vs 15)
- Smaller distribution size
- Focus on most relevant architectures
- ARM is the future (better performance/watt)

## Testing

### Windows ARM64
```powershell
# On Windows ARM device
.\dist\opencode-windows-arm64\bin\opencode.exe --version
```

### Linux ARM64
```bash
# On Raspberry Pi or ARM server
./dist/opencode-linux-arm64/bin/opencode --version

# On Alpine Linux
./dist/opencode-linux-arm64-musl/bin/opencode --version
```

### macOS
```bash
# Apple Silicon
./dist/opencode-darwin-arm64/bin/opencode --version

# Intel Mac
./dist/opencode-darwin-x64/bin/opencode --version
```

## Distribution

### Manual Installation
```bash
# Extract archive
tar -xzf opencode-linux-arm64.tar.gz
sudo mv opencode /usr/local/bin/

# Verify
opencode --version
```

### npm Installation
```bash
# Install from local build
npm install -g ./dist/opencode-linux-arm64
```

### GitHub Releases
When `GH_REPO` is set:
```bash
export GH_REPO="colinquek/opencode"
bun run script/build-custom-platforms.ts

# Automatically uploads:
# - opencode-windows-arm64.zip
# - opencode-linux-arm64.tar.gz
# - opencode-linux-arm64-musl.tar.gz
# - opencode-darwin-arm64.zip
# - opencode-darwin-x64.zip
# - opencode-darwin-x64-baseline.zip
```

## Build Status

**Started**: 2026-07-07  
**Status**: IN PROGRESS  
**Progress**: Web UI building → Binary compilation → Smoke tests

## Next Steps

After build completes:

1. ✅ Verify all 6 binaries are created
2. ✅ Test on actual hardware (if available)
3. ✅ Check file sizes
4. ⏳ Upload to GitHub Releases (optional)
5. ⏳ Update README with download links

## Notes

- Build script is reusable for future builds
- Can add/remove targets by editing `build-custom-platforms.ts`
- Baseline variants included for maximum compatibility
- Musl variant for Alpine Linux container compatibility
