module hack_tb;

  reg clk;
  reg [15:0] instr;

  hack h0 (
      clk,
      instr
  );

  initial begin
    clk = 0;
    //$monitor("%b", instr);

  end

  always #1 clk = ~clk;

  initial begin
    #2 instr = 16'h0003;
    #2 instr = 16'hEC10;
    #2 instr = 16'h0000;
    #2 instr = 16'hE308;
    #2 instr = 16'h0004;
    #2 instr = 16'hEC10;
    #2 instr = 16'h0001;
    #2 instr = 16'hE308;
    #2 instr = 16'h0000;
    #2 instr = 16'hFC10;
    #2 instr = 16'h0001;
    #2 instr = 16'hF090;
    #2 instr = 16'h0002;
    #2 instr = 16'hE308;
    #2 instr = 16'h0000;
    #2 $finish;
  end

  initial begin
    $dumpfile("hack.vcd");
    $dumpvars(0, hack_tb);
  end
endmodule


