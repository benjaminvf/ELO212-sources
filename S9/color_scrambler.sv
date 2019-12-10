`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2019 18:19:58
// Design Name: 
// Module Name: color_scrambler
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


module color_scramble(
input logic [11:0] color,
input logic [15:10]SW,
output logic [11:0] RGB
    );

logic [3:0] colorR,colorG,colorB;
always_comb begin

case (SW [15:14])

    2'b00: colorR = color [11:8];
    2'b01: colorR = color [7:4];
    2'b10: colorR = color [3:0];
    2'b11: colorR = 4'b0000;
endcase

case (SW [13:12])

    2'b00: colorG = color [11:8];
    2'b01: colorG = color [7:4];
    2'b10: colorG = color [3:0];
    2'b11: colorG = 4'b0000;
endcase

case (SW [11:10])

    2'b00: colorB = color [11:8];
    2'b01: colorB = color [7:4];
    2'b10: colorB = color [3:0];
    2'b11: colorB = 4'b0000;
endcase
end

assign RGB [11:8] = colorR;
assign RGB [7:4] = colorG;
assign RGB [3:0] = colorB;

endmodule

