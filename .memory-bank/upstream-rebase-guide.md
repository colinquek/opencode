# Upstream Rebase Guide - Sunny Rebranding

## Purpose

Document the process for rebasing the `sunnyrebrand` branch onto new upstream tags while preserving visual branding files.

## Prerequisites

- `.gitattributes` configured with `merge=ours` for branding files
- Upstream remote configured: `git remote add upstream https://github.com/anomalyco/opencode.git`
- Clean working directory (no uncommitted changes)

## Files Protected by .gitattributes

```
packages/tui/src/logo.ts merge=ours
packages/opencode/src/cli/ui.ts merge=ours
packages/web/src/assets/logo.svg merge=ours
.memory-bank/ merge=ours
```

## Standard Workflow (Option B - Stash Method)

### Step 1: Fetch Upstream Tags

```bash
cd /mnt/c/code/opencode
git fetch upstream --tags
```

### Step 2: Get Latest Upstream Tag

```bash
# Get the latest tag (automatically finds newest)
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null || git tag -l | sort -V | tail -1)
echo "Latest tag: $LATEST_TAG"

# Alternative: List recent tags and pick manually
git tag -l | sort -V | tail -10

# Or check upstream releases page for latest stable
# https://github.com/anomalyco/opencode/releases
```

**Why:** Automatically finds the most recent tag instead of hardcoding version numbers.

### Step 3: Verify Target Tag Exists

```bash
# Using the LATEST_TAG variable from Step 2
git tag -l | grep "$LATEST_TAG"
# Should output: v1.17.14 (or whatever the latest is)
```

### Step 4: Stash Dev Branch Changes

```bash
git stash push -m "upstream $LATEST_TAG merge changes"
```

**Why:** The merge from upstream/dev creates unstaged changes that block rebase.

### Step 5: Rebase onto Tag

```bash
git rebase $LATEST_TAG
```

**Expected:** Your branding commits are replayed on top of the tag.

### Step 6: Restore Stashed Changes

```bash
git stash pop
```

**Note:** This may create conflicts (UU markers) for files changed between the tag and dev branch.

### Step 7: Resolve Conflicts (Use Tag Version)

```bash
# For all conflicted files, use the tag version:
git diff --name-only --diff-filter=U | xargs -I {} git checkout $LATEST_TAG -- {}
```

**Why:** We want the stable tag version, not the bleeding-edge dev branch changes.

### Step 8: Commit Upstream Changes

```bash
git add .
git commit -m "merge: upstream dev branch changes onto $LATEST_TAG"
```

### Step 9: Verify Commit History

```bash
git log --oneline -5
```

**Expected structure:**
```
<hash> (HEAD -> sunnyrebrand) merge: upstream dev branch changes onto v1.17.14
<hash> rebranded text based logos          ← Your branding
<hash> initial commit                       ← Your setup
<tag>  (tag: $LATEST_TAG) release: <version>   ← New base
<hash> feat(...) upstream commit
```

### Step 10: Force Push to Fork

```bash
git push origin sunnyrebrand --force
```

**Note:** Pre-push hooks will run typecheck. Wait for completion.

**If typecheck fails:** Fix errors before pushing, or use `--no-verify` temporarily (not recommended).

## Alternative Workflow (Option A - Commit First)

If you prefer not to use stash:

```bash
# 1. Fetch and get latest tag
git fetch upstream --tags
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))

# 2. Commit merged changes first
git add .
git commit -m "merge: upstream dev branch changes"

# 3. Rebase onto tag
git rebase $LATEST_TAG

# 4. Force push
git push origin sunnyrebrand --force
```

**Trade-off:** Creates an extra merge commit in history.

## Conflict Resolution Reference

### Scenario: UU (Unmerged) Markers

```bash
# Check conflicts
git status --short | grep "^UU"

# Resolve by taking tag version (use $LATEST_TAG)
git checkout $LATEST_TAG -- <file-path>

# Or take all tag versions at once
git diff --name-only --diff-filter=U | xargs -I {} git checkout $LATEST_TAG -- {}

# Stage resolved files
git add .

# Continue rebase (if still rebasing)
git rebase --continue
```

