`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 16:30:31
// Design Name: 
// Module Name: shift_register
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


module shift_register #(parameter N = 16)
(
    input logic clk, BTN, rst, mode,
          logic [3:0] sin,
    output logic [N-1:0] q 
    );
    
//    logic [N-1:0] q_hex, q_dec;
    
//    always_ff @(posedge clk) begin
//        if(rst) begin
//            q_dec = 0;
//            q_hex = 0;
//        end else if (BTN) begin
//            q_dec = q_dec*10 + sin;
//            q_hex = q_hex*16 + sin;
////        q = {q[N-5:0],sin};
//        end else begin
//            q_dec = q_dec;
//            q_hex = q_hex;
//            end
//    end  
    
//    always_comb begin
//        if (mode) q = q_dec;
//        else q = q_hex;
//    end    
     always_ff @(posedge clk) begin
        if(rst) q = 'd0;
        else if(BTN)
            if (mode) q = q*10 + sin;
            else q = q*16 + sin;
        else q = q;
     end
endmodule
