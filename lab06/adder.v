module adder(input [31:0] a, b,
             output [31:0] y);

  assign #30 y = a + b;
endmodule
