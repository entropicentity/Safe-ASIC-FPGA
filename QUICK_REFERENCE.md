# Quick Reference: Pin Mapping Changes

## Old Pin Assignment (Before PR #1)

```
Inputs (ui_in):
  ui[0] - Keypad Row 1
  ui[1] - Keypad Row 2
  ui[2] - Keypad Row 3
  ui[3] - Keypad Row 4

Bidirectional (uio):
  uio[0] - Keypad Column 1 (output)
  uio[1] - Keypad Column 2 (output)
  uio[2] - Keypad Column 3 (output)
  uio[3] - Lock/Solenoid (output)
  uio[4] - Green LED (output)
  uio[5] - Blue LED (output)
  uio[6] - (input, unused)
  uio[7] - (input, unused)
  
  uio_oe = 8'b00111111
```

## New Pin Assignment (After PR #1)

```
Dedicated Outputs (uo_out):
  uo[0] - Lock/Solenoid
  uo[1] - Green LED
  uo[2] - Blue LED

Bidirectional (uio):
  uio[0] - Keypad Column 1 (output)
  uio[1] - Keypad Column 2 (output)
  uio[2] - Keypad Column 3 (output)
  uio[3] - (input, unused)
  uio[4] - Keypad Row 1 (input)
  uio[5] - Keypad Row 2 (input)
  uio[6] - Keypad Row 3 (input)
  uio[7] - Keypad Row 4 (input)
  
  uio_oe = 8'b00000111
```

## Wiring Changes

### Keypad Rows
- **Before:** Connect to ui[0:3]
- **After:** Connect to uio[4:7]

### Keypad Columns  
- **Before:** Connect to uio[0:2]
- **After:** Connect to uio[0:2] (no change)

### Lock/Solenoid
- **Before:** Connect to uio[3]
- **After:** Connect to uo[0]

### Green LED
- **Before:** Connect to uio[4]
- **After:** Connect to uo[1]

### Blue LED
- **Before:** Connect to uio[5]
- **After:** Connect to uo[2]

## Code Changes Summary

### IHPfinal.v

```verilog
// OLD:
assign uo_out  = 0;
assign uio_oe  = 8'b00111111;
assign uio_out[3] = lock;
assign uio_out[4] = green;
assign uio_out[5] = blue;
.in0(uio_in[0]), .in1(uio_in[1]), .in2(uio_in[2]), .in3(uio_in[3]),
.out0(uio_out[0]), .out1(uio_out[1]), .out2(uio_out[2]),

// NEW:
wire keypad_col0, keypad_col1, keypad_col2;
assign uo_out[0] = lock;
assign uo_out[1] = green;
assign uo_out[2] = blue;
assign uo_out[7:3] = 5'b00000;
assign uio_oe  = 8'b00000111;
assign uio_out[0] = keypad_col0;
assign uio_out[1] = keypad_col1;
assign uio_out[2] = keypad_col2;
assign uio_out[7:3] = 5'b00000;
.in0(uio_in[4]), .in1(uio_in[5]), .in2(uio_in[6]), .in3(uio_in[7]),
.out0(keypad_col0), .out1(keypad_col1), .out2(keypad_col2),
```

## Why This Change?

Dedicated input pins (ui_in) were unavailable in the ASIC implementation, so keypad row inputs were moved to bidirectional I/O pins configured as inputs. Lock and LED outputs were moved to dedicated outputs to free up bidirectional pins for input use.
