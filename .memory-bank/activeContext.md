# Active Context: Sunny Rebranding

## Current Work Focus
**Phase 1: Visual Rebranding (COMPLETED)**
- ✅ TUI logo (`packages/tui/src/logo.ts`) - 6-line SUNNY ASCII art
- ✅ CLI wordmark (`packages/opencode/src/cli/ui.ts`) - 4-line block-drawing logo
- ⏳ Web logo (`packages/web/src/assets/logo.svg`) - pending

**Phase 2: Fork Maintenance Setup (IN PROGRESS)**
- ⏳ Create `.gitattributes` for automatic merge conflict resolution
- ⏳ Document pull workflow in CONTRIBUTING.md
- ⏳ Test upstream merge process

## Recent Changes
- **2026-07-02**: Successfully replaced OPENCODE logo with SUNNY in TUI
  - Structure: left/right arrays, 6 lines each (padding + 5 content lines)
  - Rendering: 3D effect with gray shadow (left) and green highlight (right)
- **2026-07-02**: Updated CLI wordmark in ui.ts
  - 4-line block-drawing ASCII art
  - Fallback for non-TTY terminals
- **2026-07-03**: Created Memory Bank structure

## Next Steps
1. Create `.gitattributes` with merge=ours for branding files
2. Configure git merge driver: `git config merge.ours.driver true`
3. Test pull workflow with upstream
4. Update web logo (SVG)
5. Optional: Rebrand functional naming (config paths, env vars, binary names)

## Active Decisions
- **Keep functional naming as "opencode"** for now (config paths, env vars, package names)
- **Use Git merge strategy** (Option 1) for automatic conflict resolution
- **Document in Memory Bank** rather than duplicating in multiple places

## Important Patterns
- **TUI Logo Structure**:
  ```typescript
  left: [
    "padding line",
    "top of letters",
    "middle of letters",
    "bottom of letters"
  ]
  ```
- **Split Rendering**: Left array = first 25 chars, Right array = next 24 chars
- **Color Gradient**: Left side darker (shadow), right side lighter (highlight)

## Project Insights
- ASCII art rendering is sensitive to exact character spacing
- Block-drawing characters must align perfectly across lines
- Git merge strategy is cleaner than manual patch application
