`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 17:19:54
// Design Name: 
// Module Name: state_mux
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


module state_mux(
    input logic [2:0] state,
    input logic [15:0] in1,
    input logic [4:0] in2,
    output logic [15:0] val
    );
    
    always_comb begin
        case(state)
            'd0|'d2: val = in1;
            'd4: val = {11'd0,in2};
            default: val = in1;           
        endcase
    end
endmodule
