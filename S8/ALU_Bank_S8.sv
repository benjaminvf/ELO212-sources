`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 15:41:43
// Design Name: 
// Module Name: ALU_Bank_S8
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


module ALU_Bank_S8(
 input logic clk, rst, r0, r1, r2,
          logic [15:0] val,
    output logic [15:0] op1, op2, 
           logic [15:0] ALU_ctrl
    );
    
    FDCE #(16) b_op1 ( .clk(clk), .RST_BTN_n(rst), .switches(val), .retain(r0), .leds(op1));
    FDCE #(16) b_op2 ( .clk(clk), .RST_BTN_n(rst), .switches(val), .retain(r1), .leds(op2));
    
    FDCE #(16) b_opCode ( .clk(clk), .RST_BTN_n(rst), .switches(val), .retain(r2), .leds(ALU_ctrl));
    
endmodule

