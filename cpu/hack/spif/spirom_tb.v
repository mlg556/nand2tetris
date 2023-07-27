module spirom_tb;
  reg  clk = 0;
  wire mosi;
  wire sck;
  wire cs;

  spirom u0 (
      clk,
      mosi,
      sck,
      cs
  );

  always begin
    #2 clk = ~clk;
  end

  initial begin
    $monitor("%b", mosi);

    $dumpfile("spirom.vcd");
    $dumpvars(0, spirom_tb);

    #50 $finish;
  end


endmodule
