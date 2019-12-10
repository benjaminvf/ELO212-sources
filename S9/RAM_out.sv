`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2019 17:22:51
// Design Name: 
// Module Name: RAM_out
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

// Modulo combinacional, si no funciona probar en secuencial
// No esta diseñado para sobel, lo que no significa que no pueda ser usado con el.
module RAM_out(
    input logic clk, rst,
    input logic [10:0] pos_x, pos_y,
    input logic [23:0] pix_in,
    output logic [17:0] addr,
    output logic [23:0] pix_out
    );
    
    always_comb begin
        if (pos_x == 0 || pos_y == 0 || pos_x > 511 || pos_y > 384) begin
            addr = 'b0;
            pix_out = 'h0;
        end else begin
            addr = pos_x-1 + (pos_y-1)*512;
            pix_out = pix_in;
        end    
    end

//    always_ff @(posedge clk) begin
//        if (rst) begin
//            addr <= 'b0;
//            pix_out <= 'b0;
//        end else if (pos_x == 0 && pos_y == 0) begin  
//            addr <= 'b0;
//            pix_out = pix_in;
//        end else if (pos_x <= 512 && pos_y <= 385) begin
//            addr <= addr +'b1;
//            pix_out <= pix_in;
//        end else begin
//            addr <= addr;
//            pix_out <= 'hFFFFFF;
//        end
//    end
            
              
  
endmodule
