`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 23:17:20
// Design Name: 
// Module Name: TOP_Disp
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


module TOP_Disp #(parameter N = 16)
(
    input logic CLK100MHZ, CPU_RESETN, BTNU, BTNR,
          logic [N-1:0] OP1, OP2, result,
          logic [1:0] state,
    output logic CA, CB, CC, CD, CE, CF, CG,
           logic [7:0] AN 
    );
    
    //Se "limpian" los botones.
    logic BTNUp, BTNUc, BTNRp, BTNRc;
    logic BTNUdown, BTNRdown; //No se usan.
    logic rst;
    assign rst= ~CPU_RESETN;
    
    PB_Debouncer_counter BTNUdebounce(.clk(CLK100MHZ), .rst(rst), .PB(BTNU), .PB_pressed_status(BTNUc), .PB_pressed_pulse(BTNUp), .PB_released_pulse(BTNUdown));
    PB_Debouncer_counter BTNRdebounce(.clk(CLK100MHZ), .rst(rst), .PB(BTNR), .PB_pressed_status(BTNRc), .PB_pressed_pulse(BTNRp), .PB_released_pulse(BTNRdown));
    
    //Instancia del controlador, decide que se muestra segun estado.
    logic [31:0] bin;
    logic disp8, off;
    
    Disp_in_ctrl CONTROL(.OP1(OP1), .OP2(OP2), .result(result), .state(state), .BTNR(BTNRc), .o_bin(bin), .disp8(disp8), .off(off));
    
    //Conversion a BCD cuando es necesario.
    logic [31:0] bcd;
    logic idleDD; //No se usa.
    
    unsigned_to_bcd DOUBLEDABBLE(.clk(CLK100MHZ), .trigger(BTNUp), .in(bin), .bcd(bcd), .idle(idleDD));
    
    // Seleccion entre hexa y decimal.
    logic [31:0] to_display;
    
    Disp_hex_dec HEXDEC(.BTNU(BTNUc), .bcd(bcd), .bin(bin), .to_display(to_display));
    
    // TDM para 8 displays.
    logic [3:0] BCD0, BCD1, BCD2, BCD3, BCD4, BCD5, BCD6, BCD7;
    assign BCD0 = to_display[3:0];
    assign BCD1 = to_display[7:4];
    assign BCD2 = to_display[11:8];
    assign BCD3 = to_display[15:12];
    assign BCD4 = to_display[19:16];
    assign BCD5 = to_display[23:20];
    assign BCD6 = to_display[27:24];
    assign BCD7 = to_display[31:28];
    
    TDMsevenseg TDM (.BCD0(BCD0), .BCD1(BCD1), .BCD2(BCD2), .BCD3(BCD3), .BCD4(BCD4), .BCD5(BCD5), .BCD6(BCD6), .BCD7(BCD7), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .AN(AN), .reset(rst), .CLK100MHZ(CLK100MHZ), .disp8(disp8), .off(off));
    
endmodule
