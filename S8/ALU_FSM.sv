`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2019 15:43:22
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
    input logic CLK100MHZ, CPU_RESETN, EXE, BTND,CLR,
    output logic r0, r1, r2, rst_s,
           logic [2:0] c_state           
    );
 
 // Se definen los estados.   
 typedef enum logic [2:0] {OP1,delay1,OP2,delay2, OPERATION, RESULT} state;
 state pr_state, nx_state;
 
 logic rst;
 assign rst = ~CPU_RESETN;
 // Flip-Flop.
 always_ff @(posedge CLK100MHZ) begin
    if (rst | CLR)    pr_state <= OP1; 
    else    pr_state <= nx_state;
 end
 
 // Logica de estados y outputs.
 always_comb begin
    rst_s = 0;
    case(pr_state)
        OP1:begin
                r0 = 0;
                r1 = 1;
                r2 = 1;
                c_state = 'b000;
                if (EXE) nx_state = delay1;
                else nx_state = OP1;        
            end
         delay1:begin
                r0 = 1;
                r1 = 1;
                r2 = 1;
                rst_s = 1;
                c_state = 'b001;
                nx_state = OP2;
            end
            
        OP2:begin
                r0 = 1;
                r1 = 0;
                r2 = 1;
                c_state = 'b010;
                if (EXE) nx_state = delay2;
                else nx_state = OP2;        
            end
          delay2:begin
                r0 = 1;
                r1 = 1;
                r2 = 1;
                rst_s = 1;
                c_state = 'b011;
                nx_state = OPERATION;        
            end
            
        OPERATION:begin
                r0 = 1;
                r1 = 1;
                r2 = 0;
                c_state = 'b100;
                if (EXE) nx_state = RESULT;
                else nx_state = OPERATION;        
            end
        RESULT:begin
                r0 = 1;
                r1 = 1;
                r2 = 1;
                rst_s = 1;
                c_state = 'b101;
                if (EXE) nx_state = OP1;
                else nx_state = RESULT;        
            end
        default:begin
                    r0 = 1;
                    r1 = 1;
                    r2 = 1;
                    nx_state = OP1;
                    c_state = 'b000;
                end
    endcase      
 end
    
endmodule

