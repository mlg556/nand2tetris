module clkdiv120 (
    input clk,
    output reg clk_out = 0
);

  reg [31:0] counter = 0;

  localparam COUNT = 112500;

  always @(posedge clk) begin
    if (counter == COUNT) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end else counter <= counter + 1;
  end

endmodule
