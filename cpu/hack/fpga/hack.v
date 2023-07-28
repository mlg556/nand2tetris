`include "cpu.v"
`include "roma.v"

module hack (
    input clk,
    input rstn,
    output [15:0] SCREEN
);
  wire [14:0] rom_addr;
  wire [15:0] rom_data;
  // ROM
  ROMA ROMA_i0 (
      .A(rom_addr),
      .D(rom_data)
  );
  // cpu
  cpu cpu_i1 (
      .instr(rom_data),
      .clk(clk),
      .rstn(rstn),
      .PC(rom_addr),
      .SCREEN(SCREEN)
  );
endmodule
