`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 19:02:31
// Design Name: 
// Module Name: ALU_Bank
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


module ALU_Bank #(parameter N = 16) 
(
    input logic CLK100MHZ, CPU_RESETN, r0, r1, r2,
          logic [N-1:0] SW,
    output logic [N-1:0] OP1, OP2, 
           logic [1:0] OpCode
    );
    logic [N-1:0] operation;
    
    FDCE bancoOP1 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r0), .leds(OP1));
    FDCE bancoOP2 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r1), .leds(OP2));
    FDCE bancoOpCode ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r2), .leds(operation));
    
    assign OpCode = operation[1:0];
    
endmodule
