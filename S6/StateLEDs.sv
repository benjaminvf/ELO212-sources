`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 20:42:32
// Design Name: 
// Module Name: StateLEDs
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


module StateLEDs(
    input logic [1:0] c_state, OpCode,
          logic [15:0] result,
    output logic [15:0] LED
    );
    
    always_comb begin
        case(c_state)
            0: LED = 'd1;
            1: LED = 'd3;
            2: LED = 'd7;
            3: begin
                if((OpCode == 'd2)||(OpCode == 'd3)) LED = result;
                else LED = 'd15;
               end
            default: LED = 'd0;
        endcase
    end   
endmodule
