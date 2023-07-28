module sevseg (
    input [3:0] in,
    output reg [6:0] pattern
);

  always @(in) begin
    case (in)
      4'd0: pattern <= 7'b0111111;
      4'd1: pattern <= 7'b0000110;
      4'd2: pattern <= 7'b1011011;
      4'd3: pattern <= 7'b1001111;
      4'd4: pattern <= 7'b1100110;
      4'd5: pattern <= 7'b1101101;
      4'd6: pattern <= 7'b1111101;
      4'd7: pattern <= 7'b0000111;
      4'd8: pattern <= 7'b1111111;
      4'd9: pattern <= 7'b1101111;
      default: pattern <= 7'b0000000;

    endcase
  end
endmodule
