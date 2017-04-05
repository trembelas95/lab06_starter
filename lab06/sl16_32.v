module sl16_32(
    input  [15:0] a,
    output [31:0] y
);

  // shift left by 2
  assign y = {a[15:0], 16'h0000};
endmodule
