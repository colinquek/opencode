# Product Context: Sunny (Rebranded OpenCode)

## Why This Project Exists
Developers need a personalized, branded AI coding assistant that:
- Provides terminal-first AI assistance with full context awareness
- Supports multiple LLM providers with unified interface
- Maintains session continuity across conversations
- Offers both TUI and web/desktop interfaces

## Problems Solved
1. **Generic Tooling**: Default OpenCode branding doesn't match personal/team identity
2. **Fork Maintenance**: Losing customizations when pulling upstream updates
3. **Visual Consistency**: Need cohesive branding across TUI, CLI, and web interfaces

## How It Should Work
- **TUI**: Display "SUNNY" ASCII art logo on startup (6-line split left/right arrays)
- **CLI**: Show "SUNNY" wordmark in help output (4-line block-drawing characters)
- **Web**: Custom SVG logo in web interface (pending)
- **Updates**: Pull upstream changes automatically while preserving branding

## User Experience Goals
1. **Seamless Branding**: Users see "Sunny" identity throughout the interface
2. **Zero Maintenance Overhead**: Automated merge strategy preserves branding
3. **Up-to-Date**: Always able to pull latest features from upstream
4. **Clean Separation**: Visual branding ≠ functional naming (config paths, env vars, etc.)

## Target Users
- Developers who want a personalized AI coding assistant
- Teams needing custom-branded internal tools
- Anyone maintaining a fork with visual customizations

## Design Principles
- **Minimal Changes**: Only modify visual assets, not core functionality
- **Automated Preservation**: Git merge strategy handles conflicts automatically
- **Documented Process**: Clear instructions for future updates
