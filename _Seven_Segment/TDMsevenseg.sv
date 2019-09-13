`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2019 17:20:38
// Design Name: 
// Module Name: TDMsevenseg
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

//Time Divided Multiplexer Seven Segment para 4 sevSeg a 30Hz.
//Se necesitan los  clock30Hz, counter2bits, BCD_sevSeg_hex.
module TDMsevenseg(
input logic CLK100MHZ, reset,
    logic disp8,//high es 8 display y low es 4.
    logic off, //apaga todos los displays
    logic [3:0] BCD0, BCD1, BCD2, BCD3, BCD4, BCD5, BCD6, BCD7,  //para usar mas sevSeg se agregan mas variables BCD.
output logic CA,
    logic CB,
    logic CC,
    logic CD,
    logic CE,
    logic CF,
    logic CG,
    logic [7:0] AN  
    );
    
    logic clk30;
    logic [2:0] count;  //para usar mas sevSeg se aumentan los bits.
    logic [6:0] sev0;   //para usar mas sevSeg se agregan mas variables sev.
    logic [6:0] sev1;
    logic [6:0] sev2;
    logic [6:0] sev3, sev4, sev5, sev6, sev7;
    logic [6:0] C;
    
    clock30Hz CLOCK (.clk_in(CLK100MHZ), .reset(reset), .clk_out(clk30));
    //counter de 3 bits aunque diga lo contrario.
    counter2bit COUNT (.clock(clk30), .reset(reset), .count(count));    //para usar mas sevSeg se aumentan los bits.
    BCD_sevSeg_hex CON0 (.BCD_in(BCD0), .sevSeg(sev0));                 //para usar mas sevSeg se agregan mas instancias.
    BCD_sevSeg_hex CON1 (.BCD_in(BCD1), .sevSeg(sev1));
    BCD_sevSeg_hex CON2 (.BCD_in(BCD2), .sevSeg(sev2));
    BCD_sevSeg_hex CON3 (.BCD_in(BCD3), .sevSeg(sev3));
    BCD_sevSeg_hex CON4 (.BCD_in(BCD4), .sevSeg(sev4));
    BCD_sevSeg_hex CON5 (.BCD_in(BCD5), .sevSeg(sev5));
    BCD_sevSeg_hex CON6 (.BCD_in(BCD6), .sevSeg(sev6));
    BCD_sevSeg_hex CON7 (.BCD_in(BCD7), .sevSeg(sev7));
    
    //Logica de encendido de display (8, 5 o 4).
    logic [1:0]all;
    always_comb begin
        if (disp8) all = 2'b10;
        else if (~(BCD4==0)) all = 2'b01;
        else all = 2'b00;
    end
    
    //Muxs.
    always_comb begin
        if (off) begin  //apaga los displays.
                    AN = 'b11111111;
                    C = 0;
        end else begin
        case(all)
            2'b00: begin   //para 4 displays.
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: AN = 8'b11111110;
                3'b001: AN = 8'b11111101;
                3'b010: AN = 8'b11111011;
                3'b011: AN = 8'b11110111;
                default: AN = 8'b11111111;
            endcase
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: C = sev0;
                3'b001: C = sev1;
                3'b010: C = sev2;
                3'b011: C = sev3;
                default: C = 'b0;
            endcase end
            2'b01:begin    //para 5 displays.
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: AN = 8'b11111110;
                3'b001: AN = 8'b11111101;
                3'b010: AN = 8'b11111011;
                3'b011: AN = 8'b11110111;
                3'b100: AN = 8'b11101111;
                default: AN = 8'b11111111;
            endcase
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: C = sev0;
                3'b001: C = sev1;
                3'b010: C = sev2;
                3'b011: C = sev3;
                3'b100: C = sev4;
                default: C = 'b0;
            endcase end
            2'b10:begin    //para 8 displays.
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: AN = 8'b11111110;
                3'b001: AN = 8'b11111101;
                3'b010: AN = 8'b11111011;
                3'b011: AN = 8'b11110111;
                3'b100: AN = 8'b11101111;
                3'b101: AN = 8'b11011111;
                3'b110: AN = 8'b10111111;
                3'b111: AN = 8'b01111111;
                default: AN = 8'b11111111;
            endcase
            case (count)    //para usar mas sevSeg se agregan mas casos.
                3'b000: C = sev0;
                3'b001: C = sev1;
                3'b010: C = sev2;
                3'b011: C = sev3;
                3'b100: C = sev4;
                3'b101: C = sev5;
                3'b110: C = sev6;
                3'b111: C = sev7;
                default: C = 'b0;
            endcase end
            default: begin
                AN = 'b11111111;
                C = 0;
                end
         endcase end
    end
     
    //Se asignan las salidas para el display.     
    assign CA = C[6];
    assign CB = C[5];
    assign CC = C[4];
    assign CD = C[3];
    assign CE = C[2];
    assign CF = C[1];
    assign CG = C[0];
            
endmodule
