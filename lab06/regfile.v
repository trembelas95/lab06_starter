module regfile(input             clk, 
               input             we3, 
               input      [4:0]  ra1, ra2, wa3, 
               input      [31:0] wd3, 
//               output reg [31:0] rd1, rd2);
               output  [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  // Bypasses stored value if we3 && wa3 == ra1 or wa3 == ra2

  always @(posedge clk)
    if (we3)
	   rf[wa3] <= wd3;	

  assign #50 rd1 = (ra1 == 0)? 0
                             : (we3 && (ra1 == wa3)) ? wd3
                                                     : rf[ra1];

  assign #50 rd2 = (ra2 == 0)? 0
                             : (we3 && (ra2 == wa3)) ? wd3
                                                     : rf[ra2];
/*
  always @(*) begin
      if (ra1 == 0)
          #50 rd1 = 0;
      else if (we3 && (ra1 == wa3))
          #50 rd1 = wd3;
      else
          #50 rd1 = rf[ra1];
  end

  always @(*) begin
      if (ra2 == 0)
          #50 rd2 = 0;
      else if (we3 && (ra2 == wa3))
          #50 rd2 = wd3;
      else
          #50 rd2 = rf[ra2];
  end
*/

endmodule
