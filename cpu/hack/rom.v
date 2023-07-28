module ROM (
    input [14:0] A,
    output reg [15:0] D
);
  reg [15:0] roma[0:255];

  initial begin
    $readmemh("fib.hex", roma);
  end

  always @(*) begin
    D = roma[A];
  end


endmodule
