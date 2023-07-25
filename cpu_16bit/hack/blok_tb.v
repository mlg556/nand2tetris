module blok_tb;
  reg clk;
  wire [8:0] A;

  blok u0 (
      clk,
      A
  );

  initial begin
    $monitor("%b |%d", clk, A);

    clk = 0;
  end

  always #1 clk = ~clk;

  initial begin
    #20 $finish;
  end

  initial begin
    $dumpfile("blok.vcd");
    $dumpvars(0, blok_tb);
  end


endmodule
