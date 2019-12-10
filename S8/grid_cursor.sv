`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2018 11:14:16 PM
// Design Name: 
// Module Name: grid_cursor
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

/**
 * @brief	Este modulo implementa cursor de coordenadas pos_x, pos_y
 * En terminos generales si se presenta pulso en dir_up,
 * la coordenada pos_y disminuirá en una unidad y si se presenta un pulso en dir_right
 * la coordenada pos_x aumentará en una unidad.

 * @param clk		: Se debe utilizar el mismo clk del VGA.
 * @param rst		: El reset
 * @param restricion: esta señal se utiliza para definir zonas prohibidas en la cuadrilla
 * cuando se esté en modo DEC (decimal)
 * @param dir_up	: pulso de un ciclo de reloj para mover el cursor hacia arriba.
 * @param dir_down	: pulso de un ciclo de reloj para mover el cursor hacia abajo.
 * @param dir_left	: pulso de un ciclo de reloj para mover el cursor hacia la izquierda.
 * @param dir_right	: pulso de un ciclo de reloj para mover el cursor hacia la derecha.
 * @param pos_x		: coordenada x del cursor.
 * @param pos_y		: coordenada y del cursor.
 * @param val		: Corresponde a una variable que indica el dígito o función seleccionado
 *                    por la posición actual del cursor
 *
 */
module grid_cursor(
    input logic clk, rst, mode,
    input logic restriction,
    input logic dir_up, dir_down, dir_left, dir_right,
    output logic [2:0] pos_x,
    output logic [1:0] pos_y,
    output logic [4:0] val
    );
    
    logic [2:0]pos_x_next;
    logic [1:0]pos_y_next;

    logic [1:0] ff;
    logic [1:0]count_ne;
    logic restriction_ne;
    
//definici�n de val
    always_comb begin
        case(pos_x)
            3'd0:
                    case(pos_y)
                        2'd0: val = 5'd0;
                        2'd1: val = 5'd4;
                        2'd2: val = 5'd8;
                        2'd3: val = 5'hc;
                    endcase
            3'd1:
                    case(pos_y)
                        2'd0: val = 5'd1;
                        2'd1: val = 5'd5;
                        2'd2: val = 5'd9;
                        2'd3: val = 5'hd;
                    endcase
        
            3'd2:
                    case(pos_y)
                        2'd0: val = 5'd2;
                        2'd1: val = 5'd6;
                        2'd2: val = 5'ha;
                        2'd3: val = 5'he;
                    endcase
            3'd3:
                    case(pos_y)
                        2'd0: val = 5'd3;
                        2'd1: val = 5'd7;
                        2'd2: val = 5'hb;
                        2'd3: val = 5'hf;
                    endcase
            3'd4:
                    case(pos_y)
                        2'd0: val = 5'b1_0000;//suma
                        2'd1: val = 5'b1_0001;//mult
                        2'd2: val = 5'b1_0010;//and
                        2'd3: val = 5'b1_0011;//EXE
                    endcase
            3'd5:
                    case(pos_y)
                        2'd0: val = 5'b1_0100;//resta
                        2'd1: val = 5'b1_0101;//or
                        2'd2: val = 5'b1_0110;//CE
                        2'd3: val = 5'b1_0111;//CLR
                    endcase
            default:
                    val = 5'h1F;
        endcase
    end
    
    always_comb begin
    
    //contador
        if(dir_up) pos_y_next = pos_y - 'd1;
        
        else if(dir_down) pos_y_next = pos_y + 'd1;
        
        else pos_y_next = pos_y;
        
        if(dir_left) pos_x_next = pos_x - 'd1;
        
        else if(dir_right) pos_x_next = pos_x + 'd1;
         
        else pos_x_next = pos_x;  
     //lo que sucede cuando el cursor est� en alg�n extremo    
//        else if((pos_x >= 3'd5) && (dir_right))
//            pos_x_next = 3'd0;
//        else if((pos_x == 3'd0) && (dir_left))
//            pos_x_next = 3'd5;
//        else if((pos_y == 2'd3) && (dir_down))
//            pos_y_next = 2'd0;
//        else if((pos_y == 2'd0) && (dir_up))
//            pos_y_next = 2'd3;
            
        //default
//        else begin
//            pos_y_next = pos_y;
//            pos_x_next = pos_x; 
//            end
    end
    
    always_ff @(posedge clk) begin
        if(rst) begin
            pos_x <= 3'd0; pos_y <= 2'd0;
            end
            
        else begin
//            if (pos_x_next == 'd6) pos_x = 0;
//            else if (pos_x_next == 'd7) pos_x = 5;
            if (mode) begin
                if (pos_x_next == 'd6) pos_x = 0;
                else if (pos_x_next == 'd7) pos_x = 5;
                else if (pos_y_next == 'd2) begin
                    if ((pos_x_next == 'd2) | (pos_x_next == 'd3)) begin
                        pos_x <= 'd0; pos_y <= 'd0;
                    end
                    else begin
                        pos_x <= pos_x_next; pos_y <= pos_y_next;
                    end
                end
                else if (pos_y_next == 'd3) begin
                    if ((pos_x_next == 'd0) | (pos_x_next == 'd1) |
                        (pos_x_next == 'd2) | (pos_x_next == 'd3)) begin
                        pos_x <= 'd0; pos_y <= 'd0;
                    end
                    else begin
                        pos_x <= pos_x_next; pos_y <= pos_y_next;
                    end
                end
                else begin
                    pos_x <= pos_x_next; pos_y <= pos_y_next;
                end
            end
            else begin
            if (pos_x_next == 'd6) pos_x = 0;
            else if (pos_x_next == 'd7) pos_x = 5;
            else begin
               pos_x <= pos_x_next;
               pos_y <= pos_y_next;
            end end
        end
    end
endmodule



