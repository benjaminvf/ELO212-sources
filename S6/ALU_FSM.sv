`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2019 17:48:26
// Design Name: 
// Module Name: ALU_FSM
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


module ALU_FSM(
    input logic CLK100MHZ, CPU_RESETN, BTNC, BTND,
    output logic r0, r1, r2,
           logic [1:0] c_state           
    );
 
 // Se definen los estados.   
 typedef enum logic [2:0] {OP1,OP2, OPERATION, RESULT} state;
 state pr_state, nx_state;
 
 // Flip-Flop.
 always_ff @(posedge CLK100MHZ, posedge CPU_RESETN) begin
    if (~CPU_RESETN)    pr_state <= OP1; 
    else    pr_state <= nx_state;
 end
 
 // Logica de estados y outputs.
 always_comb begin
    case(pr_state)
        OP1:begin
                r0 = 0;
                r1 = 1;
                r2 = 1;
                c_state = 'b00;
                if (BTNC) nx_state = OP2;
                else nx_state = OP1;        
            end
        OP2:begin
                r0 = 1;
                r1 = 0;
                r2 = 1;
                c_state = 'b01;
                if (BTNC & ~BTND) nx_state = OPERATION;
                else if (BTND & ~BTNC) nx_state = OP1;
                else nx_state = OP2;        
            end
        OPERATION:begin
                r0 = 1;
                r1 = 1;
                r2 = 0;
                c_state = 'b10;
                if (BTNC & ~BTND) nx_state = RESULT;
                else if (BTND & ~BTNC) nx_state = OP2;
                else nx_state = OPERATION;        
            end
        RESULT:begin
                r0 = 1;
                r1 = 1;
                r2 = 1;
                c_state = 'b11;
                if (BTNC & ~BTND) nx_state = OP1;
                else if (BTND & ~BTNC) nx_state = OPERATION;
                else nx_state = RESULT;        
            end
        default:begin
                    r0 = 1;
                    r1 = 1;
                    r2 = 1;
                    nx_state = OP1;
                    c_state = 'b00;
                end
    endcase      
 end
    
endmodule
