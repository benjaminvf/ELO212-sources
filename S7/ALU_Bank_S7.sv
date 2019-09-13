`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2019 21:07:47
// Design Name: 
// Module Name: ALU_Bank_S7
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


module ALU_Bank_S7(
 input logic CLK100MHZ, CPU_RESETN, r0, r1, r2, r3, r4,
          logic [7:0] SW,
    output logic [15:0] operando1, operando2, 
           logic [2:0] ALU_ctrl
    );
    logic [7:0] operando11, operando12, operando21, operando22;
    
    FDCE #(8) b_operando11 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r0), .leds(operando11));
    FDCE #(8) b_operando12 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r1), .leds(operando12));
    FDCE #(8) b_operando21 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r2), .leds(operando21));
    FDCE #(8) b_operando22 ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r3), .leds(operando22));
    
    assign operando1 = {operando12,operando11};
    assign operando2 = {operando22,operando21};
    
    logic [7:0] operation;
    
    FDCE #(8) bancoOpCode ( .clk(CLK100MHZ), .RST_BTN_n(CPU_RESETN), .switches(SW), .retain(r4), .leds(operation));
    
    assign ALU_ctrl = operation[2:0];
    
endmodule
