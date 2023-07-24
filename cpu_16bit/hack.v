module hack (
    input clk,
    input [15:0] instr,

    output reg [14:0] PC
);
  reg [15:0] A;
  reg [15:0] D;

  reg [15:0] mem[7:0];

  reg [15:0] ALU;

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

  wire [15:0] M = mem[A];  // M "register"

  initial begin
    A = 0;
    D = 0;

    // $monitor("A:%d | D:%d", A, D);
    $monitor("%h", mem[2]);
  end

  always @(posedge clk) begin

    if (ac == 1'b0) begin
      // a-instruction
      // load v into A register
      A = v;
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
        3'b001:  mem[A] = ALU;
        3'b010:  D = ALU;
        3'b011: begin
          D = ALU;
          mem[A] = ALU;
        end
        3'b100:  A = ALU;
        3'b101: begin
          A = ALU;
          mem[A] = ALU;
        end
        3'b110: begin
          A = ALU;
          D = ALU;
        end
        3'b111: begin
          A = ALU;
          D = ALU;
          mem[A] = ALU;
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
