`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 23:16:05
// Design Name: 
// Module Name: Disp_in_ctrl
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


module Disp_in_ctrl #(parameter N = 16)
(
    input logic [N-1:0] OP1, OP2, result,
          logic [1:0] state,
          logic BTNR,
    output logic [31:0] o_bin,
           logic disp8, off 
    );
    
    always_comb begin
        case(state)
            0: begin 
                    o_bin = {16'b0,OP1};
                    disp8 = 0;
                    off = 0;
               end
            1: begin
                    o_bin = {16'b0,OP2};
                    disp8 = 0;
                    off = 0;
               end
            2: begin
                    o_bin = 0;
                    disp8 = 0;
                    off = 1;
               end
            3:  begin
                    if (BTNR) begin
                        o_bin = {OP1[15:0],OP2[15:0]};
                        disp8 = 1;
                        off = 0;
                    end
                    else begin 
                        o_bin = {16'b0, result};
                        disp8 = 0;
                        off = 0;
                    end
                end
            default: begin
                        o_bin = 0;
                        disp8 = 0;
                        off = 0;
                     end
        endcase
    end
    
endmodule
