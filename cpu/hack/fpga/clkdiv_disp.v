module clkdiv_disp (
    input clk,
    output reg clk_out = 0
);

  reg [31:0] counter = 0;

  localparam COUNT = 64_000;

  always @(posedge clk) begin
    if (counter == COUNT) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end else counter <= counter + 1;
  end

endmodule
