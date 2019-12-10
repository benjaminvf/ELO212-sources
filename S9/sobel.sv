`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 18:52:54
// Design Name: 
// Module Name: sobel
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
module sliding_window #(parameter WORD_SIZE=4, BUFFER_SIZE=3, ROW_SIZE=512 )
               (input  logic clock, reset,
                input logic [10:0] pos_x, pos_y,
                input logic [WORD_SIZE-1:0] inputPixel,
                output logic [BUFFER_SIZE-1:0][WORD_SIZE-1:0]sliding[BUFFER_SIZE-1:0]);
  
  logic [(BUFFER_SIZE-1)*WORD_SIZE-1:0] buffer[ROW_SIZE-1:0];
  logic [$clog2(ROW_SIZE)-1:0] ptr;
  
  always_ff @(posedge clock)
    if(reset) begin
      ptr <=0;
      sliding[0][0] <= 0;
      sliding[0][1] <= 0;
      sliding[0][2] <= 0;
      sliding[1][0] <= 0;
      sliding[1][1] <= 0;
      sliding[1][2] <= 0;
      sliding[2][0] <= 0;
      sliding[2][1] <= 0;
      sliding[2][2] <= 0;
    end
    else if ((pos_x!=0) && (pos_y!=0) && (pos_x <= 512) && (pos_y <= 385)) begin
//    else begin
      sliding[0][0] <= inputPixel;
      sliding[1][0] <= sliding[0][0];
      sliding[1][1] <= sliding[0][1];
      sliding[1][2] <= sliding[0][2];
      sliding[2][0] <= sliding[1][0];
      sliding[2][1] <= sliding[1][1];
      sliding[2][2] <= sliding[1][2];
      
      buffer[ptr] <= sliding[BUFFER_SIZE-1][BUFFER_SIZE-2:0];
      sliding[0][BUFFER_SIZE-1:1] <= buffer[ptr];
      if(ptr < ROW_SIZE-BUFFER_SIZE) ptr <= ptr + 1;
	  else ptr <= 0;
    end else begin
      sliding[0][0] <= sliding[0][0];
      sliding[1][0] <= sliding[0][1];
      sliding[1][1] <= sliding[1][1];
      sliding[1][2] <= sliding[1][2];
      sliding[2][0] <= sliding[2][0];
      sliding[2][1] <= sliding[2][1];
      sliding[2][2] <= sliding[2][2];
      buffer[ptr] <= buffer[ptr];
      sliding[0][BUFFER_SIZE-1:1] <= sliding[0][BUFFER_SIZE-1:1];
      ptr <= ptr;      
   end
endmodule: sliding_window


module sobel #(parameter WORD_SIZE=4)
             (input logic clock,reset,
              input logic [10:0] pos_x, pos_y,
              input logic [WORD_SIZE-1:0] inputPixel,
              output logic [WORD_SIZE-1:0] outputPixel);
				  
	localparam BUFFER_SIZE=3;

  logic [BUFFER_SIZE-1:0] [WORD_SIZE-1:0] sliding [BUFFER_SIZE-1:0];
  sliding_window #(WORD_SIZE,BUFFER_SIZE) my_window(.*);
    
  logic [WORD_SIZE+1:0] gx1, gx2, gy1, gy2;
	
   always_ff @(posedge clock)  
     if (reset) begin
        gx1 <= 0;
        gx2 <= 0;
        gy1 <= 0;
        gy2 <= 0;
     end
     else begin
       gx1 <= sliding[0][0] + sliding[2][0] + (sliding[1][0]<<1);
       gx2 <= sliding[0][2] + sliding[2][2] + (sliding[1][2]<<1);
       gy1 <= sliding[0][0] + sliding[0][2] + (sliding[2][1]<<1);
       gy2 <= sliding[2][0] + sliding[2][2] + (sliding[0][1]<<1);
     end

	  
  logic [WORD_SIZE+1:0] gx, gy;
   always_comb begin
     if (gx1 > gx2) gx = gx1-gx2;
      else gx = gx2 - gx1;
     if (gy1 > gy2) gy = gy1-gy2;
      else gy = gy2-gy1;
   end
			
  logic [WORD_SIZE+2:0] g;
   
   always_comb g = gy+gx; 
   always_ff @(posedge clock)  
     if (reset) 
        outputPixel <= 0;
     else
       if (pos_x==0 || pos_y==0 || pos_x > 511 || pos_y > 384) outputPixel <= 'b0;
//       if (g[WORD_SIZE+2]) outputPixel <= {WORD_SIZE{1'b1}};
//       else if (g<'d15) outputPixel <= 'b0;
	   else outputPixel <= g[WORD_SIZE+2:3];
   
endmodule
