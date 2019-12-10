`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2019 00:17:09
// Design Name: 
// Module Name: Add_counter
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


module Add_counter(
    input logic count, reset, clk,
    output logic [17:0] addra
    );
    
    always_ff @(posedge clk) begin
        if(reset || addra == 'd196608) addra <= 'b0;
        else begin
            if (count) addra <= addra + 'b1;
            else addra <= addra;
        end
    end    
endmodule
