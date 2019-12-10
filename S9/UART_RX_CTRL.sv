`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 22:48:19
// Design Name: 
// Module Name: UART_RX_CTRL
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


module UART_RX_CTRL(
    input logic clk, reset, rx_ready,
//          logic [7:0] rx_data,
    output logic r0, r1, r2,
//           logic [7:0] rx_data_out,
           logic enable,
           logic count
    );
    
    //estados
    enum logic [3:0] {Wait_R, Store_R, Wait_G, Store_G, Wait_B,
                      Store_B, Enable_BRAM, Add_1_count} state, next_state;
                      
    //Flip Flop
    always_ff @(posedge clk) begin 
        if(reset)
            state <= Wait_R;
        else
            state <= next_state;
    end
    
    //lógica FSM
    always_comb begin
    
    //default
        r0='b1; r1='b1; r2='b1; 
//        rx_data_out = rx_data;
        next_state = state;
        enable = 'b0;
        count = 'b0;
    
        case(state)
            
            Wait_R: begin
                if(rx_ready) next_state = Store_R;
            end
            
            Store_R: begin
                r0='b0;
                next_state = Wait_G;
            end
            
            Wait_G: begin
                if(rx_ready) next_state = Store_G;
            end
            
            Store_G: begin
                r1='b0;
                next_state = Wait_B;
            end
            
            Wait_B: begin
                if(rx_ready) next_state = Store_B;
            end
            
            Store_B: begin
                r2='b0;
                next_state = Enable_BRAM;
            end
            
            Enable_BRAM: begin
                enable = 'b1;
                next_state = Add_1_count;
            end
            
            Add_1_count: begin
                count = 'b1;
                next_state = Wait_R;
            end
                            
        endcase
    end
             
    
endmodule

