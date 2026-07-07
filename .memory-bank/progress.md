# Progress: Sunny Rebranding

## Current Status
**Version**: 1.17.14 (rebased onto upstream tag)  
**Branch**: `sunnyrebrand` (feature branch)  
**Last Commit**: 21a32bd42 - merge: upstream dev branch changes onto v1.17.14  
**Rebase Date**: 2026-07-07

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
- **Web Logo** (`packages/web/src/assets/logo.svg`) - PENDING
  - Only remaining visual rebranding task

## What's Left to Build

### Visual Rebranding (Phase 1 - ALMOST COMPLETE)
- [ ] `packages/web/src/assets/logo.svg` - Web UI logo
  - Replace OpenCode logo with Sunny branding
  - Maintain SVG format for scalability
  - **This is the ONLY remaining visual rebranding task**

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
- [ ] Document process in CONTRIBUTING.md or README.md (optional - detailed guide already in memory bank)

### Functional Rebranding (Phase 3 - OPTIONAL)
- [ ] `packages/opencode/package.json` — "name" field and "bin" entry
- [ ] `packages/opencode/src/cli/index.ts` — `.scriptName("sunny")` call
- [ ] `packages/opencode/src/config/config.ts` — config filename (`sunny.json`, `.sunny/`)
- [ ] `packages/opencode/src/global/index.ts` — filesystem paths (`~/.config/sunny/`, etc.)
- [ ] `packages/opencode/src/flag/flag.ts` — env var names (`SUNNY_CONFIG_DIR`)
- [ ] `packages/opencode/script/build.ts` — output binary filename
- [ ] `packages/opencode/src/cli/cmd/tui/` — hardcoded "OpenCode" strings
- [ ] `README.md` — Project name and description

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
- [ ] Build produces working binary
- [ ] Can pull upstream without conflicts
- [ ] All existing tests pass
- [ ] No regression in core functionality

### After Pulling Upstream
- [ ] Branding files preserved (check with `git diff`)
- [ ] Build still succeeds
- [ ] TUI logo renders correctly
- [ ] No new conflicts introduced

## Next Milestone
**Goal**: Complete Phase 2 (Fork Maintenance Setup)  
**ETA**: Next session  
**Dependencies**: None  
**Risk**: Low (git configuration only)
