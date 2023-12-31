`include "cpu.v"
`include "rom.v"

module hack (
    input clk,
    output [15:0] SCREEN
);
  wire [14:0] rom_addr;
  wire [15:0] rom_data;
  // ROM
  ROM ROM_i0 (
      .A(rom_addr),
      .D(rom_data)
  );
  // cpu
  cpu cpu_i1 (
      .instr(rom_data),
      .clk(clk),
      .PC(rom_addr),
      .SCREEN(SCREEN)
  );
endmodule
