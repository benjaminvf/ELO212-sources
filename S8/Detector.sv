`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 18:16:17
// Design Name: 
// Module Name: Detector
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


module Detector(
    input logic [4:0] val,
          logic BTNCp, clk,
    output logic [3:0] num,
           logic [4:0] operation,
           logic EXE, CE, CLR, ok
    );
    
    logic [3:0] nx_num;
    logic [4:0] nx_operation;
    logic nx_EXE, nx_CE, nx_CLR, nx_ok;
    
    always_comb begin
        if (BTNCp)begin
            if (val[4] == 1) begin //si es operación (o EXE, CE, CLR)
                nx_num = 'b0; nx_ok = 'b0;
                case (val)
                    5'b1_0011:begin
                        nx_operation = operation;
                        nx_EXE = 'd1; nx_CE = 'd0; nx_CLR = 'd0;
                    end
                    
                    5'b1_0110:begin
                        nx_operation = 'd0;
                        nx_EXE = 'd0; nx_CE = 'd1; nx_CLR = 'd0;
                    end
                    
                    5'b1_0111:begin
                        nx_operation = operation;
                        nx_EXE = 'd0; nx_CE = 'd0; nx_CLR = 'd1;
                    end
                    
                    default: begin
                        nx_operation = val;
                        nx_EXE = 'd0; nx_CE = 'd0; nx_CLR = 'd0;
                    end
                endcase
            end
            else begin //si es número
                nx_EXE='d0; nx_CE='d0; nx_CLR='d0;
                nx_operation='d0;
                nx_num = val[3:0];
                nx_ok='d1;
            end
        end
        else begin //si botón no presionado
            nx_EXE='d0; nx_CE='d0; nx_CLR='d0;
            nx_operation = operation;
            nx_num = val[3:0];
            nx_ok='d0;
        end
    end
    
    always_ff @(posedge clk) begin
        num = nx_num;
        operation = nx_operation;
        EXE = nx_EXE;
        CLR = nx_CLR;
        CE = nx_CE;
        ok = nx_ok;
    end           
    
endmodule

