# Tech Context: OpenCode Development

## Technologies Used

### Core Stack
- **Runtime**: Bun (`bun@1.3.14`)
- **Language**: TypeScript (strict mode)
- **Build Orchestration**: Turbo (`turbo.json`)
- **Package Manager**: Bun workspaces with catalogs

### Frontend
- **TUI**: SolidJS + opentui (terminal UI framework)
- **Web**: SolidJS + Vite
- **Desktop**: Electron
- **State**: Effect for reactive state management

### Backend
- **HTTP Server**: Custom HTTP API server (port 4096)
- **Database**: SQLite with Drizzle ORM + Effect integration
- **Effect**: Full Effect ecosystem for functional programming
- **Schema**: Effect Schema for validation and serialization

### LLM Integration
- **Vercel AI SDK**: 20+ provider support (OpenAI, Anthropic, Google, xAI, etc.)
- **Provider-Neutral**: Unified Model Request Options interface
- **Generation Controls**: Separated from provider implementation

### Testing
- **Unit Tests**: Bun test runner
- **E2E**: Playwright (web), custom harness (TUI)
- **Type Checking**: tsgo (TypeScript Go)

## Development Setup

### Prerequisites
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install dependencies
bun install
```

### Key Commands

**From Root:**
```bash
bun install                    # Install all dependencies
bun dev                        # Run opencode dev server
bun dev:web                    # Run web app dev server
bun dev:desktop                # Run desktop app dev server
bun typecheck                  # Type check all packages
bun lint                       # Run oxlint
```

**From `packages/opencode`:**
```bash
bun run script/build.ts        # Build standalone executable
bun dev                        # Run TUI in dev mode
bun dev serve                  # Start headless API server (port 4096)
bun dev web                    # Server + open web interface
bun test                       # Run tests
bun typecheck                  # Type check with tsgo
```

**From `packages/tui`:**
```bash
# No build/dev scripts (library consumed by other packages)
# Rebuild parent package (opencode) to test changes
```

## Technical Constraints

### 1. Monorepo Structure
- All packages share single `bun.lock`
- Cross-package imports must respect dependency direction
- Generated code in `src/generated/` must not be edited manually

### 2. Build Outputs
- **TUI**: Consumed by `opencode` package (no standalone build)
- **CLI**: Standalone binary in `packages/opencode/dist/`
- **Web**: Vite build output in `packages/app/dist/`
- **Desktop**: Electron bundle in `packages/desktop/dist/`

### 3. Type Checking
- Use `bun typecheck` from package directories, never `tsc` directly
- tsgo used for faster type checking in CI

### 4. Testing
- Tests cannot run from repo root (guard: `do-not-run-tests-from-root`)
- Run from package directories: `cd packages/opencode && bun test`

## Dependencies

### Key Runtime Dependencies
- `effect`: Functional programming framework
- `@effect/schema`: Schema validation and serialization
- `drizzle-orm`: Database ORM
- `ai`: Vercel AI SDK for LLM providers
- `solid-js`: Reactive UI framework
- `opentui`: Terminal UI rendering

### Development Dependencies
- `turbo`: Build orchestration
- `typescript`: Type system
- `tsgo`: TypeScript Go (faster type checking)
- `oxlint`: Fast linter
- `prettier`: Code formatting
- `husky`: Git hooks
- `lint-staged`: Pre-commit linting

## Tool Usage Patterns

### 1. Code Generation
```bash
# After changing Protocol or Server HttpApi
cd packages/client
bun run generate
```

### 2. SDK Regeneration
```bash
# Legacy JavaScript SDK
./packages/sdk/js/script/build.ts
```

### 3. Database Migrations
```bash
# Drizzle migrations (if applicable)
bunx drizzle-kit generate
bunx drizzle-kit migrate
```

### 4. Patch Management
- Patches stored in `patches/` directory
- Applied automatically by Bun on install
- Patch files follow format: `<package>%<version>.patch`

## Environment Variables
```bash
# Configuration (defaults shown)
OPENCODE_CONFIG_DIR=~/.config/opencode
OPENCODE_DATA_DIR=~/.local/share/opencode
OPENCODE_LOG_DIR=~/.local/state/opencode

# API Keys (provider-specific)
OPENAI_API_KEY=...
ANTHROPIC_API_KEY=...
GOOGLE_API_KEY=...
```

## Known Issues / Gotchas

### 1. Slow Git Index Refresh
- Large repo (~6110 files) causes slow `git status`
- Solution: Use `git status --short` or increase timeout

### 2. TUI Logo Rendering
- ASCII art sensitive to exact character spacing
- Left/right arrays must have matching line counts
- Block-drawing characters must align perfectly

### 3. Build Cache
- Turbo caching can cause stale builds
- Solution: `rm -rf dist && bun run build`

### 4. WSL vs PowerShell
- Git operations may behave differently across shells
- Prefer WSL for consistency with CI/CD

## CI/CD Pipeline
- **Lint**: oxlint on all packages
- **Type Check**: tsgo via `bun typecheck`
- **Test**: Bun test runner (package-specific)
- **Build**: Turbo orchestration
- **Publish**: Custom scripts in `script/publish`
