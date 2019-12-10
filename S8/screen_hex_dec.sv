`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 16:39:10
// Design Name: 
// Module Name: screen_hex_dec
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


module screen_hex_dec(
input logic switch, clk, trigger,
input logic [15:0] op1,
input logic [15:0] op2,
input logic [15:0] input_screen,
output logic [19:0] outputscreen,
output logic [19:0] outputop1,
output logic [19:0] outputop2
    );
logic [31:0] outputbcd1 ;
logic [31:0] outputbcd2 ;
logic [31:0] outputbcdscreen ;
logic idle1, idle2, idle3;

unsigned_to_bcd ob1 (.clk(clk), .trigger(trigger),.in({16'b0,op1}),.bcd(outputbcd1), .idle(idle1));
unsigned_to_bcd ob2 (.clk(clk), .trigger(trigger),.in({16'b0,op2}),.bcd(outputbcd2), .idle(idle2));
unsigned_to_bcd os (.clk(clk), .trigger(trigger),.in({16'b0,input_screen}),.bcd(outputbcdscreen), .idle(idle3));

always_comb begin
    if (switch) begin
        outputscreen = outputbcdscreen [19:0];
        outputop1 = outputbcd1 [19:0];
        outputop2 = outputbcd2 [19:0];
    end
    else begin
    outputop1 = {4'b0,op1};
    outputop2 = {4'b0,op2};
    outputscreen = {4'b0,input_screen};
    end
end
endmodule

