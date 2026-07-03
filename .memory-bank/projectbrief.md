# Project Brief: OpenCode (Sunny Rebrand)

## Project Overview
OpenCode is an open-source AI-powered coding agent providing CLI (TUI), web, and desktop interfaces for AI-assisted development. This fork maintains a **rebranded "Sunny" version** while pulling upstream updates from the source repository.

## Rebranding Scope
**Visual Assets Only** (as of current session):
- `packages/tui/src/logo.ts` - TUI 6-line ASCII art logo (SUNNY)
- `packages/opencode/src/cli/ui.ts` - CLI 4-line wordmark (SUNNY)
- `packages/web/src/assets/logo.svg` - Web UI logo (pending)

**Functional Naming** (NOT YET CHANGED):
- Config paths, env vars, binary names, package names remain "opencode"
- These may be rebranded in future phases

## Fork Strategy
- **Origin**: `https://github.com/colinquek/opencode.git` (your fork)
- **Upstream**: `https://github.com/anomalyco/opencode.git` (source repo)
- **Branch**: `sunnyrebrand` (feature branch)
- **Merge Strategy**: Preserve branding files when pulling upstream updates

## Key Requirements
1. Maintain visual rebranding while syncing with upstream releases
2. Document all branding changes for easy re-application after merges
3. Keep functional naming separate from visual branding
4. Minimal disruption to existing build/test workflows

## Success Criteria
- TUI displays "SUNNY" logo on startup
- CLI shows "SUNNY" wordmark in help output
- Can pull upstream updates without losing branding
- Build process produces branded binaries

## Related Files
- `.gitattributes` - Merge strategy for branding files (TODO: create)
- `scripts/restore-branding.sh` - Automation script (TODO: create)
- `.memory-bank/progress.md` - Detailed implementation status
