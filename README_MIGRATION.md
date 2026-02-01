# Safe-ASIC Changes Migration Package

This package contains all the necessary files to migrate the pin remapping changes from the Safe-ASIC repository to your Safe_ASIC-FPGA repository.

## What's Changed?

PR #1 in the Safe-ASIC repository remapped keypad inputs from dedicated pins to bidirectional I/O pins. This was necessary because dedicated input pins (`ui_in`) were unavailable in the ASIC platform.

**Summary of changes:**
- Keypad row inputs moved from `ui_in[3:0]` to `uio_in[7:4]`
- Keypad column outputs remain on `uio_out[2:0]`
- Lock and LED outputs moved from `uio_out[5:3]` to `uo_out[2:0]`
- Bidirectional pin enable updated: `uio_oe = 8'b00000111`

## Package Contents

1. **MIGRATION_TO_SAFE_ASIC_FPGA.md** - Detailed migration guide with complete explanation
2. **IHPfinal.v.patch** - Patch file for the main Verilog module
3. **info.yaml.patch** - Patch file for the info.yaml configuration
4. **info.md.patch** - Patch file for the documentation
5. **apply_safe_asic_changes.sh** - Automated script to apply all patches
6. **README_MIGRATION.md** - This file

## Quick Start

### Option 1: Automated (Recommended)

1. Navigate to your Safe_ASIC-FPGA repository:
   ```bash
   cd /path/to/Safe_ASIC-FPGA
   ```

2. Copy all the migration files to your repository root:
   ```bash
   # Copy from the Safe-ASIC repo
   cp /path/to/Safe-ASIC/*.patch .
   cp /path/to/Safe-ASIC/apply_safe_asic_changes.sh .
   ```

3. Run the migration script:
   ```bash
   ./apply_safe_asic_changes.sh
   ```

4. Review the changes:
   ```bash
   git diff
   ```

5. Test compilation and commit if everything looks good

### Option 2: Manual

1. Read `MIGRATION_TO_SAFE_ASIC_FPGA.md` for detailed information

2. Apply each patch manually:
   ```bash
   patch -p1 < info.yaml.patch
   patch -p1 < info.md.patch
   patch -p1 < IHPfinal.v.patch
   ```

3. If your main Verilog file has a different name, apply the changes from `IHPfinal.v.patch` manually

## Pin Assignment After Migration

| Pin | Direction | Function |
|-----|-----------|----------|
| `uio[0:2]` | Output | Keypad columns 1-3 |
| `uio[4:7]` | Input | Keypad rows 1-4 |
| `uo[0]` | Output | Lock (solenoid) |
| `uo[1]` | Output | Green LED |
| `uo[2]` | Output | Blue LED |
| `ui[*]` | Input | Unused |

## Testing After Migration

1. **Verify Compilation:**
   - Ensure your project compiles/synthesizes without errors
   - Check that all modules instantiate correctly

2. **Update Constraints:**
   - If you have FPGA constraint files (XDC, UCF, etc.), update pin assignments
   - Ensure bidirectional pins are properly configured

3. **Hardware Test:**
   - Connect hardware according to the new pin assignments
   - Test keypad input on `uio[4:7]`
   - Test keypad columns on `uio[0:2]`
   - Test lock/LED outputs on `uo[0:2]`

## FPGA-Specific Considerations

Depending on your FPGA platform, you may need to:

1. **Update constraint files** with new pin mappings
2. **Configure bidirectional pins** in your synthesis tool
3. **Adjust timing constraints** if pin changes affect timing
4. **Update testbenches** to reflect new pin assignments

## Troubleshooting

**Patch fails to apply:**
- Your file structure might be different
- Apply changes manually using `MIGRATION_TO_SAFE_ASIC_FPGA.md` as reference
- Check that you're in the repository root when applying patches

**Compilation errors:**
- Verify all signal names match
- Check that `uio_oe` is properly assigned
- Ensure internal wires (keypad_col0/1/2) are declared

**Hardware doesn't work:**
- Double-check physical pin connections match new assignments
- Verify FPGA constraint file matches the code
- Test with a simple testbench first

## Reverting Changes

If you need to revert the changes, the migration script creates a backup branch:
```bash
git branch  # List all branches, find the backup-before-safe-asic-migration-* branch
git checkout backup-before-safe-asic-migration-YYYYMMDD-HHMMSS
```

## Need Help?

Refer to the original PR for context:
https://github.com/entropicentity/Safe-ASIC/pull/1

The PR description contains:
- Rationale for changes
- Detailed technical explanation  
- Pin assignment table

## Files Modified

This migration will modify:
- `src/IHPfinal.v` (or your equivalent main module)
- `info.yaml`
- `docs/info.md`

No other files need changes.
