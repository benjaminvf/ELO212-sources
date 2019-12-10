`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2019 18:21:16
// Design Name: 
// Module Name: Dithering
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


//module Dithering(
//input logic [23:0] color,
//output logic [11:0] dithered
//    );
    
//logic opR, opG, opB; // Operaciones para cada color (0 = restar 1 ; 1= sumar 1) 
//logic [3:0] resultR , resultG , resultB; // resultados (4 bits por color)

//always_comb begin

//case (color [7:6]) //bits mas significativos
//     2'b00: opB = 1'b0;
//     2'b01: opB = 1'b0;
//     2'b10: opB = 1'b1;
//     2'b11: opB = 1'b1;
//endcase

//case (color [15:14])
//     2'b00: opG = 1'b0;
//     2'b01: opG = 1'b0;
//     2'b10: opG = 1'b1;
//     2'b11: opG = 1'b1;
//endcase

//case (color [23:22])
//     2'b00: opR = 1'b0;
//     2'b01: opR = 1'b0;
//     2'b10: opR = 1'b1;
//     2'b11: opR = 1'b1;
//endcase
//end

//Mini_ALU CALC_R(.color(color[23:20]), .OpCode(opR), .result(resultR));
//Mini_ALU CALC_G(.color(color[15:12]), .OpCode(opG), .result(resultG));
//Mini_ALU CALC_B(.color(color[7:4]), .OpCode(opB), .result(resultB));

//assign dithered [3:0] = resultB;
//assign dithered [7:4] = resultG;
//assign dithered [11:8] = resultR;
//endmodule

//module Mini_ALU 

//(    input logic [3:0] color, //operando 1
//     input logic  OpCode, //código de operacion
//    output logic [3:0] result //resultado
//                         //status=0 válida ; status=1 inválida
//    );
    
//    logic [4:0] result_temp;
//    always_comb begin
//        case(OpCode)
////            1'b0:  result_temp = color;
//            1'b0:  result_temp = color - 4'b0001 ;
//            1'b1:  result_temp = color + 4'b0001;
//            default :   result_temp = color;
//        endcase
//        if (result_temp[4]) result = color;
//        else result = result_temp[3:0];
//    end
    
//endmodule

module Dithering(
input logic [23:0] color,
output logic [11:0] dithered
    );
    
logic opR, opG, opB; // Operaciones para cada color (0 = restar 1 ; 1= sumar 1) 
logic [3:0] resultR , resultG , resultB; // resultados (4 bits por color)

always_comb begin

if (color [7:4]>'b0100) opB = 1'b0;
else opB = 1'b1;

if (color [15:14]>'b0100) opB = 1'b0;
else opG = 1'b1;

if (color [23:22]>'b0100) opB = 1'b0;
else opR = 1'b1;
//case (color [7:4]) //bits mas significativos
//     2'b0000: opB = 1'b0;
//     2'b0001: opB = 1'b0;
//     2'b0000: opB = 1'b0;
//     2'b0001: opB = 1'b0;
//     2'b10: opB = 1'b1;
//     2'b11: opB = 1'b1;
//endcase

//case (color [15:14])
//     2'b00: opG = 1'b0;
//     2'b01: opG = 1'b0;
//     2'b10: opG = 1'b1;
//     2'b11: opG = 1'b1;
//endcase

//case (color [23:22])
//     2'b00: opR = 1'b0;
//     2'b01: opR = 1'b0;
//     2'b10: opR = 1'b1;
//     2'b11: opR = 1'b1;
//endcase
end

Mini_ALU CALC_R(.color(color[23:16]), .OpCode(opR), .result(resultR));
Mini_ALU CALC_G(.color(color[15:8]), .OpCode(opG), .result(resultG));
Mini_ALU CALC_B(.color(color[7:0]), .OpCode(opB), .result(resultB));

assign dithered [3:0] = resultB;
assign dithered [7:4] = resultG;
assign dithered [11:8] = resultR;
endmodule

module Mini_ALU 

(    input logic [7:0] color, //operando 1
     input logic  OpCode, //código de operacion
    output logic [3:0] result //resultado
                         //status=0 válida ; status=1 inválida
    );
    
    logic [7:0] result_temp;
    always_comb begin
        case(OpCode)
//            1'b0:  result_temp = color;
           1'b0:  result_temp = color - 8'b00000011;
//            1'b0:  result_temp = color - 4'b0001 ;
            1'b1:  result_temp = color + 8'b00000011;
            default :   result_temp = color;
        endcase
        
        if (color <= 'd4) result = color[7:4];
        else if (color >= 8'hFB) result = color [7:4];
        else result = result_temp[7:4];
    end
    
endmodule

