# Migration Guide: Safe-ASIC to Safe_ASIC-FPGA

This document describes the changes made in Safe-ASIC PR #1 that need to be applied to the Safe_ASIC-FPGA repository.

## Summary

PR #1 "Remap keypad inputs from dedicated pins to bidirectional I/O pins" made changes to handle a hardware constraint where dedicated input pins (`ui_in`) are unavailable. The keypad row inputs were moved to use bidirectional I/O pins configured as inputs instead.

## Changes Overview

**Three files were modified:**
1. `src/IHPfinal.v` - Main hardware description file
2. `info.yaml` - Pin configuration metadata
3. `docs/info.md` - Documentation

## Pin Remapping

### Before (Original)
- Keypad row inputs: `ui_in[3:0]` (dedicated inputs)
- Keypad column outputs: `uio_out[2:0]` (bidirectional I/O)
- Lock/LED outputs: `uio_out[5:3]` (bidirectional I/O)

### After (Updated)
- Keypad row inputs: `uio_in[7:4]` (bidirectional I/O configured as inputs)
- Keypad column outputs: `uio_out[2:0]` (bidirectional I/O)
- Lock/LED outputs: `uo_out[2:0]` (dedicated outputs)

### Bidirectional Pin Configuration
```verilog
assign uio_oe = 8'b00000111;  // uio[2:0] outputs, uio[7:3] inputs
```

## Resulting Pin Assignment

| Pin | Direction | Function |
|-----|-----------|----------|
| `uio[0]` | Output | Keypad column 1 |
| `uio[1]` | Output | Keypad column 2 |
| `uio[2]` | Output | Keypad column 3 |
| `uio[3]` | Input | Unused |
| `uio[4]` | Input | Keypad row 1 |
| `uio[5]` | Input | Keypad row 2 |
| `uio[6]` | Input | Keypad row 3 |
| `uio[7]` | Input | Keypad row 4 |
| `uo[0]` | Output | Lock (solenoid) |
| `uo[1]` | Output | Green LED |
| `uo[2]` | Output | Blue LED |
| `uo[3:7]` | Output | Unused |
| `ui[0:7]` | Input | Unused |

## Files to Update

### 1. src/IHPfinal.v (or equivalent main module file)

See the attached `IHPfinal.v.patch` file for the full diff.

Key changes:
- Update `uio_oe` assignment from `8'b00111111` to `8'b00000111`
- Move lock, green, blue outputs from `uio_out[5:3]` to `uo_out[2:0]`
- Create internal wires for keypad columns: `keypad_col0`, `keypad_col1`, `keypad_col2`
- Update membranedriver input connections from `uio_in[3:0]` to `uio_in[7:4]`
- Update membranedriver output connections to use internal wires

### 2. info.yaml

See the attached `info.yaml.patch` file for the full diff.

Key changes:
- Clear `ui[0:3]` pin descriptions (set to empty strings)
- Move lock from `uo[3]` to `uo[0]`
- Move green from `uo[4]` to `uo[1]`
- Move blue from `uo[5]` to `uo[2]`
- Clear `uo[3:5]` pin descriptions
- Move keypad columns to `uio[0:2]`
- Move keypad rows to `uio[4:7]`

### 3. docs/info.md

See the attached `info.md.patch` file for the full diff.

Key changes in "How to test" section:
- Update row connections: "Connect the bidirectional I/O pins 4-7 (uio[4:7]) to the signals from the four rows"
- Update column connections: "connect the bidirectional I/O pins 0-2 (uio[0:2]) to the first or only three columns"
- Update solenoid connection: "connect the first output pin (uo[0]) to the power transistor"
- Update LED connections: "connect the second and third output pins (uo[1] and uo[2]) to the green and blue LEDs"

## Application Instructions

1. **Backup your Safe_ASIC-FPGA repository** before applying changes

2. **Apply the patches** in this order:
   - Apply changes to your main Verilog module file (equivalent to src/IHPfinal.v)
   - Apply changes to info.yaml
   - Apply changes to docs/info.md

3. **Test the changes**:
   - Verify the code compiles/synthesizes without errors
   - Test with your FPGA hardware if available
   - Verify pin assignments match your FPGA board constraints

4. **Adjust for FPGA-specific differences**:
   - You may need to adapt pin names or constraints files specific to your FPGA platform
   - Ensure your FPGA synthesis tool recognizes the bidirectional pin configuration

## Notes

- The main reason for these changes was that dedicated input pins were unavailable in the ASIC platform
- For FPGA implementations, you may have different constraints, but these changes maintain compatibility
- All functionality remains the same; only the physical pin assignments have changed
- The bidirectional I/O enable signal (`uio_oe`) is critical - ensure your FPGA platform supports this

## Questions?

If you encounter issues during migration, refer to the original PR #1 in the Safe-ASIC repository:
https://github.com/entropicentity/Safe-ASIC/pull/1
