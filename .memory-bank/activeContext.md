# Active Context: Sunny Rebranding

## Current Work Focus
**Phase 1: Visual Rebranding (95% COMPLETE)**
- TUI logo (`packages/tui/src/logo.ts`) - 8-line SUNNY ASCII art
  - Generated using ASCII banner generator
  - Left/right arrays with 8 lines each
  - Updated `marks` constant to match SUNNY characters (`█░▀ `)
- CLI wordmark (`packages/opencode/src/cli/ui.ts`) - 4-line block-drawing logo
- Web logo (`packages/web/src/assets/logo.svg`) - pending (ONLY REMAINING TASK)

**Phase 2: Fork Maintenance Setup (COMPLETE)**
- Created `.gitattributes` for automatic merge conflict resolution
- Configured git merge driver: `git config merge.ours.driver true`
- Created `scripts/restore-branding.sh` automation script
- Documented pull workflow with no force-push strategy
- Set up remotes: origin (colinquek/opencode), upstream (anomalyco/opencode)

## Recent Changes
- **2026-07-03**: Updated TUI logo to 8-line SUNNY ASCII art
  - Used ASCII banner generator for professional text-style logo
  - Structure: 8 lines (left/right arrays) with proper spacing
  - Updated `marks` constant from `_^~,` to `█░▀ ` to match SUNNY characters
- **2026-07-03**: Successfully tested text-based rebranding
  - TUI displays SUNNY logo on startup
  - CLI shows SUNNY wordmark in help output
  - Build process works with `--single` flag for faster iteration
- **2026-07-03**: Completed fork maintenance setup
  - `.gitattributes` configured with merge=ours for branding files
  - Git merge driver configured for automatic conflict resolution
  - Restore script created for manual branding restoration if needed
- **2026-07-02**: Successfully replaced OPENCODE logo with SUNNY in TUI (initial 6-line version)
  - Structure: left/right arrays, 6 lines each (padding + 5 content lines)
  - Rendering: 3D effect with gray shadow (left) and green highlight (right)
- **2026-07-02**: Updated CLI wordmark in ui.ts
  - 4-line block-drawing ASCII art
  - Fallback for non-TTY terminals
- **2026-07-03**: Created Memory Bank structure

## Next Steps
1. Create SVG logo for web UI (`packages/web/src/assets/logo.svg`)
2. Optional: Add documentation to CONTRIBUTING.md about pull workflow
3. Test upstream merge process when new upstream release is available
4. Optional: Rebrand functional naming (config paths, env vars, binary names)

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
