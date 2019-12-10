`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 23:49:31
// Design Name: 
// Module Name: Pixel_Bank
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


module Pixel_Bank(
    input logic r0, r1, r2, clk, reset,
          logic [7:0] rx_data_out,
    output logic [23:0] pixel
    );
    
    logic [7:0] R, G, B;
    
    FDCE #(8) b_R ( .clk(clk), .RST_BTN_n(reset), .switches(rx_data_out), .retain(r0), .leds(R));
    FDCE #(8) b_G ( .clk(clk), .RST_BTN_n(reset), .switches(rx_data_out), .retain(r1), .leds(G));
    FDCE #(8) b_B ( .clk(clk), .RST_BTN_n(reset), .switches(rx_data_out), .retain(r2), .leds(B));
    
    assign pixel = {R,G,B};
endmodule
