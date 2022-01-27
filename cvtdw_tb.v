`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 08:11:36 PM
// Design Name: 
// Module Name: cvtdw_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cvtdw_tb;
  parameter INTn = 32;
  parameter NEXP = 11;
  parameter NSIG = 52;
  reg signed [INTn-1:0] w;
  wire [NEXP+NSIG:0] d;
  
  integer i;
  
  initial
    begin
      w = 0;
      $monitor("w = %d (0x%x), d = %x", w, w , d);
    end
  
  initial
    begin
      for (i = 0; i < INTn-1; i = i + 1)
        begin
          #10 w = 1 << i;
        end
        
      for (i = 1; i < INTn-1; i = i + 1)
        begin
          #10 w = ~0 >> i;
        end
        
      for (i = 0; i < INTn; i = i + 1)
        begin
          #10 w = ~0 << i;
        end
        
      for (i = 1; i < INTn; i = i + 1)
        begin
          #10 w = (~0 << i) + 1;
        end
        
      #10 $display("Test ended");
      $stop;    
    end
    
    defparam inst1.INTn = INTn;
    defparam inst1.NEXP = NEXP;
    defparam inst1.NSIG = NSIG;
    cvtdw inst1(w, d);
endmodule
