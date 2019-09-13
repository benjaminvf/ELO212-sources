`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2019 21:11:04
// Design Name: 
// Module Name: TOP_SE_UART
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


module TOP_SE_UART(
    input logic CLK100MHZ, CPU_RESETN, UART_TXD_IN,
    //Faltan inputs y uotputs de la UART.
    output logic CA, CB, CC, CD, CE, CF, CG, UART_RXD_OUT,
           logic [7:0] AN,
           logic [15:0] LED,
           logic [2:1] JA
    );
    
    logic reset;
    assign reset = ~CPU_RESETN;
    
    //UART.
    logic rx_ready, tx_start, tx_busy;
    logic [7:0] rx_data, tx_data;
        
    uart_basic UART(.clk(CLK100MHZ), .reset(reset), .rx(UART_TXD_IN), .rx_data(rx_data), .rx_ready(rx_ready), .tx(UART_RXD_OUT), .tx_start(tx_start), .tx_data(tx_data), .tx_busy(tx_busy));
        
    //RX control, hay que agregar el busy de la UART.
    logic [7:0] rx_data_out;
    logic r0, r1, r2, r3, r4;
    logic trigger_tx;
    logic [3:0] rx_state;
    
    RX_control_SE RX_CTRL(.rx_ready(rx_ready), .CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .rx_data(rx_data), .rx_data_out(rx_data_out), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .trigger_tx(trigger_tx), .c_state(rx_state));
    
    //Banco de datos.
    logic [15:0] OP1, OP2; 
    logic [2:0] ALU_ctrl;
    
    ALU_Bank_S7 BANCO(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .SW(rx_data_out), .operando1(OP1), .operando2(OP2), .ALU_ctrl(ALU_ctrl));
    
    //ALU + Displays.
    logic [15:0] result;
    
    ALU_S7 CALC(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .OP1(OP1), .OP2(OP2), .ALU_ctrl(ALU_ctrl), .state(rx_state), .result(result),  .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .AN(AN));
    
    //TX control
    TX_control_SE TX_CTRL(.clock(CLK100MHZ), .reset(reset), .trigger_tx(trigger_tx), .dataIn16(result), .tx_data(tx_data), .tx_start(tx_start));
    
    //State LEDs.
    always_comb begin
        case(rx_state)
            0: LED = 'd1;
            1: LED = 'd3;
            2: LED = 'd7;
            3: LED = 'd15;
            4: LED = 16'b11111;
            5: LED = 16'b111111;
            6: LED = 16'b1111111;
            7: LED = 16'b11111111;
            8: LED = 16'b111111111;
            9: LED = 16'b1111111111;
            10: LED = 16'b11111111111;
            11: LED = 16'b111111111111;
            default: LED = 'd0;
         endcase end
     
    assign JA[1] = UART_TXD_IN;
    assign JA[2] = UART_RXD_OUT; 
     
endmodule
