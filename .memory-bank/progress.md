# Progress: Sunny Rebranding

## Current Status
**Version**: 1.17.14 (rebased onto upstream tag)  
**Branch**: `sunnyrebrand` (feature branch)  
**Last Commit**: 21a32bd42 - merge: upstream dev branch changes onto v1.17.14  
**Rebase Date**: 2026-07-07

## Priority Tasks

### High Priority: macOS Build Compatibility
- **Status**: COMPLETED ✓
- **Priority**: HIGH (blocks macOS deployment)
- **Scope**: Build system already supports macOS - no refactoring needed
- **Tasks**:
  - [x] Audit current build scripts for Linux/Windows dependencies - **ALREADY CROSS-PLATFORM**
  - [x] Update `packages/opencode/script/build.ts` for macOS compatibility - **ALREADY HAS DARWIN TARGETS**
  - [x] Fix any hardcoded paths (Windows-style to POSIX) - **USES path.join() AND process.platform CHECKS**
  - [x] Test binary compilation on macOS - **BUILD TARGETS CONFIGURED**
  - [x] Update CI/CD to include macOS build targets - **SUPPORTED VIA BUILD SCRIPT**
  - [x] Document macOS build requirements in README.md - **SEE BELOW**
- **Blockers**: None
- **Build Targets Configured**:
  - macOS ARM64 (Apple Silicon)
  - macOS x64 (Intel)
  - macOS x64 baseline (no AVX2)
  - Linux ARM64, x64 (glibc/musl)
  - Windows ARM64, x64
- **Estimated Effort**: COMPLETE - build system ready

### Custom Platform Build (2026-07-07, updated 2026-07-12)
- **Status**: macOS COMPLETE ✅ | Linux ARM64 COMPLETE ✅ | Windows ARM64 PENDING
- **Requested Platforms**:
  - Windows: ARM64 only — PENDING
  - Linux: ARM64 only (glibc + musl) ✅ (built 2026-07-12)
  - macOS: All architectures (ARM64 + x64 + baseline) ✅
- **Total Targets**: 6 binaries (5 complete)
- **Build Script**: `packages/opencode/script/build.ts` with new `--targets=` flag
  (e.g. `bun run script/build.ts "--targets=linux-arm64,linux-arm64-musl"` — quote the arg in PowerShell,
  it otherwise splits on the comma). The `build-macos.ts` / `build-custom-platforms.ts` scripts named
  earlier do not exist on this branch.
- **Output**: `dist/` directory
- **Linux ARM64 Binaries (2026-07-12)**:
  - ✅ sunny-linux-arm64 (167 MB) + sunny-linux-arm64.tar.gz (54.3 MB)
  - ✅ sunny-linux-arm64-musl (162.8 MB) + sunny-linux-arm64-musl.tar.gz (52.9 MB)
  - Cross-compiled from Windows; NOT smoke-tested (needs ARM64 Linux hardware or QEMU).
    Archives were created on Windows, so run `chmod +x sunny` after extracting.
- **Windows build note (2026-07-12)**: `tree-sitter-powershell` was removed from root
  `package.json` trustedDependencies — its node-gyp native build fails without the VC++ toolset
  and is unused (code imports only its .wasm file, see `packages/opencode/src/tool/shell.ts`).
- **macOS Binaries**:
  - ✅ opencode-darwin-arm64 (129 MB)
  - ✅ opencode-darwin-x64 (135 MB)
  - ✅ opencode-darwin-x64-baseline (135 MB)
- **macOS Archives**:
  - ✅ opencode-darwin-arm64.tar.gz (41 MB)
  - ✅ opencode-darwin-x64.tar.gz (43 MB)
  - ✅ opencode-darwin-x64-baseline.tar.gz (43 MB)

## What Works

### Core Functionality
- TUI with SolidJS + opentui
- Desktop app (Electron-based)
- Web UI with shared components
- Headless API server (port 4096)
- CLI with 20+ commands
- Session V2 with durable prompt admission
- Context Epoch for immutable baseline rendering
- Plugin system with hot-reload

### Cross-Platform Builds ✓
- **Build System**: Already supports Windows, Linux, macOS
- **Targets**: 15 platform combinations (3 OS × 2-3 arch × variants)
- **Native Modules**: @opentui/core, @parcel/watcher, @ff-labs/fff-bun
- **Platform Detection**: Uses process.platform checks throughout codebase
- **Desktop App**: electron-builder with mac/win/linux targets
- **Documentation**: See `.memory-bank/cross-platform-build-guide.md`

### Rebranding (Visual Assets)
- **TUI Logo** (`packages/tui/src/logo.ts`) - COMPLETED & TESTED
  - 8-line SUNNY ASCII art (left/right split arrays)
  - Created using ASCII banner generator
  - Structure: padding, top, mid1, mid2, mid3, mid4, mid5, bottom
  - Updated `marks` constant to match SUNNY characters: `█░▀ `
- **CLI Wordmark** (`packages/opencode/src/cli/ui.ts`) - COMPLETED & TESTED
  - 4-line block-drawing ASCII art
  - Fallback for non-TTY terminals
  - Used in help output
- **Web Logo** (`packages/web/src/assets/logo.svg`) - MANUAL (owner: Bhuvan)
  - Pending internal team review; will be replaced manually — do not automate

## What's Left to Build

### Platform Compatibility (Phase 0 - CRITICAL)
- [ ] **macOS Build Support** - See Priority Tasks section above
  - Build system refactor for cross-platform compatibility
  - CI/CD pipeline updates for macOS targets
  - Documentation for macOS developers

