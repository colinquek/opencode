#!/bin/bash
# Restore Sunny branding after pulling upstream changes
# 
# RECOMMENDED WORKFLOW (No Force Push):
#
#   # First-time setup (run once)
#   git remote set-url origin https://github.com/colinquek/opencode.git
#   git remote add upstream https://github.com/anomalyco/opencode.git
#
#   # Pull upstream changes (use this whenever updating)
#   git fetch upstream
#   git merge upstream/dev
#   # .gitattributes auto-preserves branding files (merge=ours)
#   git push origin sunnyrebrand
#
# This keeps your branding intact without force pushing!
#
# Usage: ./scripts/restore-branding.sh

set -e

echo "Setting up remotes..."

# Set up remotes (safe to run multiple times)
git remote set-url origin https://github.com/colinquek/opencode.git
git remote add upstream https://github.com/anomalyco/opencode.git 2>/dev/null || echo "Upstream remote already exists"

echo "Remotes configured:"
git remote -v | grep -E "(origin|upstream)" | head -4

echo ""
echo "Pulling latest from upstream..."
git fetch upstream

echo ""
echo "Merging upstream changes (branding auto-preserved)..."
git merge upstream/dev

echo ""
echo "Restoring Sunny branding files..."

# Restore branding files from current branch (backup in case merge didn't preserve)
git checkout HEAD -- packages/tui/src/logo.ts
git checkout HEAD -- packages/opencode/src/cli/ui.ts
# git checkout HEAD -- packages/web/src/assets/logo.svg 2>/dev/null || echo "Web logo not found, skipping..."

echo "Branding restored!"
echo ""
echo "Next steps:"
echo "1. Verify changes: git status"
echo "2. Commit if needed: git commit -m 'chore: restore Sunny branding'"
echo "3. Push: git push origin sunnyrebrand"
