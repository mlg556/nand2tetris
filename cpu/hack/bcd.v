// converts a 16-bit positive integers to 4 separate 4-bit integers,
// each representing a decimal place digit.

module bcd (
    input [15:0] num,
    output reg [3:0] dig_1,
    output reg [3:0] dig_10,
    output reg [3:0] dig_100,
    output reg [3:0] dig_1000
);

  reg [15:0] t;
  reg [15:0] quot;

  always @(*) begin
    t = num;

    quot = t / 10;
    dig_1 = t % 10;
    t = quot;

    quot = t / 10;
    dig_10 = t % 10;
    t = quot;

    quot = t / 10;
    dig_100 = t % 10;
    t = quot;

    quot = t / 10;
    dig_1000 = t % 10;
    t = quot;

  end

endmodule

