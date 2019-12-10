`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 16:26:16
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter N='d16) //bits operandos ALU
(    input logic [N-1:0] OP1, //operando 1
          logic [N-1:0] OP2, //operando 2
          logic [3:0] OpCode, //código de operacion
    output logic [N-1:0] result //resultado
           //,logic status  //estado operacion (valida o no)
                         //status=0 válida ; status=1 inválida
    );
    
    logic [N:0] result_temp;
    always_comb begin
        case(OpCode)
            5'b0000:  result_temp = OP1+OP2;
            5'b0100:  result_temp = OP1-OP2;
            5'b0010:  result_temp = OP1&OP2;
            5'b0101:  result_temp = OP1|OP2;
            5'b0001:  result_temp = OP1*OP2;
            default :   result_temp = OP1+OP2;
        endcase
    end
    
    assign result = result_temp[N-1:0];
    //la siguiente parte se utiliza para verificar la existencia de overflow
    //está pensada sólo para ingreso de operandos positivos
        
//    always_comb begin // verifica overflow en la suma.
//        if (OpCode == 0) status = result_temp[N];
//        else status = 0;    
//    end   
    
endmodule

