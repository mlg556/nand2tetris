module spirom (
    input clk,
    output reg mosi = 0,
    output reg sck = 0,
    output reg cs = 1  // active low
);

  localparam WAIT = 4;

  reg [4:0] state = 0;
  integer wait_counter = 0;

  localparam INIT = 0;
  localparam SEND_CMD = 1;

  // initial begin
  //   $monitor(mosi);
  // end

  // reg [7:0] command = 8'h03;
  reg [7:0] command = 8'b11010010;

  always @(posedge clk) begin
    case (state)
      INIT: begin
        if (wait_counter < WAIT) begin
          wait_counter <= wait_counter + 1;
        end else begin
          state <= SEND_CMD;
        end
      end
      SEND_CMD: begin
        cs <= 0;  // set cs
        sck <= ~sck;  // toggle clock
        mosi <= command[7];  // push command bit out
        command <= command << 1;  // shift command
      end

    endcase

  end

endmodule
