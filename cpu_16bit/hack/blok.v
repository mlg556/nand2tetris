module blok (
    input clk,
    output reg [8:0] A
);

  initial begin
    A = 0;
  end

  always @(posedge clk) begin

    A = A + 1;

  end
endmodule