### Scenario: Rebase Fails with "Unstaged Changes"

```bash
# Option 1: Stash (recommended)
git stash push -m "work in progress"
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
git rebase $LATEST_TAG
git stash pop

# Option 2: Commit
git add .
git commit -m "wip: before rebase"
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
git rebase $LATEST_TAG
```

## Verification Checklist

After rebase, verify:

- [ ] `git log --oneline -3` shows tag as base
- [ ] Branding files intact:
  ```bash
  head -10 packages/tui/src/logo.ts
  head -10 packages/opencode/src/cli/ui.ts
  ```
- [ ] No merge conflicts: `git status --short | grep "^UU"` (should be empty)
- [ ] Typecheck passes: `bun turbo typecheck`
- [ ] Push succeeds: `git push origin sunnyrebrand --force`

## Common Issues & Fixes

### Issue: "Cannot rebase: You have unstaged changes"

**Fix:** Stash or commit changes before rebasing (Step 3 above).

### Issue: "Conflict in packages/tui/src/logo.ts"

**Fix:** This shouldn't happen if `.gitattributes` has `merge=ours`. If it does:
```bash
git checkout HEAD -- packages/tui/src/logo.ts
git add packages/tui/src/logo.ts
git rebase --continue
```

**Note:** If still rebasing and using `$LATEST_TAG`, the conflict should auto-resolve to your version.

### Issue: Typecheck fails during push

**Fix:** Run typecheck manually first:
```bash
bun turbo typecheck
# Fix any errors
git add .
git commit --amend  # If errors were in your commits
git push origin sunnyrebrand --force
```

### Issue: Push rejected even with --force

**Fix:** Check if remote branch is protected. If so, delete and recreate:
```bash
git push origin --delete sunnyrebrand
git push origin sunnyrebrand
```

## When to Rebase

**Recommended triggers:**
- New upstream release tag (auto-detect with `git describe --tags`)
- Before merging critical upstream features
- When dev branch diverges significantly (>100 commits)

**Frequency:** Every 2-4 weeks or per upstream release cycle.

**Quick command to check if rebase needed:**
```bash
# Count commits since latest tag
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
git rev-list --count $LATEST_TAG..HEAD

# If >50 commits, consider rebasing
# If >100 commits, definitely rebase
```

## Post-Rebase Tasks

1. **Update memory bank:** Document what changed in this rebase
2. **Test branding:** Run the CLI/TUI to verify logos display correctly
3. **Update documentation:** If upstream changed any relevant APIs
4. **Notify team:** If working in a team, inform them of the rebase

## Rollback Procedure

If rebase goes wrong:

```bash
# Abort in-progress rebase
git rebase --abort

# Or reset to pre-rebase state (if already pushed)
git fetch origin
git reset --hard origin/sunnyrebrand
```

## Quick Reference: One-Command Rebase

For experienced users, here's the condensed workflow:

```bash
cd /mnt/c/code/opencode

# Fetch and get latest tag
git fetch upstream --tags && \
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
echo "Rebasing onto $LATEST_TAG" && \

# Stash, rebase, restore
git stash push -m "upstream changes" && \
git rebase $LATEST_TAG && \
git stash pop && \

# Resolve conflicts (use tag version)
git diff --name-only --diff-filter=U | xargs -I {} git checkout $LATEST_TAG -- {} && \

# Commit and push
git add . && \
git commit -m "merge: upstream dev branch changes onto $LATEST_TAG" && \
git push origin sunnyrebrand --force
```

**Warning:** This assumes no typecheck errors. If typecheck fails, fix manually before push.

## References

- `.gitattributes` - Merge strategy configuration
- `/memories/repo/sunny-rebranding-fork-strategy.md` - Original fork strategy
- `AGENTS.md` - Communication style and commit conventions
- GitHub Releases: https://github.com/anomalyco/opencode/releases

---

**Last Updated:** 2026-07-07
**Based On:** Rebase onto v1.17.14 (successful execution)
**Template:** Works with any tag via `$LATEST_TAG` variable
**Maintainer:** Sunny Rebranding Team
