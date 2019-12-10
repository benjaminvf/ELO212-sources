`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2019 17:27:02
// Design Name: 
// Module Name: F_Greyscale
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


module F_Greyscale(
    input logic [11:0] pix_in,
    output logic [11:0] pix_out
    );
    
//    assign pix_out = {pix_in[7:4],pix_in[7:4],pix_in[7:4]};
    
    logic [8:0] grey_aux;
    
    assign grey_aux = {pix_in[7:4],4'b0} + {pix_in[11:9],3'b0}+pix_in[3:0];
    
    always_comb
        if (grey_aux[8]) pix_out = 'hFFF;
        else pix_out = {grey_aux[7:4],grey_aux[7:4],grey_aux[7:4]};
    
endmodule
