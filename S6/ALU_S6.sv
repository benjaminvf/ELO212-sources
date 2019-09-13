`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2019 00:56:50
// Design Name: 
// Module Name: ALU_S6
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

//Error valores en decimal y BTNU&BTNR.
module ALU_S6(
    input  logic CLK100MHZ, CPU_RESETN, BTNC, BTNU, BTND, BTNR,
           logic [15:0] SW,
    output logic CA, CB, CC, CD, CE, CF, CG,
           logic [7:0] AN,
           logic [15:0] LED,
           logic LED16_R, LED16_G
    );
    
    //Se "limpian" los botones.
    logic BTNCp, BTNCc, BTNDp, BTNDc;
    logic BTNCdown, BTNDdown; //No se usan.
    logic rst;
    assign rst= ~CPU_RESETN;
    
    PB_Debouncer_counter BTNCdebounce(.clk(CLK100MHZ), .rst(rst), .PB(BTNC), .PB_pressed_status(BTNCc), .PB_pressed_pulse(BTNCp), .PB_released_pulse(BTNCdown));
    PB_Debouncer_counter BTNDdebounce(.clk(CLK100MHZ), .rst(rst), .PB(BTND), .PB_pressed_status(BTNDc), .PB_pressed_pulse(BTNDp), .PB_released_pulse(BTNDdown));
    
    //FSM que controla las etapas.
    logic r0, r1, r2;
    logic [1:0] state;
    
    ALU_FSM FSM(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .BTNC(BTNCp), .BTND(BTNDp), .r0(r0), .r1(r1), .r2(r2), .c_state(state));
    
    //Banco de datos.
    logic [15:0] OP1, OP2;
    logic [1:0] OpCode;
    
    ALU_Bank BANCO(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .r0(r0), .r1(r1), .r2(r2), .SW(SW), .OP1(OP1), .OP2(OP2), .OpCode(OpCode));
    
    //Integracion de la ALU.
    logic [15:0] result;
    logic status;
    
    ALU CALC(.OP1(OP1), .OP2(OP2), .OpCode(OpCode), .result(result), .status(status));
    
    //Conexion a displays.
    TOP_Disp DISPLAY(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .BTNU(BTNU), .BTNR(BTNR), .OP1(OP1), .OP2(OP2), .result(result), .state(state), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .AN(AN));
    
    StateLEDs STATELED(.c_state(state), .LED(LED), .OpCode(OpCode), .result(result));
    
    //LED de error.
    always_comb begin
    if ((status ||(BTNU & BTNR)) & (state == 3)) begin
        LED16_R = 1;
        LED16_G = 0;
    end else if (state == 3) begin
        LED16_R = 0;
        LED16_G = 1;
    end else begin
        LED16_R = 0;
        LED16_G = 0;
    end end
    
endmodule
