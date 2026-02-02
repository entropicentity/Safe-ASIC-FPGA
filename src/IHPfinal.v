/*
 * Copyright (c) 2024 Alexander Singer, 
 * SPDX-License-Identifier: Apache-2.0
 */

// contact me on discord @entropicentity

`default_nettype none

module tt_um_entropicentity_Safe_ASIC (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Assign dedicated outputs (lock, green, blue moved here from bidirectional pins)
  assign uo_out[0] = lock;
  assign uo_out[1] = green;
  assign uo_out[2] = blue;
  assign uo_out[7:3] = 5'b00000;
  assign uio_oe  = 8'b00000111; // uio[2:0] are outputs (keypad columns), uio[7:3] configured as inputs (uio[7:4] used for keypad rows, uio[3] unused)

  // Internal wires
  wire c1, c2;              // Alternating clocks from clockboss
  wire lock, green, blue;   // Safe control outputs
  wire [3:0] dataline;      // Data from membranedriver to safecontrol
  wire keypad_col0, keypad_col1, keypad_col2;  // Keypad column outputs from membranedriver

  // Assign bidirectional outputs
  assign uio_out[0] = keypad_col0;
  assign uio_out[1] = keypad_col1;
  assign uio_out[2] = keypad_col2;
  assign uio_out[7:3] = 5'b00000;  // uio[7:4] used as inputs (keypad rows), uio[3] unused; output values don't matter when configured as inputs

  // List all unused inputs to prevent warnings
  wire _unused = &{ui_in, ena, 1'b0};

  // Clock divider - generates alternating clocks
  clockboss u_clockboss (
    .clk(clk),
    .rst(rst_n),
    .c1(c1),
    .c2(c2)
  );

  // Keypad scanner - scans matrix keypad and outputs digit codes
  // Changed inputs from uio_in[3:0] to uio_in[7:4] to avoid conflict with outputs
  membranedriver u_membranedriver (
    .clk(c1),
    .rst(rst_n),
    .in0(uio_in[4]),
    .in1(uio_in[5]),
    .in2(uio_in[6]),
    .in3(uio_in[7]),
    .out0(keypad_col0),
    .out1(keypad_col1),
    .out2(keypad_col2),
    .data_out(dataline)
  );

  // Safe controller - manages unlock codes and LED status
  safecontrol u_safecontrol (
    .clk(c2),
    .rst(rst_n),
    .invalue(dataline),
    .lock(lock),
    .green(green),
    .blue(blue)
  );

endmodule
