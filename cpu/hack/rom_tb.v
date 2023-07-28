module ROM_TB;

  reg  [14:0] A;
  wire [15:0] D;

  ROM r0 (
      A,
      D
  );

  initial begin
    $monitor("%X", D);
    #1 A = 0;
    #1 A = 1;
    #1 A = 2;
    #1 A = 3;
    #1 A = 4;
    #1 A = 5;
    #1 A = 6;
    #1 $finish;

  end



endmodule
