#!/bin/bash

# Script to apply Safe-ASIC changes to Safe_ASIC-FPGA repository
# 
# Usage: 
#   1. Clone or navigate to your Safe_ASIC-FPGA repository
#   2. Copy this script and the .patch files to the repository root
#   3. Run: ./apply_safe_asic_changes.sh
#   4. Review and test the changes

set -e

echo "Safe-ASIC to Safe_ASIC-FPGA Migration Script"
echo "============================================="
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "ERROR: Not in a git repository. Please run this script from the root of your Safe_ASIC-FPGA repository."
    exit 1
fi

# Create a backup branch
BACKUP_BRANCH="backup-before-safe-asic-migration-$(date +%Y%m%d-%H%M%S)"
echo "Creating backup branch: $BACKUP_BRANCH"
git checkout -b "$BACKUP_BRANCH"
git checkout -

echo ""
echo "Applying patches..."
echo ""

# Apply info.yaml patch
if [ -f "info.yaml" ] && [ -f "info.yaml.patch" ]; then
    echo "Applying info.yaml.patch..."
    patch -p1 < info.yaml.patch
    echo "✓ info.yaml updated"
else
    echo "⚠ Skipping info.yaml (file or patch not found)"
fi

# Apply docs/info.md patch
if [ -f "docs/info.md" ] && [ -f "info.md.patch" ]; then
    echo "Applying info.md.patch..."
    patch -p1 < info.md.patch
    echo "✓ docs/info.md updated"
else
    echo "⚠ Skipping docs/info.md (file or patch not found)"
fi

# Apply IHPfinal.v patch
# First, find the main Verilog file (might have a different name in FPGA repo)
if [ -f "src/IHPfinal.v" ] && [ -f "IHPfinal.v.patch" ]; then
    echo "Applying IHPfinal.v.patch..."
    patch -p1 < IHPfinal.v.patch
    echo "✓ src/IHPfinal.v updated"
else
    echo "⚠ Warning: src/IHPfinal.v not found. You may need to apply IHPfinal.v.patch manually to your main module file."
fi

echo ""
echo "============================================="
echo "Migration complete!"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git diff"
echo "  2. Test compilation/synthesis"
echo "  3. Update any FPGA-specific constraint files for new pin assignments"
echo "  4. Commit changes: git add -A && git commit -m 'Apply Safe-ASIC pin remapping changes'"
echo ""
echo "If something went wrong, restore from backup:"
echo "  git checkout $BACKUP_BRANCH"
echo ""
