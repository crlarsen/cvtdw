`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 07:24:39 PM
// Design Name: 
// Module Name: cvtdw
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Convert 32-bit signed integer into 64-bit floating point number.
//              Implement MIPS cvt.d.w instruction.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cvtdw(in, out);
  parameter INTn = 32;
  parameter NEXP = 11;
  parameter NSIG = 52;
  `include "ieee-754-flags.v"
  localparam CLOG2_INTn = $clog2(INTn);
  input signed [INTn-1:0] in;
  output [NEXP+NSIG:0] out;
  reg [NEXP+NSIG:0] out;
  
  reg [INTn-1:0] sig;
  wire [INTn-1:0] mask;
  
  assign mask = {INTn{1'b1}};

  integer i, exp;
  
  always @(*)
    begin
      // Signed integers are stored in 2's complement form; floating
      // point numbers are stored in sign/magnitude form. If the
      // input value is negative compute its absolute value. We get
      // the correct result even though 2 ** (INTn-1) can't be
      // represented as a signed integer. Effectively, after we've
      // computed the absolute value we treat the INTn-bit result as
      // an unsigned number and this works.
      sig = in[INTn-1] ? ~in + 1 : in;
      
      if (in == 0)
        begin
          out = {NEXP+NSIG+1{1'b0}};
        end
      else
        begin
          // Left shift the significand to get the most significant
          // 1 bit into bit position NSIG. Keep track of how many places
          // We needed to shift the significand value; we'll need this
          // information for calculating the final exponent value.
          exp = 0;
          for (i = (1 << (CLOG2_INTn - 1)); i > 0; i = i >> 1)
            begin
              // Are the i most significant bits all zero?
              if ((sig & (mask << (INTn - i))) == 0)
                begin
                  sig = sig << i;
                  exp = exp | i;
                end
            end
            
          // The largest possible signed INTn-bit signed integer magnitude
          // is 2 ** (INTn-1) so we start with (INTn-1) as our largest
          // possible exponent. Each bit position we had to shift in order
          // to get the most significant one bit into position NSIG reduces
          // the exponent value. Don't forget we need to add the BIAS value
          // to get our final exponent value.
          exp = (INTn-1) + BIAS - exp;
          out = {in[INTn-1], exp[NEXP-1:0], sig[INTn-2:0],
                 {NSIG-INTn+1{1'b0}}}; // The significand is wider than the integer.
                                 // Pad significand with zeroes.
        end
    end
endmodule
