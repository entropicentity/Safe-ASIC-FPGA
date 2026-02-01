# Summary: Safe-ASIC to Safe_ASIC-FPGA Migration

## Overview

This PR contains a complete migration package to copy all the pin remapping changes from the Safe-ASIC repository (PR #1) to your Safe_ASIC-FPGA repository.

## What's Included

### Documentation
1. **README_MIGRATION.md** - Complete guide to using this migration package
2. **MIGRATION_TO_SAFE_ASIC_FPGA.md** - Detailed technical documentation of all changes
3. **QUICK_REFERENCE.md** - Quick lookup for pin mappings before/after
4. **This summary** - Overview of the migration package

### Patch Files
5. **IHPfinal.v.patch** - Verilog code changes for main module
6. **info.yaml.patch** - Configuration file changes
7. **info.md.patch** - Documentation changes

### Automation
8. **apply_safe_asic_changes.sh** - Automated script to apply all patches
9. **safe-asic-to-fpga-migration.tar.gz** - Archive of all migration files

## What Changed in PR #1

**Problem:** Dedicated input pins (`ui_in`) were unavailable in the ASIC platform.

**Solution:** Remap keypad row inputs to bidirectional I/O pins configured as inputs.

**Changes:**
- Keypad rows: `ui_in[3:0]` → `uio_in[7:4]` (inputs)
- Keypad columns: `uio_out[2:0]` (no change, outputs)
- Lock/LEDs: `uio_out[5:3]` → `uo_out[2:0]` (dedicated outputs)
- Bidirectional enable: `8'b00111111` → `8'b00000111`

## How to Use This Package

### For Safe_ASIC-FPGA Repository

**Quick Method:**
```bash
# In your Safe_ASIC-FPGA repository
wget https://github.com/entropicentity/Safe-ASIC/raw/[branch]/safe-asic-to-fpga-migration.tar.gz
tar -xzf safe-asic-to-fpga-migration.tar.gz
./apply_safe_asic_changes.sh
git diff  # Review changes
# Test and commit
```

**Manual Method:**
```bash
# Download individual patches
patch -p1 < info.yaml.patch
patch -p1 < info.md.patch
patch -p1 < IHPfinal.v.patch
```

**From GitHub:**
You can also download individual files directly from this PR or branch.

## Files Modified in Your FPGA Repo

When you apply this migration, the following files in your Safe_ASIC-FPGA repository will be modified:

1. `src/IHPfinal.v` (or equivalent main module file)
2. `info.yaml`
3. `docs/info.md`

## Before/After Comparison

### Hardware Connections
| Component | Before | After |
|-----------|--------|-------|
| Keypad Rows | `ui[0:3]` | `uio[4:7]` |
| Keypad Columns | `uio[0:2]` | `uio[0:2]` |
| Solenoid | `uio[3]` | `uo[0]` |
| Green LED | `uio[4]` | `uo[1]` |
| Blue LED | `uio[5]` | `uo[2]` |

### Code Changes
```verilog
// Before
assign uio_oe = 8'b00111111;
// After
assign uio_oe = 8'b00000111;
```

## Testing Checklist

After applying changes to Safe_ASIC-FPGA:

- [ ] Code compiles/synthesizes without errors
- [ ] Update FPGA constraint files (XDC, UCF, etc.) with new pin assignments
- [ ] Test keypad input on uio[4:7]
- [ ] Test keypad columns on uio[0:2]
- [ ] Test lock output on uo[0]
- [ ] Test LED outputs on uo[1:2]
- [ ] Verify safe unlock/lock functionality

## Support

If you encounter issues:

1. **Read the documentation** - Start with README_MIGRATION.md
2. **Check the original PR** - https://github.com/entropicentity/Safe-ASIC/pull/1
3. **Review QUICK_REFERENCE.md** - For pin mapping lookup
4. **Revert if needed** - The script creates a backup branch

## Package Contents Summary

```
safe-asic-to-fpga-migration/
├── README_MIGRATION.md              (Start here!)
├── MIGRATION_TO_SAFE_ASIC_FPGA.md  (Detailed technical guide)
├── QUICK_REFERENCE.md               (Pin mapping lookup)
├── IHPfinal.v.patch                 (Verilog changes)
├── info.yaml.patch                  (Config changes)
├── info.md.patch                    (Doc changes)
└── apply_safe_asic_changes.sh       (Automation script)
```

## Next Steps

1. **Download** the migration package (tarball or individual files)
2. **Extract** to your Safe_ASIC-FPGA repository
3. **Run** the apply script or apply patches manually
4. **Review** changes with `git diff`
5. **Test** compilation and hardware
6. **Update** constraint files if needed
7. **Commit** changes to your repository

## Important Notes

- The migration script creates a backup branch automatically
- All patches are relative to repository root
- If your file structure differs, manual application may be needed
- FPGA constraint files are not included - you must update those separately
- The functionality remains identical - only pin assignments change

## Questions?

All the information you need should be in:
- README_MIGRATION.md (usage guide)
- MIGRATION_TO_SAFE_ASIC_FPGA.md (technical details)
- QUICK_REFERENCE.md (quick lookup)
- Original PR #1 (https://github.com/entropicentity/Safe-ASIC/pull/1)

---

**This package is ready to use!** Follow README_MIGRATION.md for detailed instructions.
