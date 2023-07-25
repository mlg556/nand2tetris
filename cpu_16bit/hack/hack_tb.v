module hack_tb;

  reg clk;
  reg [15:0] instr;
  wire [14:0] PC;
  wire signed [15:0] OUT;

  // ROM
  reg [15:0] ROM[0:255];

  initial begin
    $readmemh("mult.hex", ROM);
    #2 clk = 0;
    // $monitor(OUT);

    for (integer i = 0; i < 255; i++) begin
      #1 clk = ~clk;
      instr = ROM[PC];
    end

    #2 $finish;
    //$monitor("%b", instr);

  end

  hack h0 (
      instr,
      clk,
      PC,
      OUT
  );

  initial begin
    $dumpfile("hack.vcd");
    $dumpvars(0, hack_tb);
  end
endmodule


