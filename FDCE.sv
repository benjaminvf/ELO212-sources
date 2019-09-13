`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 18:41:32
// Design Name: 
// Module Name: FDCE
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


module FDCE #(parameter N=16)
(	input  logic           clk,
	input  logic           RST_BTN_n,
	input  logic   [N-1:0] switches,
	input  logic           retain,
	output logic   [N-1:0] leds
);

    logic [N-1:0] Q, Q_next;
    logic reset;
    
    assign reset = ~RST_BTN_n;
    assign leds = Q;

	always_ff @(posedge clk) begin
	   if (reset) begin
	       Q <= 2'd0;
	   end else begin
	       Q <= Q_next;
	   end
	end

	always_comb begin
        Q_next = Q;
 
		case (retain)
		  1'b0: 	  Q_next = switches;
		  1'b1: 	  ;
        endcase
	end

endmodule