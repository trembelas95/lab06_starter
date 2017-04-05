module mux4_32(
input  [31:0] d0, d1, d2, d3,
input   [1:0] s, 
output [31:0] y);

  assign #10 y = s[1] ? (s[0]? d3 : d2)   // s[1] is 1
                      : (s[0]? d1 : d0);  // s[1] is 0
endmodule
