module hack_tb;

  reg clk;
  reg [15:0] instr;
  wire [14:0] PC;
  wire [15:0] SCREEN;

  // ROM
  reg [15:0] ROM[0:255];

  initial begin
    $readmemh("fib.hex", ROM);
    #2 clk = 0;
    $monitor("%d", SCREEN);

    for (integer i = 0; i < 1000; i++) begin
      #1 clk = ~clk;
      instr = ROM[PC];
    end

    #2 $finish;

  end

  hack h0 (
      instr,
      clk,
      PC,
      SCREEN
  );

  initial begin
    $dumpfile("hack.vcd");
    $dumpvars(0, hack_tb);
  end
endmodule


