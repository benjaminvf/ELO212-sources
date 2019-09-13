`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2019 18:14:34
// Design Name: 
// Module Name: Display_ctrl_S7
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

module Display_ctrl_S7 #(parameter N = 16)
(
    input logic [N-1:0] OP1, OP2, result,
          logic [3:0] state,
    output logic [31:0] o_bin
    );
    
    always_comb begin
    case(state)
        'd0: o_bin = {16'b0,result};
        'd1: o_bin = {16'b0,result};
        'd2: o_bin = {16'b0,result};
        'd3: o_bin = {16'b0,result};
        'd4: o_bin = {16'b0,OP1};
        'd5: o_bin = {16'b0,OP1};
        'd6: o_bin = {16'b0,OP1};
        'd7: o_bin = {16'b0,OP1};
        'd8: o_bin = {16'b0,OP2};
        'd9: o_bin = {16'b0,OP2};
        'd10: o_bin = {16'b0,result};
        'd11: o_bin = {16'b0,result};
        default: o_bin = 'b0;
    endcase
    end
    
endmodule
