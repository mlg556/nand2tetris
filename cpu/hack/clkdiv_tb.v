`timescale 1ns / 1ns


module clk_div_tb;

  reg  clk = 0;
  wire clk_out;

  clkdiv #(
      .COUNT(112_500)
  ) u0 (
      clk,
      clk_out
  );

  always #18 clk = ~clk;  // fpga clock is 27MHz = 18ns on/off

  initial begin
    $dumpfile("clk_div_tb.vcd");
    $dumpvars(0, clk_div_tb);

    #50_000_000 $finish;

  end

endmodule
