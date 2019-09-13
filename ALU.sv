`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 18:42:34
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
          logic [1:0] OpCode, //código de operacion
    output logic [N-1:0] result, //resultado
           logic status  //estado operacion (valida o no)
                         //status=0 válida ; status=1 inválida
    );
    
    logic [N:0] result_temp;
    always_comb begin
        case(OpCode)
            2'b00:  result_temp = OP1+OP2;
            2'b01:  result_temp = OP1-OP2;
            2'b10:  result_temp = OP1&OP2;
            2'b11:  result_temp = OP1|OP2;
        endcase
    end
    
    assign result = result_temp[N-1:0];
    //la siguiente parte se utiliza para verificar la existencia de overflow
    //está pensada sólo para ingreso de operandos positivos
        
    always_comb begin // verifica overflow en la suma.
        if (OpCode == 0) status = result_temp[N];
        else status = 0;    
    end   
    
endmodule
