`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 23:16:52
// Design Name: 
// Module Name: Disp_hex_dec
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


module Disp_hex_dec(
    input logic BTNU,
          logic [31:0] bcd, bin,
    output logic [31:0] to_display
    );
    
    always_comb begin
        if (BTNU) to_display = bcd;
        else to_display = bin;
    end
    
endmodule
