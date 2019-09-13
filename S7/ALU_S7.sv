`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2019 18:03:28
// Design Name: 
// Module Name: ALU_S7
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


module ALU_S7(
    input logic CLK100MHZ, CPU_RESETN,
          logic [15:0] OP1, OP2,
          logic [2:0] ALU_ctrl,
          logic [3:0] state,
    output logic [15:0] result,
           logic CA, CB, CC, CD, CE, CF, CG,
           logic [7:0] AN
    );
    
    logic rst;
    assign rst= ~CPU_RESETN;
    
    //Integracion de la ALU.
    logic status;   //No se usa.
    logic [1:0] OpCode;
    assign OpCode = ALU_ctrl[1:0];
    
    ALU CALC(.OP1(OP1), .OP2(OP2), .OpCode(OpCode), .result(result), .status(status));
    
    //Control de displays.
    logic [31:0] bin;
    
    Display_ctrl_S7 DISPLAYCTRL (.OP1(OP1), .OP2(OP2), .result(result), .state(state), .o_bin(bin));
    
    logic [31:0] bcd;
    logic idleDD; //No se usa.
    logic trigger;
    assign trigger = 1;
    
    unsigned_to_bcd DOUBLEDABBLE(.clk(CLK100MHZ), .trigger(trigger), .in(bin), .bcd(bcd), .idle(idleDD));
    
    logic disp8, off;
    assign disp8 = 0;
    assign off = 0;
    logic [3:0] BCD0, BCD1, BCD2, BCD3, BCD4, BCD5, BCD6, BCD7;
    assign BCD0 = bcd[3:0];
    assign BCD1 = bcd[7:4];
    assign BCD2 = bcd[11:8];
    assign BCD3 = bcd[15:12];
    assign BCD4 = bcd[19:16];
    assign BCD5 = bcd[23:20];
    assign BCD6 = bcd[27:24];
    assign BCD7 = bcd[31:28];
    
    TDMsevenseg TDM (.BCD0(BCD0), .BCD1(BCD1), .BCD2(BCD2), .BCD3(BCD3), .BCD4(BCD4), .BCD5(BCD5), .BCD6(BCD6), .BCD7(BCD7), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .AN(AN), .reset(rst), .CLK100MHZ(CLK100MHZ), .disp8(disp8), .off(off));
    
endmodule
