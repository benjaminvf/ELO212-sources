`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2019 21:09:35
// Design Name: 
// Module Name: RX_control_SE
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


module RX_control_SE(
    input logic rx_ready, CLK100MHZ, CPU_RESETN,
          logic [7:0] rx_data,
    output logic [7:0] rx_data_out,
           logic r0, r1, r2, r3, r4,
           logic trigger_tx,
           logic [3:0] c_state
    );
    
    //estados
    typedef enum logic [3:0] {Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result} state;
    state pr_state, next_state;                  
    //lógica para FSM
    always_comb begin 
    
       //default
       trigger_tx='b0;
       r0='b1; r1='b1; r2='b1; r3='b1; r4='b1;
       rx_data_out=rx_data;
       next_state=pr_state;
    
       case(pr_state)
    
          Wait_OP1_LSB: begin
             if(rx_ready) next_state=Store_OP1_LSB;
          end
        
          Store_OP1_LSB: begin
                r0='b0;
               next_state=Wait_OP1_MSB;
          end
        
          Wait_OP1_MSB: begin
              if(rx_ready) next_state=Store_OP1_MSB;
          end
        
          Store_OP1_MSB: begin
             r1='b0;
              next_state=Wait_OP2_LSB;
          end
        
          Wait_OP2_LSB: begin
              if(rx_ready) next_state=Store_OP2_LSB;
          end
        
          Store_OP2_LSB: begin
                r2='b0;
                next_state=Wait_OP2_MSB;
          end
        
          Wait_OP2_MSB: begin
                if(rx_ready) next_state=Store_OP2_MSB;
          end
        
          Store_OP2_MSB: begin
               r3='b0;
               next_state=Wait_CMD;
          end
        
          Wait_CMD: begin
                if(rx_ready) next_state=Store_CMD;
          end
        
          Store_CMD: begin
                r4='b0;
               next_state=Delay_1_cycle;
          end
        
          Delay_1_cycle: begin
              next_state=Trigger_TX_result;
          end
        
          Trigger_TX_result: begin
              trigger_tx='b1;
              next_state=Wait_OP1_LSB;
          end
        
       endcase
    end
    
    //Flip Flop
    always_ff @(posedge CLK100MHZ) begin 
        if(~CPU_RESETN)
            pr_state <= Wait_OP1_LSB;
        else
            pr_state <= next_state;
    end
   
    assign c_state=pr_state; 
        
endmodule

