# Build Plan - Remaining Platforms

**Date**: 2026-07-07  
**Status**: macOS ✅ COMPLETE | Windows ARM64 ⏳ PENDING | Linux ARM64 ⏳ PENDING

---

## Completed Builds

### ✅ macOS (3 binaries)
- opencode-darwin-arm64 (129 MB) - Apple Silicon
- opencode-darwin-x64 (135 MB) - Intel Macs
- opencode-darwin-x64-baseline (135 MB) - Intel baseline

**Archives**: 3 × .tar.gz files created (41-43 MB each)

---

## Pending Builds

### ⏳ Windows ARM64 (1 binary)
**Script**: `packages/opencode/script/build-windows-arm64.ts`  
**Target**: `opencode-windows-arm64`  
**Expected Size**: ~50-65 MB  
**Use Cases**:
- Surface Pro X
- Windows ARM laptops
- Parallels on Apple Silicon (Windows ARM)

**Build Command**:
```bash
cd packages/opencode
bun run script/build-windows-arm64.ts
```

**Output**:
```
dist/opencode-windows-arm64/
└── bin/
    └── opencode.exe
```

---

### ⏳ Linux ARM64 (2 binaries)
**Script**: `packages/opencode/script/build-linux-arm64.ts`  
**Targets**:
- `opencode-linux-arm64` - Standard ARM64 (glibc)
- `opencode-linux-arm64-musl` - Alpine Linux ARM64

**Expected Sizes**:
- glibc: ~40-50 MB
- musl: ~35-45 MB

**Use Cases**:
- Raspberry Pi 4/5 (64-bit)
- AWS Graviton instances
- Azure ARM VMs
- Oracle Cloud ARM instances
- Alpine Linux containers

**Build Command**:
```bash
cd packages/opencode
bun run script/build-linux-arm64.ts
```

**Output**:
```
dist/opencode-linux-arm64/
└── bin/
    └── opencode

dist/opencode-linux-arm64-musl/
└── bin/
    └── opencode
```

---

## Build Scripts Created

1. ✅ `script/build-macos.ts` - macOS build (COMPLETED)
2. ✅ `script/build-windows-arm64.ts` - Windows ARM64 build (READY)
3. ✅ `script/build-linux-arm64.ts` - Linux ARM64 build (READY)

---

## Execution Order

### Option 1: Sequential (Recommended)
```bash
# 1. Build Windows ARM64
bun run script/build-windows-arm64.ts

# 2. Build Linux ARM64
bun run script/build-linux-arm64.ts
```

**Total Time**: ~10-15 minutes (both builds)

### Option 2: Parallel (Faster, more resource-intensive)
```bash
# Terminal 1
bun run script/build-windows-arm64.ts

# Terminal 2
bun run script/build-linux-arm64.ts
```

**Total Time**: ~5-8 minutes (parallel execution)

---

## Post-Build Steps

### Windows ARM64
```bash
# Create ZIP archive
cd dist
zip -r opencode-windows-arm64.zip opencode-windows-arm64/bin/*
```

### Linux ARM64
```bash
# Create tar.gz archives
cd dist
tar -czf opencode-linux-arm64.tar.gz opencode-linux-arm64/bin/*
tar -czf opencode-linux-arm64-musl.tar.gz opencode-linux-arm64-musl/bin/*
```

---

## Final Deliverables

After all builds complete:

### Binaries (6 total)
- ✅ 3 × macOS (darwin-arm64, darwin-x64, darwin-x64-baseline)
- ⏳ 1 × Windows (windows-arm64)
- ⏳ 2 × Linux (linux-arm64, linux-arm64-musl)

### Archives (6 total)
- ✅ 3 × macOS .tar.gz
- ⏳ 1 × Windows .zip
- ⏳ 2 × Linux .tar.gz

### Total Size
- **Uncompressed**: ~550-700 MB
- **Compressed**: ~200-280 MB

---

## Testing Strategy

### Windows ARM64
- Test on Surface Pro X or Windows ARM laptop
- Test in Parallels (Mac M1/M2/M3 running Windows ARM)
- Verify .exe executes correctly

### Linux ARM64
- Test on Raspberry Pi 4/5 (64-bit OS)
- Test on AWS Graviton instance
- Test musl binary on Alpine Linux container

---

## Distribution Plan

### GitHub Releases
```bash
export GH_REPO="colinquek/opencode"
gh release upload v1.17.14 \
  dist/*.tar.gz \
  dist/*.zip \
  --clobber
```

### Documentation
- Update README.md with download links
- Create installation guide for each platform
- Add troubleshooting section

---

## Current Blockers

⏳ **Git pre-push typecheck running**
- Must complete before builds can start
- Estimated: 2-5 minutes
- Running: `bun turbo typecheck`

---

## Next Actions

1. ⏳ Wait for git typecheck to complete
2. ⏳ Run Windows ARM64 build
3. ⏳ Run Linux ARM64 build
4. ⏳ Create archives
5. ⏳ Verify all 6 binaries
6. ⏳ Optional: Upload to GitHub Releases

---

**Status**: WAITING FOR TYPECHECK ⏳  
**Estimated Start**: 2-5 minutes  
**Estimated Completion**: 15-20 minutes (all builds)
