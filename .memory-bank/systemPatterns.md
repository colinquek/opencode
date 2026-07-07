# System Patterns: OpenCode Architecture

## System Architecture
OpenCode uses a **monorepo architecture** with Bun + Turbo, organized into layered packages:

```
┌─────────────────────────────────────────┐
│           UI Layer (Frontend)           │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌───────┐ │
│  │ TUI │  │ Web │  │App  │  │Desktop│ │
│  └─────┘  └─────┘  └─────┘  └───────┘ │
├─────────────────────────────────────────┤
│           Server & Protocol             │
│  ┌──────────┐  ┌──────────┐            │
│  │  Server  │  │ Protocol │            │
│  └──────────┘  └──────────┘            │
├─────────────────────────────────────────┤
│              Core Layer                 │
│  ┌──────┐  ┌────────┐  ┌────────────┐ │
│  │Core  │  │ Schema │  │   LLM      │ │
│  └──────┘  └────────┘  └────────────┘ │
└─────────────────────────────────────────┘
```

## Key Technical Decisions

### 1. Dependency Direction
```
Schema → Core → Protocol → Server
              ↓
           Client (depends on Schema + Protocol only)
```
- **Rule**: Client never depends on Core or Server
- **Rationale**: Clean separation between runtime and API layers

### 2. Effect Schema as Canonical Source
- All wire/storage contracts use Effect Schema
- Generated clients from Protocol definitions
- Type-safe throughout the stack

### 3. Session V2 Architecture
- **Durable Prompt Admission**: One `session_input` row before execution
- **Context Epoch**: Immutable baseline for rendering
- **Location-Scoped**: Service resolution per workspace

### 4. Plugin System
- Hot-reload capable
- Plugin-defined context sources
- Registry-based discovery

## Design Patterns

### 1. Self-Export Pattern (Config Modules)
```typescript
// src/config/agent.ts
export * as ConfigAgent from "./agent"
```

### 2. Effect Service Binding
```typescript
// Good: Bind service before calling methods
const foo = yield* Foo.Service
yield* foo.bar()

// Bad: Nested service yields
yield* (yield* Foo.Service).bar()
```

### 3. Functional Array Operations
```typescript
// Prefer map/filter/flatMap with type guards
items.filter((x): x is Foo => isFoo(x)).map(...)
```

### 4. Early Returns Over Else
```typescript
// Good
if (condition) return 1
return 2

// Bad
if (condition) return 1
else return 2
```

## Component Relationships

### Core Packages
- **`opencode/`**: Main CLI app with TUI (SolidJS + opentui)
- **`core/`**: Business logic, session runner, system context, DB schemas
- **`server/`**: HTTP API server (port 4096)
- **`client/`**: Generated HTTP API client (Promise + Effect APIs)
- **`protocol/`**: Protocol definitions and HTTP API contracts
- **`schema/`**: Effect Schema for wire/storage contracts
- **`llm/`**: Provider-neutral LLM interface (20+ providers)

### UI Packages
- **`tui/`**: Terminal UI components and plugins
- **`app/`**: Shared web UI components (SolidJS)
- **`web/`**: Web-specific implementation
- **`desktop/`**: Electron desktop app

### Infrastructure
- **`identity/`**: Authentication and identity
- **`plugin/`**: Plugin system
- **`sdk/`**: JavaScript SDK (legacy + next-gen)

## Critical Implementation Paths

### 1. Session Execution Flow
```
User Input → SessionV2.prompt() → Durable Admission
    → SessionExecution.wake() → Model Resolution
    → Tool Registry → Permission Check → Execution
    → Result Validation → Output
```

### 2. Context Source Pipeline
```
Context Producers → System Context Registry
    → Context Epoch → Session History
    → Model Request (with immutable baseline)
```

### 3. Plugin Loading
```
Plugin Registry Scan → Hot-Reload Watcher
    → Plugin Definition → Context Source Registration
    → Service Resolution (Location-Scoped)
```

## File Organization Principles
- Keep helpers close to main export (below it)
- One function per file unless composable
- Dynamic imports for heavy modules in startup paths
- Avoid nested service yields in Effect generators
