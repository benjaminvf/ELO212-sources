`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 19:14:38
// Design Name: 
// Module Name: Cursor_to_Bank
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


module Cursor_to_Bank(
    input logic [4:0] val,
          logic BTNCp,
          logic [2:0] state,
          logic rst, rst_s,
          logic clk, mode,
    output logic EXE, CLR, CE,
           logic [15:0] op
    );
    logic [3:0] num;
    logic ok;
    logic [4:0] operation1;
    
    Detector Detector(.clk(clk), .val(val), .BTNCp(BTNCp), .num(num), .ok(ok), .EXE(EXE), .CLR(CLR), .CE(CE),
                        .operation(operation1));
    
    logic RST; //reset del shift
    assign RST = (rst) | (rst_s) | (CE) | (CLR);
    
    logic [15:0] NUM; //número que entra al mux
    
    shift_register shift( .clk(clk), .mode(mode), .BTN(ok), .rst(RST), .sin(num), .q(NUM));
    
//    logic [15:0] NUM_hex, NUM_f;
//    Dec_to_hex DECHEX (.dec(NUM), .hex(NUM_hex));
    
//    always_comb begin
//        if(mode) NUM_f = NUM_hex;
//        else NUM_f = NUM;
//    end
    
    state_mux mux(.state(state), .in1(NUM), .in2(operation1), .val(op));
    
endmodule