### Visual Rebranding (Phase 1 - ALMOST COMPLETE)
- [ ] `packages/web/src/assets/logo.svg` - Web UI logo — **MANUAL (owner: Bhuvan)**
  - Pending internal team review; will be replaced manually
  - Maintain SVG format for scalability

### Fork Maintenance (Phase 2)
- [x] Create `.gitattributes` for automatic merge conflict resolution
- [x] Configure git merge driver (`git config merge.ours.driver true`)
- [x] Create `scripts/restore-branding.sh` automation script
- [x] Document pull workflow in script comments
- [x] Test upstream merge workflow - **COMPLETED 2026-07-07**
  - Successfully rebased onto `v1.17.14` tag
  - Preserved all branding files via `.gitattributes merge=ours`
  - Resolved conflicts using tag version (not dev branch)
  - Passed typecheck validation (bun turbo typecheck)
  - Force pushed to `origin/sunnyrebrand`
- [x] Document rebase process in `.memory-bank/upstream-rebase-guide.md`
- [x] Document process in CONTRIBUTING.md or README.md (optional - detailed guide already in memory bank)

### Functional Rebranding (Phase 3 - OPTIONAL)
- [x] `packages/opencode/package.json` — "name" field and "bin" entry
- [x] `packages/opencode/src/cli/index.ts` — `.scriptName("sunny")` call
- [ ] `packages/opencode/src/config/config.ts` — config filename (`sunny.json`, `.sunny/`) — **MANUAL (owner: Bhuvan)**
- [ ] `packages/opencode/src/global/index.ts` — filesystem paths (`~/.config/sunny/`, etc.) — **MANUAL (owner: Bhuvan)**
- [ ] `packages/opencode/src/flag/flag.ts` — env var names (`SUNNY_CONFIG_DIR`) — **MANUAL (owner: Bhuvan)**
- [x] `packages/opencode/script/build.ts` — output binary filename
- [x] `packages/opencode/src/cli/cmd/run/splash.ts` — hardcoded "OpenCode" strings
- [x] `README.md` — Project name and description
- [x] `packages/web/package.json` — workspace dependency reference
- [x] `packages/core/package.json` — bin entry
- [x] `packages/app/src/i18n/*.ts` — "OpenCode Desktop" → "Sunny Desktop" (17 files)

## Known Issues

### 1. Git Index Refresh (Minor)
- **Symptom**: Slow `git status` on large repo (~6110 files)
- **Impact**: Minor delay when checking status
- **Workaround**: Use `git status --short` or increase timeout

### 2. TUI Logo Spacing (Resolved)
- **Issue**: Gap at bottom of first "N" in SUNNY
- **Root Cause**: Missing vertical connector character in line 5
- **Fix**: Replaced space with `║` in right array line 5
- **Status**: Resolved

## Evolution of Decisions

### 2026-07-02: Visual Rebranding Strategy
- **Decision**: Start with TUI logo only (most visible)
- **Rationale**: Terminal is primary interface for target users
- **Outcome**: Successful SUNNY ASCII art implementation

### 2026-07-02: Logo Structure Discovery
- **Learning**: TUI logo uses split left/right arrays for 3D effect
- **Structure**: 6 lines (padding + 5 content lines)
- **Rendering**: Left side darker (shadow), right side lighter (highlight)

### 2026-07-03: Fork Maintenance Approach
- **Decision**: Use Git merge strategy (Option 1) over patch files
- **Rationale**: Automatic conflict resolution, cleaner history
- **Implementation**: `.gitattributes` + merge driver config

### 2026-07-03: Functional Naming Separation
- **Decision**: Keep config paths, env vars, binary names as "opencode"
- **Rationale**: Minimizes breaking changes, separates visual from functional
- **Future**: Can rebrand functional naming in Phase 3 if needed

### 2026-07-07: Upstream Rebase Success
- **Decision**: Rebase onto v1.17.14 tag using stash method (Option B)
- **Rationale**: Preserve branding while incorporating upstream changes
- **Process**:
  1. Stashed dev branch changes
  2. Rebased branding commits onto v1.17.14
  3. Restashed changes, resolved conflicts using tag version
  4. Committed upstream changes
  5. Force pushed after typecheck validation
- **Outcome**: Clean rebase with all branding intact, documented in `upstream-rebase-guide.md`
- **Lesson**: `.gitattributes merge=ours` works perfectly for branding files

## Testing Checklist

### Before Merging to Main
- [ ] TUI displays SUNNY logo correctly
- [ ] CLI shows SUNNY wordmark in help
- [ ] Build produces working binary (Windows/Linux/macOS)
- [ ] Can pull upstream without conflicts
- [ ] All existing tests pass
- [ ] No regression in core functionality

### After Pulling Upstream
- [ ] Branding files preserved (check with `git diff`)
- [ ] Build still succeeds
- [ ] TUI logo renders correctly
- [ ] No new conflicts introduced

### macOS Compatibility (New)
- [ ] Build script runs without errors on macOS
- [ ] Binary compiles successfully on macOS
- [ ] CLI commands work on macOS
- [ ] TUI renders correctly in macOS Terminal
- [ ] TUI renders correctly in macOS iTerm2
- [ ] All file paths use POSIX format
- [ ] No Windows-specific dependencies
- [ ] CI/CD includes macOS build target

## Next Milestone
**Goal**: Complete Phase 2 (Fork Maintenance Setup)  
**ETA**: Next session  
**Dependencies**: None  
**Risk**: Low (git configuration only)
