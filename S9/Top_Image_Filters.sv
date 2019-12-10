`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2019 18:39:33
// Design Name: 
// Module Name: Top_Image_Filters
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


module Top_Image_Filters(
 input logic CLK100MHZ, CPU_RESETN, UART_TXD_IN,
 input logic [15:0] SW,
 output logic VGA_HS,
 output logic VGA_VS,
 output logic [3:0] VGA_R,
 output logic [3:0] VGA_G,
 output logic [3:0] VGA_B
 );
logic reset;
assign reset = ~CPU_RESETN;

logic clk82;
logic locked;

clk_82 clock82
   (
    // Clock out ports
    .clk_out1(clk82),     // output clk_out1
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(CLK100MHZ)); 

// UART
    logic rx_ready, tx_start;
    logic [7:0] rx_data, tx_data;
        
uart_basic UART(.clk(CLK100MHZ), .reset(reset), .rx(UART_TXD_IN), .rx_data(rx_data), .rx_ready(rx_ready));

//logic [7:0] rx_data_out;
    logic r0, r1, r2;
    logic enable;
    logic count;
    logic [23:0] RAM_in;
    
UART_RX_CTRL RX_CTRL(.rx_ready(rx_ready), .clk(CLK100MHZ), .reset(reset),
//         .rx_data(rx_data), 
//         .rx_data_out(rx_data_out),
         .r0(r0), .r1(r1), .r2(r2), .enable(enable), .count(count));

Pixel_Bank bank (.r0(r0), .r1(r1), .r2(r2),.clk(CLK100MHZ), .reset(CPU_RESETN), .rx_data_out(rx_data), .pixel(RAM_in));   

logic [17:0] addra;

Add_counter counter (.clk(CLK100MHZ), .count(count),.reset(reset),.addra(addra));

logic [17:0] addrb;
logic [23:0] doutb;

// RAM

BRAM_98_5700 BRAM (
  .clka(CLK100MHZ),    // input wire clka
  .wea(enable),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [17 : 0] addra
  .dina(RAM_in),    // input wire [23 : 0] dina
  .clkb(clk82),    // input wire clkb
  .addrb(addrb),  // input wire [17 : 0] addrb
  .doutb(doutb)  // output wire [23 : 0] doutb
);

logic [23:0] ram_out;
logic [10:0] x_pos, y_pos;

// RAM to filters.

RAM_out RAMout (.clk(clk82), .rst(reset), .addr(addrb),.pix_in(doutb),.pix_out(ram_out), .pos_x(x_pos),.pos_y(y_pos));

driver_vga_1024x768 driver(.hc_visible(x_pos),.vc_visible(y_pos),.clk_vga(clk82),.hs(VGA_HS),.vs(VGA_VS));

// Filter implementation.

logic [11:0] dit_out, to_grey;

Dithering DIT( .color(ram_out), .dithered(dit_out));

always_comb begin
    if (SW[0])  to_grey = dit_out;
    else to_grey = {ram_out[23:20],ram_out[15:12],ram_out[7:4]};
end

logic [11:0] grey_out, to_scram;

F_Greyscale GREY(.pix_in(to_grey), .pix_out(grey_out));

always_comb begin
    if (SW[1])  to_scram = grey_out;
    else to_scram = to_grey;
end

logic [11:0] scram_out, to_sobel;

color_scramble SCRAM(.color(to_scram), .RGB(scram_out), .SW(SW[15:10]));

always_comb begin
    if (SW[2])  to_sobel = scram_out;
    else to_sobel = to_scram;
end

logic[11:0] to_screen,grey_out2;
logic [3:0] sobel_out;

F_Greyscale GREY_sob(.pix_in(to_sobel), .pix_out(grey_out2));
sobel SOB(.pos_x(x_pos), .pos_y(y_pos), .clock(clk82), .reset(reset), .inputPixel(grey_out2[7:4]), .outputPixel(sobel_out));

always_comb begin
    if(SW[3]) to_screen = {sobel_out,sobel_out,sobel_out};
    else to_screen = to_sobel;
end

always_ff @(posedge clk82) begin
    if (x_pos != 0 & y_pos != 0) begin
        VGA_R <= to_screen [11:8];
        VGA_G <= to_screen [7:4];
        VGA_B <= to_screen [3:0];
    end else begin
        VGA_R <= 'h0;
        VGA_G <= 'h0;
        VGA_B <= 'h0;
    end
     end
endmodule
