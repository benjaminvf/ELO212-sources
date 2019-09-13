`timescale 1ns / 1ps
//Hecho para conversor bcd hec anodo común (se enciende en 0).
module BCD_sevSeg_hex(
    input logic [3:0] BCD_in,
    output logic [6:0] sevSeg
    );
    
    always_comb begin   //Se definen las salidas en Seven Segment.
        case(BCD_in)
            4'h0:   sevSeg=7'b0000001;
            4'h1:   sevSeg=7'b1001111;
            4'h2:   sevSeg=7'b0010010;
            4'h3:   sevSeg=7'b0000110;
            4'h4:   sevSeg=7'b1001100;
            4'h5:   sevSeg=7'b0100100;
            4'h6:   sevSeg=7'b0100000;
            4'h7:   sevSeg=7'b0001111;
            4'h8:   sevSeg=7'b0000000;
            4'h9:   sevSeg=7'b0000100;
            4'hA:   sevSeg=7'b0001000;
            4'hB:   sevSeg=7'b1100000;
            4'hC:   sevSeg=7'b0110001;
            4'hD:   sevSeg=7'b1000010;
            4'hE:   sevSeg=7'b0110000;
            4'hF:   sevSeg=7'b0111000;
            default: sevSeg=7'b1111111;           
        endcase
    end
endmodule
