/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */
module clkdiv20 (
    input clk,
    output reg clk_out = 0
);

  reg [31:0] counter = 0;

  localparam COUNT = 675000;

  always @(posedge clk) begin
    if (counter == COUNT) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end else counter <= counter + 1;
  end

endmodule

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


module DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;

    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end

    assign out = count;
    assign ovf = en? &count : 1'b0;

    initial begin
        count = 'h0;
    end
endmodule


module Decoder2 (
    output out_0,
    output out_1,
    output out_2,
    output out_3,
    input [1:0] sel
);
    assign out_0 = (sel == 2'h0)? 1'b1 : 1'b0;
    assign out_1 = (sel == 2'h1)? 1'b1 : 1'b0;
    assign out_2 = (sel == 2'h2)? 1'b1 : 1'b0;
    assign out_3 = (sel == 2'h3)? 1'b1 : 1'b0;
endmodule


module Mux_4x1_NBits #(
    parameter Bits = 2
)
(
    input [1:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default:
                out = 'h0;
        endcase
    end
endmodule

module cpu (
    input [15:0] instr,
    input clk,

    output reg [14:0] PC,
    output [15:0] SCREEN
);
  reg [15:0] A;
  reg [15:0] D;

  reg [15:0] RAM[31:0];

  reg signed [15:0] ALU;

  // ac bit, determines whether a-ins or c-ins
  wire ac = instr[15];

  // the 15-bit value to be loaded to A, if a-ins
  wire [14:0] v = instr[14:0];

  // "a" bit, source of Y operand of alu
  wire a = instr[12];
  // 6-bit c's
  wire [5:0] c = instr[11:6];
  // 3-bit d
  wire [2:0] dest = instr[5:3];
  // 3-bit j
  wire [2:0] jump = instr[2:0];

  // comp, concat a with c's to form a single table like in wiki
  wire [6:0] comp = {a, c};

  wire [15:0] M = RAM[A];  // M "register"

  assign SCREEN = RAM[15];  // so R15 is "displayed"


  initial begin
    A  = 0;
    D  = 0;
    PC = 0;
  end


  always @(posedge clk) begin

    if (ac == 1'b0) begin
      // a-instruction
      // load v into A register
      A  = v;
      PC = PC + 1;
    end else if (ac == 1'b1) begin
      // c-instruction
      // comp, alu output
      case (comp)
        7'b0101010: ALU = 0;
        7'b0111111: ALU = 1;
        7'b0111010: ALU = -1;
        7'b0001100: ALU = D;
        7'b0110000: ALU = A;
        7'b1110000: ALU = M;
        7'b0001101: ALU = !D;
        7'b0110001: ALU = !A;
        7'b1110001: ALU = !M;
        7'b0001111: ALU = -D;
        7'b0110011: ALU = -A;
        7'b1110011: ALU = -M;
        7'b0011111: ALU = D + 1;
        7'b0110111: ALU = A + 1;
        7'b1110111: ALU = M + 1;
        7'b0001110: ALU = D - 1;
        7'b0110010: ALU = A - 1;
        7'b1110010: ALU = M - 1;
        7'b0000010: ALU = D + A;
        7'b1000010: ALU = D + M;
        7'b0010011: ALU = D - A;
        7'b1010011: ALU = D - M;
        7'b0000111: ALU = A - D;
        7'b1000111: ALU = M - D;
        7'b0000000: ALU = D & A;
        7'b1000000: ALU = D & M;
        7'b0010101: ALU = D | A;
        7'b1010101: ALU = D | M;
        default: ALU = 0;

      endcase
      // dest, where to store this alu output
      case (dest)
        3'b000:  ;
        3'b001:  RAM[A] = ALU;
        3'b010:  D = ALU;
        3'b011: begin
          D = ALU;
          RAM[A] = ALU;
        end
        3'b100:  A = ALU;
        3'b101: begin
          A = ALU;
          RAM[A] = ALU;
        end
        3'b110: begin
          A = ALU;
          D = ALU;
        end
        3'b111: begin
          A = ALU;
          D = ALU;
          RAM[A] = ALU;
        end
        default: ;

      endcase
      // if conditions are satisfied, we "jump" wherever A points to
      case (jump)
        // no jump
        3'b000:  PC = PC + 1;
        // jump if comp > 0
        3'b001:  PC = (ALU > 0) ? A : PC + 1;
        3'b010:  PC = (ALU == 0) ? A : PC + 1;
        3'b011:  PC = (ALU >= 0) ? A : PC + 1;
        3'b100:  PC = (ALU < 0) ? A : PC + 1;
        3'b101:  PC = (ALU != 0) ? A : PC + 1;
        3'b110:  PC = (ALU <= 0) ? A : PC + 1;
        // unconditional jump
        3'b111:  PC = A;
        default: PC = PC + 1;
      endcase
    end
  end
endmodule

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


module DIG_ROM_32768X16_rom (
    input [14:0] A,
    input sel,
    output reg [15:0] D
);
    reg [15:0] my_rom [0:25];

    always @ (*) begin
        if (~sel)
            D = 16'hz;
        else if (A > 15'h19)
            D = 16'h0;
        else
            D = my_rom[A];
    end

    initial begin
        my_rom[0] = 16'h10;
        my_rom[1] = 16'hefc8;
        my_rom[2] = 16'h11;
        my_rom[3] = 16'hefc8;
        my_rom[4] = 16'h12;
        my_rom[5] = 16'hea88;
        my_rom[6] = 16'h10;
        my_rom[7] = 16'hfc10;
        my_rom[8] = 16'hf;
        my_rom[9] = 16'he308;
        my_rom[10] = 16'h10;
        my_rom[11] = 16'hfc10;
        my_rom[12] = 16'h11;
        my_rom[13] = 16'hf090;
        my_rom[14] = 16'h12;
        my_rom[15] = 16'he308;
        my_rom[16] = 16'h10;
        my_rom[17] = 16'hfc10;
        my_rom[18] = 16'h11;
        my_rom[19] = 16'he308;
        my_rom[20] = 16'h12;
        my_rom[21] = 16'hfc10;
        my_rom[22] = 16'h10;
        my_rom[23] = 16'he308;
        my_rom[24] = 16'h6;
        my_rom[25] = 16'hea87;
    end
endmodule


module hack_fpga (
  input clk,
  output a,
  output b,
  output c,
  output d,
  output e,
  output f,
  output g,
  output x0,
  output x1,
  output x2,
  output x3
);
  wire [3:0] s0;
  wire [6:0] s1;
  wire [6:0] s2;
  wire [15:0] s3;
  wire [3:0] s4;
  wire [3:0] s5;
  wire [3:0] s6;
  wire [3:0] s7;
  wire [1:0] s8;
  wire s9;
  wire s10;
  wire [15:0] s11;
  wire [14:0] s12;
  // clkdiv20
  clkdiv20 clkdiv20_i0 (
    .clk( clk ),
    .clk_out( s10 )
  );
  // clkdiv120
  clkdiv120 clkdiv120_i1 (
    .clk( clk ),
    .clk_out( s9 )
  );
  DIG_Counter_Nbit #(
    .Bits(2)
  )
  DIG_Counter_Nbit_i2 (
    .en( 1'b1 ),
    .C( s9 ),
    .clr( 1'b0 ),
    .out( s8 )
  );
  Decoder2 Decoder2_i3 (
    .sel( s8 ),
    .out_0( x0 ),
    .out_1( x1 ),
    .out_2( x2 ),
    .out_3( x3 )
  );
  Mux_4x1_NBits #(
    .Bits(4)
  )
  Mux_4x1_NBits_i4 (
    .sel( s8 ),
    .in_0( s4 ),
    .in_1( s5 ),
    .in_2( s6 ),
    .in_3( s7 ),
    .out( s0 )
  );
  // cpu
  cpu cpu_i5 (
    .instr( s11 ),
    .clk( s10 ),
    .PC( s12 ),
    .SCREEN( s3 )
  );
  // sevseg
  sevseg sevseg_i6 (
    .in( s0 ),
    .pattern( s1 )
  );
  // bcd
  bcd bcd_i7 (
    .num( s3 ),
    .dig_1( s4 ),
    .dig_10( s5 ),
    .dig_100( s6 ),
    .dig_1000( s7 )
  );
  // rom
  DIG_ROM_32768X16_rom DIG_ROM_32768X16_rom_i8 (
    .A( s12 ),
    .sel( 1'b1 ),
    .D( s11 )
  );
  assign s2 = ~ s1;
  assign a = s2[0];
  assign b = s2[1];
  assign c = s2[2];
  assign d = s2[3];
  assign e = s2[4];
  assign f = s2[5];
  assign g = s2[6];
endmodule
