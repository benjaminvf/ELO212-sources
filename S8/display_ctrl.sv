`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 18:39:24
// Design Name: 
// Module Name: display_ctrl
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


module display_ctrl(
input logic [2:0] state,
input logic [15:0]op1,
input logic [15:0]op2,
input logic [15:0] operation,
input logic [15:0] result,
output logic [15:0] display
    );
    
always_comb begin

case (state)

    'b100: display = operation ;
    'b000: display = op1;
    'b001: display = op1;
    'b010: display = op2;
    'b011: display = op2;
    'b101: display = result;
    default display = 'b0;
endcase

end
endmodule
