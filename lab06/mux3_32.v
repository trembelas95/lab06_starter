module mux3_32(
input     [31:0] d0, d1, d2,
input      [1:0] s, 
output reg[31:0] y);

  always @(*) begin
    case(s)
    2'b00: #10 y = d0;
    2'b01: #10 y = d1;
    2'b10: #10 y = d2;
    default: #10 y = 32'hx;
    endcase
  end
endmodule
