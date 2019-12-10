module lab_8(
	input logic CLK100MHZ,
	input logic [15:0]SW,
	input logic BTNC,	BTNU, BTNL, BTNR, BTND, CPU_RESETN,
	output logic [15:0] LED,
	output logic CA, CB, CC, CD, CE, CF, CG,
	output logic DP,
	output logic [7:0] AN,

	output logic VGA_HS,
	output logic VGA_VS,
	output logic[3:0] VGA_R,
	output logic [3:0] VGA_G,
	output logic [3:0] VGA_B
	);
	
	
	logic CLK82MHZ, locked;
	logic rst = ~CPU_RESETN;
	
	clk_25_82 inst(
		// Clock out ports
		.clk_out1(CLK82MHZ),
		// YA NO TIENE 25MHZ  
		// Status and control signals               
		.reset(1'b0), 
		.locked(locked),
		// Clock in ports
		.clk_in1(CLK100MHZ)
		);
	
	//DEBOUNCER
	logic BTNUc, BTNUp, BTNUdp, BTNDc, BTNDp, BTNDdp, BTNLc, BTNLp, BTNLdp, BTNRc, BTNRp, BTNRdp, BTNCc, BTNCp, BTNCdp;
	
	PB_Debouncer_counter DEBOUNCER_U(.clk(CLK82MHZ), .rst(rst), .PB(BTNU), .PB_pressed_status(BTNUc),.PB_pressed_pulse(BTNUp), .PB_released_pulse(BTNUdp)); 
	PB_Debouncer_counter DEBOUNCER_D(.clk(CLK82MHZ), .rst(rst), .PB(BTND), .PB_pressed_status(BTNDc),.PB_pressed_pulse(BTNDp), .PB_released_pulse(BTNDdp)); 
	PB_Debouncer_counter DEBOUNCER_L(.clk(CLK82MHZ), .rst(rst), .PB(BTNL), .PB_pressed_status(BTNLc),.PB_pressed_pulse(BTNLp), .PB_released_pulse(BTNLdp)); 
	PB_Debouncer_counter DEBOUNCER_R(.clk(CLK82MHZ), .rst(rst), .PB(BTNR), .PB_pressed_status(BTNRc),.PB_pressed_pulse(BTNRp), .PB_released_pulse(BTNRdp));
	PB_Debouncer_counter DEBOUNCER_C(.clk(CLK82MHZ), .rst(rst), .PB(BTNC), .PB_pressed_status(BTNCc),.PB_pressed_pulse(BTNCp), .PB_released_pulse(BTNCdp)); 
		
	//CURSOR
	logic restriction;
	logic [2:0] pos_x;
	logic [1:0] pos_y;
	logic [4:0] val;
	grid_cursor CURSOR (.clk(CLK82MHZ), .mode(SW[0]), .rst(rst), .restriction(restriction), .dir_up(BTNUp),
	                    .dir_down(BTNDp), .dir_left(BTNLp), .dir_right(BTNRp), .pos_x(pos_x),
	                    .pos_y(pos_y), .val(val));
	
	logic [15:0] op;
	logic [15:0] op1, op2;
    logic EXE, CLR, r0, r1, r2, rst_s;
    logic [2:0]c_state;
    //FSM
    ALU_FSM FSM(.CLK100MHZ(CLK82MHZ), .CPU_RESETN(CPU_RESETN), .EXE(EXE), .BTND(BTNDp), .CLR(CLR), .r0(r0), .r1(r1), .r2(r2), .rst_s(rst_s), .c_state(c_state));
    
    //Cursor a Bank
    logic undo;
    logic [15:0] bank_in;
    
    Cursor_to_Bank CBConnect( .mode(SW[0]), .clk(CLK82MHZ), .val(val), .BTNCp(BTNCp), .state(c_state), .rst(rst), .rst_s(rst_s), .CE(undo), .EXE(EXE), .CLR(CLR), .op(bank_in));
    
    //Bank
    logic CLR_n;
    assign CLR_n = ~CLR;
    
    ALU_Bank_S8(.clk(CLK82MHZ), .rst(CLR_n), .r0(r0), .r1(r1), .r2(r2), .val(bank_in), .op1(op1), .op2(op2), .ALU_ctrl(op));
    
//    // Transformacion.
//    logic [15:0] op1_dec, op2_dec;
    
//    Dec_to_hex DECHEX1(.dec(op1), .hex(op1_dec));
//    Dec_to_hex DECHEX2(.dec(op2), .hex(op2_dec));
    
//    logic [15:0] op1_f, op2_f;
//    always_comb begin
//        if(SW[0]) begin
//            op1_f = op1_dec; 
//            op2_f = op2_dec;
//        end else  begin
//            op1_f = op1;
//            op2_f = op2;
//        end
//    end
       
    //ALU
    logic [15:0] result;
    
    ALU calculadora(.OP1(op1), .OP2(op2), .OpCode(op[3:0]), .result(result));   
    
    /************************* VGA ********************/
    logic [15:0] input_screen;    
    
    display_ctrl dispctrl(.state(c_state), .op1(op1), .op2(op2), .operation(op), .result(result), .display(input_screen));
    
	calculator_screen(
		.clk_vga(CLK82MHZ),
		.rst('b0),
		.mode(SW[0]),
		.op(op[3:0]),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.op1(op1),
		.op2(op2),
		.input_screen(input_screen),
		.BTNCp(BTNCp),
		
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B));

assign LED = input_screen;

endmodule

/**
 * @brief Este modulo convierte un numero hexadecimal de 4 bits
 * en su equivalente ascii de 8 bits
 *
 * @param hex_num		Corresponde al numero que se ingresa
 * @param ascii_conv	Corresponde a la representacion ascii
 *
 */

module hex_to_ascii(
	input [3:0] hex_num,
	output logic[7:0] ascii_conv
	);
	
always_comb begin
    case(hex_num)
           4'h0: ascii_conv = 8'b00110000;//48
           4'h1: ascii_conv = 8'b00110001;
           4'h2: ascii_conv = 8'b00110010;
           4'h3: ascii_conv = 8'b00110011;
           4'h4: ascii_conv = 8'b00110100;
           4'h5: ascii_conv = 8'b00110101;
           4'h6: ascii_conv = 8'b00110110;
           4'h7: ascii_conv = 8'b00110111;
           4'h8: ascii_conv = 8'b00111000;
           4'h9: ascii_conv = 8'b00111001;
           4'hA: ascii_conv = 8'b01000001;//65
           4'hB: ascii_conv = 8'b01000010;
           4'hC: ascii_conv = 8'b01000011;
           4'hD: ascii_conv = 8'b01000100;
           4'hE: ascii_conv = 8'b01000101;
           4'hF: ascii_conv = 8'b01000110;           
    endcase
  end
 
endmodule

/**
 * @brief Este modulo convierte un numero hexadecimal de 4 bits
 * en su equivalente ascii, pero binario, es decir,
 * si el numero ingresado es 4'hA, la salida debera sera la concatenacion
 * del string "1010" (cada caracter del string genera 8 bits).
 *
 * @param num		Corresponde al numero que se ingresa
 * @param bit_ascii	Corresponde a la representacion ascii pero del binario.
 *
 */
module hex_to_bit_ascii(
	input [3:0]num,
	output logic [4*8-1:0]bit_ascii
	);
always_comb begin
       case (num)
           4'h0: bit_ascii = 32'b00110000001100000011000000110000;
           4'h1: bit_ascii = 32'b00110000001100000011000000110001;
           4'h2: bit_ascii = 32'b00110000001100000011000100110000;
           4'h3: bit_ascii = 32'b00110000001100000011000100110001;
           4'h4: bit_ascii = 32'b00110000001100010011000000110000;
           4'h5: bit_ascii = 32'b00110000001100010011000000110001;
           4'h6: bit_ascii = 32'b00110000001100010011000100110000;
           4'h7: bit_ascii = 32'b00110000001100010011000100110001;
           4'h8: bit_ascii = 32'b00110001001100000011000000110000;
           4'h9: bit_ascii = 32'b00110001001100000011000000110001;
           4'hA: bit_ascii = 32'b00110001001100000011000100110000;
           4'hB: bit_ascii = 32'b00110001001100000011000100110001;
           4'hC: bit_ascii = 32'b00110001001100010011000000110000;
           4'hD: bit_ascii = 32'b00110001001100010011000000110001;
           4'hE: bit_ascii = 32'b00110001001100010011000100110000;
           4'hF: bit_ascii = 32'b00110001001100010011000100110001;           
       endcase
    end
endmodule

/**
 * @brief Este modulo es el encargado de dibujar en pantalla
 * la calculadora y todos sus componentes graficos
 *
 * @param clk_vga		:Corresponde al reloj con que funciona el VGA.
 * @param rst			:Corresponde al reset de todos los registros
 * @param mode			:'0' si se esta operando en decimal, '1' si esta operando hexadecimal
 * @param op			:La operacion matematica a realizar
 * @param pos_x			:Corresponde a la posicion X del cursor dentro de la grilla.
 * @param pos_y			:Corresponde a la posicion Y del cursor dentro de la grilla.
 * @param op1			:El operando 1 en formato hexadecimal.
 * @param op2			;El operando 2 en formato hexadecimal.
 * @param input_screen	:Lo que se debe mostrar en la pantalla de ingreso de la calculadora (en hexa)
 * @param VGA_HS		:Sincronismo Horizontal para el monitor VGA
 * @param VGA_VS		:Sincronismo Vertical para el monitor VGA
 * @param VGA_R			:Color Rojo para la pantalla VGA
 * @param VGA_G			:Color Verde para la pantalla VGA
 * @param VGA_B			:Color Azul para la pantalla VGA
 */
module calculator_screen(
	input logic clk_vga,
	input logic rst,
	input logic mode, //bcd or dec.
	input logic [3:0]op,
	input logic [2:0]pos_x,
	input logic [1:0]pos_y,
	input logic [15:0] op1,
	input logic [15:0] op2,
	input logic [15:0] input_screen,
	input logic BTNCp,
	
	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B
	);
	
	// DECIDIR SI HEX O DEC.
	logic [19:0] op1_f, op2_f, input_screen_f;
	
	screen_hex_dec CONVERTER (.op1(op1), .op2(op2), .input_screen(input_screen), .clk(clk_vga), .trigger(BTNCp), .switch(mode), .outputscreen(input_screen_f), .outputop1(op1_f), .outputop2(op2_f));	
	
	// PASAR VALORES A ASCII.
	logic [5*8-1:0] op1asc, op2asc, input_screenasc;
	logic [8-1:0] opasc;
	logic [4*8-1:0] bin1asc, bin2asc, bin3asc, bin4asc;
	
	hex_to_ascii op11(.hex_num(op1_f[3:0]), .ascii_conv(op1asc[8-1:0]));
	hex_to_ascii op12(.hex_num(op1_f[7:4]), .ascii_conv(op1asc[2*8-1:8]));
	hex_to_ascii op13(.hex_num(op1_f[11:8]), .ascii_conv(op1asc[3*8-1:2*8]));
	hex_to_ascii op14(.hex_num(op1_f[15:12]), .ascii_conv(op1asc[4*8-1:3*8]));
	hex_to_ascii op15(.hex_num(op1_f[19:16]), .ascii_conv(op1asc[5*8-1:4*8]));
	
	hex_to_ascii op21(.hex_num(op2_f[3:0]), .ascii_conv(op2asc[8-1:0]));
	hex_to_ascii op22(.hex_num(op2_f[7:4]), .ascii_conv(op2asc[2*8-1:8]));
	hex_to_ascii op23(.hex_num(op2_f[11:8]), .ascii_conv(op2asc[3*8-1:2*8]));
	hex_to_ascii op24(.hex_num(op2_f[15:12]), .ascii_conv(op2asc[4*8-1:3*8]));
	hex_to_ascii op25(.hex_num(op2_f[19:16]), .ascii_conv(op2asc[5*8-1:4*8]));	
	
	hex_to_ascii is1(.hex_num(input_screen_f[3:0]), .ascii_conv(input_screenasc[8-1:0]));
	hex_to_ascii is2(.hex_num(input_screen_f[7:4]), .ascii_conv(input_screenasc[2*8-1:8]));
	hex_to_ascii is3(.hex_num(input_screen_f[11:8]), .ascii_conv(input_screenasc[3*8-1:2*8]));
	hex_to_ascii is4(.hex_num(input_screen_f[15:12]), .ascii_conv(input_screenasc[4*8-1:3*8]));
	hex_to_ascii is5(.hex_num(input_screen_f[19:16]), .ascii_conv(input_screenasc[5*8-1:4*8]));
	
	always_comb begin
	   case(op)
	       'b0000: opasc = "+";
	       'b0100: opasc = "-";
	       'b0010: opasc = "&";
	       'b0101: opasc = "|";
	       'b0001: opasc = "*";
	       default: opasc = "_";      
	   endcase	
	end
	
	hex_to_bit_ascii bit1(.num(input_screen[3:0]), .bit_ascii(bin1asc));
	hex_to_bit_ascii bit2(.num(input_screen[7:4]), .bit_ascii(bin2asc));
	hex_to_bit_ascii bit3(.num(input_screen[11:8]), .bit_ascii(bin3asc));
	hex_to_bit_ascii bit4(.num(input_screen[15:12]), .bit_ascii(bin4asc));
	
	// PADDING
//	logic [5*8-1:0] op1asc_pad, op2asc_pad, input_screenasc_pad;
	
//	space_padding op1pad(.clk(clk_vga), .trigger(BTNCp), .rst(rst), .no_padding(op1asc), .padding(op1asc_pad));
//	space_padding op2pad(.clk(clk_vga), .trigger(BTNCp), .rst(rst), .no_padding(op2asc), .padding(op2asc_pad));
//	space_padding input_screenpad(.clk(clk_vga), .trigger(BTNCp), .rst(rst), .no_padding(input_screenasc), .padding(input_screenasc_pad));
	
	localparam CUADRILLA_XI = 		212;
	localparam CUADRILLA_XF = 		CUADRILLA_XI + 600;
	
	localparam CUADRILLA_YI = 		250;
	localparam CUADRILLA_YF = 		CUADRILLA_YI + 400;
	
	
	logic [10:0]vc_visible,hc_visible;
	
	// MODIFICAR ESTO PARA HACER LLAMADO POR NOMBRE DE PUERTO, NO POR ORDEN!!!!!
	//LISTO
	driver_vga_1024x768 m_driver(.clk_vga(clk_vga), .hs(VGA_HS), .vs(VGA_VS), .hc_visible(hc_visible), .vc_visible(vc_visible));
	/*************************** VGA DISPLAY ************************/
		
	logic [10:0]hc_template, vc_template;
	logic [2:0]matrix_x;
	logic [1:0]matrix_y;
	logic lines;
	
	template_6x4_600x400 #( .GRID_XI(CUADRILLA_XI), 
							.GRID_XF(CUADRILLA_XF), 
							.GRID_YI(CUADRILLA_YI), 
							.GRID_YF(CUADRILLA_YF)) 
    // MODIFICAR ESTO PARA HACER LLAMADO POR NOMBRE DE PUERTO, NO POR ORDEN!!!!!
    //LISTO
	template_1(.clk(clk_vga), .hc(hc_visible), .vc(vc_visible), .matrix_x(matrix_x), .matrix_y(matrix_y), .lines(lines));
	
	logic [11:0]VGA_COLOR;
	
	logic text_sqrt_fg;
	logic text_sqrt_bg;

	logic [37:0]generic_fg; //para caracteres
	logic [31:0]generic_bg; //fondo de la grilla
		
	logic [31:0]display_bg; //fondo de displays
	logic [31:0]case_bg;    //fondo de "carcasa"
	logic [31:0]hex_num_bg;     //fondo para numeros en hex
	
	logic hex_bg;
	logic dec_bg;

	localparam GRID_X_OFFSET	= 20;
	localparam GRID_Y_OFFSET	= 10;
	
	localparam FIRST_SQRT_X = 212;
	localparam FIRST_SQRT_Y = 250;
	
	// NOMBRES
	hello_world_text_square m_hw(	.clk(clk_vga), 
									.rst(1'b0), 
									.hc_visible(hc_visible), 
									.vc_visible(vc_visible), 
									.in_square(text_sqrt_bg), 
									.in_character(text_sqrt_fg));
									
									
    // PALABRAS EN CARCASA
    
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 50), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 210 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(3), 
					.n(3)) 
	word_op1(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("OP1"), 
			.in_square(case_bg[0]), 
			.in_character(generic_fg[32]));
			
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 50), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 180 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(3), 
					.n(3)) 
	word_op2(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("OP2"), 
			.in_square(case_bg[1]), 
			.in_character(generic_fg[33]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 50), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 145 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(2), 
					.ancho_pixel(3), 
					.n(3)) 
	word_op(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("OP"), 
			.in_square(case_bg[2]), 
			.in_character(generic_fg[34]));
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 470), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 120 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(3), 
					.n(3)) 
	word_hex(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("HEX"), 
			.in_square(hex_bg), 
			.in_character(generic_fg[35]));		
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 470), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 95 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(3), 
					.n(3)) 
	word_dec(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("DEC"), 
			.in_square(dec_bg), 
			.in_character(generic_fg[36]));
				
				
    // INDICADOR HEX O DEC	
    
    	
	logic [7:0] modestring;
    always_comb begin
        if (mode) modestring = "1";
        else modestring = "0"; 
    end

    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 470), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 210 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(1), 
					.ancho_pixel(3), 
					.n(3)) 
	mode_num(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(modestring), 
			.in_square(display_bg[8]), 
			.in_character(generic_fg[37]));
			
			
    // PANTALLAS CALCULADORA
    
    
     show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 110), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 210 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(5), 
					.ancho_pixel(3), 
					.n(2)) 
	line_op1(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(op1asc), 
			.in_square(display_bg[5]), 
			.in_character(generic_fg[29]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 110), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 180 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(5), 
					.ancho_pixel(3), 
					.n(2)) 
	line_op2(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(op2asc), 
			.in_square(display_bg[6]), 
			.in_character(generic_fg[30]));
			
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET + 110), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 145 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(1), 
					.ancho_pixel(3), 
					.n(2)) 
	line_operacion(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(opasc), 
			.in_square(display_bg[7]), 
			.in_character(generic_fg[31]));
			
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 280 + GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 120 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(5), 
					.ancho_pixel(5), 
					.n(3)) 
	result(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(input_screenasc), 
			.in_square(display_bg[0]), 
			.in_character(generic_fg[24]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 50), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(4), 
					.n(3)) 
	bin1(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(bin4asc), 
			.in_square(display_bg[1]), 
			.in_character(generic_fg[25]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 150), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 50), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(4), 
					.n(3)) 
	bin2(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(bin3asc), 
			.in_square(display_bg[2]), 
			.in_character(generic_fg[26]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 300), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 50), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(4), 
					.n(3)) 
	bin3(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(bin2asc), 
			.in_square(display_bg[3]), 
			.in_character(generic_fg[27]));
    
    show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 450), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y - 50), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(4), 
					.n(3)) 
	bin4(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(bin1asc), 
			.in_square(display_bg[4]), 
			.in_character(generic_fg[28]));
    		  
    		  
	// GRID DE LA CALCULADORA
	
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + GRID_Y_OFFSET)) 
	ch_00(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("0"), 
		  .in_square(generic_bg[0]), 
		  .in_character(generic_fg[0]));
    
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 1*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + GRID_Y_OFFSET)) 
	ch_01(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("1"), 
		  .in_square(generic_bg[1]), 
		  .in_character(generic_fg[1]));
		  
    show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 2*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + GRID_Y_OFFSET)) 
	ch_02(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("2"), 
		  .in_square(generic_bg[2]), 
		  .in_character(generic_fg[2]));

	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 3*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + GRID_Y_OFFSET)) 
	ch_03(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("3"), 
		  .in_square(generic_bg[3]), 
		  .in_character(generic_fg[3]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 0*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 100 + GRID_Y_OFFSET)) 
	ch_04(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("4"), 
		  .in_square(generic_bg[4]), 
		  .in_character(generic_fg[4]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 1*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 100 + GRID_Y_OFFSET)) 
	ch_05(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("5"), 
		  .in_square(generic_bg[5]), 
		  .in_character(generic_fg[5]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 2*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 100 + GRID_Y_OFFSET)) 
	ch_06(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("6"), 
		  .in_square(generic_bg[6]), 
		  .in_character(generic_fg[6]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 3*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 100 + GRID_Y_OFFSET)) 
	ch_07(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("7"), 
		  .in_square(generic_bg[7]), 
		  .in_character(generic_fg[7]));
		  
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 0*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 2*100 + GRID_Y_OFFSET)) 
	ch_08(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("8"), 
		  .in_square(generic_bg[8]), 
		  .in_character(generic_fg[8]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 1*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 2*100 + GRID_Y_OFFSET)) 
	ch_09(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("9"), 
		  .in_square(generic_bg[9]), 
		  .in_character(generic_fg[9]));

	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 2*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 2*100 + GRID_Y_OFFSET)) 
	ch_10(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("A"), 
		  .in_square(hex_num_bg[0]), 
		  .in_character(generic_fg[10]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 3*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 2*100 + GRID_Y_OFFSET)) 
	ch_11(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("B"), 
		  .in_square(hex_num_bg[1]), 
		  .in_character(generic_fg[11]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 0*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 3*100 + GRID_Y_OFFSET)) 
	ch_12(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("C"), 
		  .in_square(hex_num_bg[2]), 
		  .in_character(generic_fg[12]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 1*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 3*100 + GRID_Y_OFFSET)) 
	ch_13(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("D"), 
		  .in_square(hex_num_bg[3]), 
		  .in_character(generic_fg[13]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 2*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 3*100 + GRID_Y_OFFSET)) 
	ch_14(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("E"), 
		  .in_square(hex_num_bg[4]), 
		  .in_character(generic_fg[14]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 3*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 3*100 + GRID_Y_OFFSET)) 
	ch_15(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("F"), 
		  .in_square(hex_num_bg[5]), 
		  .in_character(generic_fg[15]));
    
    show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 4*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 0*100 + GRID_Y_OFFSET)) 
	ch_plus(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("+"), 
		  .in_square(generic_bg[16]), 
		  .in_character(generic_fg[16]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 5*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 0*100 + GRID_Y_OFFSET)) 
	ch_minus(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("-"), 
		  .in_square(generic_bg[17]), 
		  .in_character(generic_fg[17]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 4*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 1*100 + GRID_Y_OFFSET)) 
	ch_mult(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("*"), 
		  .in_square(generic_bg[18]), 
		  .in_character(generic_fg[18]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 5*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 1*100 + GRID_Y_OFFSET)) 
	ch_or(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("|"), 
		  .in_square(generic_bg[19]), 
		  .in_character(generic_fg[19]));
	
	show_one_char #(.CHAR_X_LOC(FIRST_SQRT_X + 4*100 + GRID_X_OFFSET), 
					.CHAR_Y_LOC(FIRST_SQRT_Y + 2*100 + GRID_Y_OFFSET)) 
	ch_and(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("&"), 
		  .in_square(generic_bg[20]), 
		  .in_character(generic_fg[20]));
	
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 100*5 + GRID_X_OFFSET - 10), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 100*2 + GRID_Y_OFFSET + 15), 
					.MAX_CHARACTER_LINE(2), 
					.ancho_pixel(5), 
					.n(3)) 
	ce(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("CE"), 
			.in_square(generic_bg[21]), 
			.in_character(generic_fg[21]));
		  
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 100*4 + GRID_X_OFFSET - 16), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 100*3 + GRID_Y_OFFSET + 15), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(5), 
					.n(3)) 
	exe(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("EXE"), 
			.in_square(generic_bg[22]), 
			.in_character(generic_fg[22]));
	
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 100*5 + GRID_X_OFFSET - 17), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 100*3 + GRID_Y_OFFSET + 15), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(5), 
					.n(3)) 
	clr(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("CLR"), 
			.in_square(generic_bg[23]), 
			.in_character(generic_fg[23]));

	
	logic draw_cursor = (pos_x == matrix_x) && (pos_y == matrix_y);
	
	
	localparam COLOR_BLUE 		= 12'h00F;
	localparam COLOR_YELLOW 	= 12'hFF0;
	localparam COLOR_RED		= 12'hF00;
	localparam COLOR_BLACK		= 12'h000;
	localparam COLOR_WHITE		= 12'hFFF;
	localparam COLOR_CYAN		= 12'h0FF;
	//localparam COLOR_PINK       = 12'hF4D;
	localparam COLOR_PINK       = 12'hF6F;
	//localparam COLOR_PURPLE     = 12'h80E;
	localparam COLOR_PURPLE     = 12'h90F;
	localparam COLOR_GREY       = 12'hAAA;
	
	always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
			
			if(text_sqrt_fg)
				VGA_COLOR = COLOR_BLACK;
			else if (text_sqrt_bg)
				VGA_COLOR = COLOR_WHITE;
		    else if(|generic_fg)
				VGA_COLOR = COLOR_BLACK;
		    else if(case_bg)
				VGA_COLOR = COLOR_PURPLE;
			else if(display_bg)
				VGA_COLOR = COLOR_WHITE;
		    else if(hex_num_bg) begin
		          if (mode) VGA_COLOR = COLOR_GREY;
		          else if(draw_cursor) VGA_COLOR = COLOR_WHITE;
		          else VGA_COLOR = COLOR_PINK;
		    end
		    else if(hex_bg) begin
		          if (mode) VGA_COLOR = COLOR_PURPLE;
		          else VGA_COLOR = COLOR_PINK;
		    end
		    else if(dec_bg) begin
		          if (mode) VGA_COLOR = COLOR_PINK;
		          else VGA_COLOR = COLOR_PURPLE;
		    end			      
			else if(generic_bg) begin
			         if(draw_cursor) VGA_COLOR = COLOR_WHITE;
				     else VGA_COLOR = COLOR_PINK;
		    end
			//si esta dentro de la grilla.
			else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
				if(lines)//lineas negras de la grilla
					VGA_COLOR = COLOR_BLACK;
				else if (draw_cursor) //el cursor
					VGA_COLOR = COLOR_WHITE;
				else
					//VGA_COLOR = {3'h7, {2'b0, matrix_x} + {3'b00, matrix_y}, 4'h3};// el fondo de la grilla.
					VGA_COLOR = COLOR_PINK;
			else if ((hc_visible > CUADRILLA_XI- 10) && (hc_visible <= CUADRILLA_XF + 10))
				VGA_COLOR = COLOR_PURPLE;//el fondo de la pantalla
		    else VGA_COLOR = COLOR_WHITE;
		end
		else
			VGA_COLOR = COLOR_BLACK;//esto es necesario para no poner en riesgo la pantalla.

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;
endmodule

/**
 * @brief Este modulo cambia los ceros a la izquierda de un numero, por espacios
 * @param value			:Corresponde al valor (en hexa o decimal) al que se le desea hacer el padding.
 * @param no_pading		:Corresponde al equivalente ascii del value includos los ceros a la izquierda
 * @param padding		:Corresponde al equivalente ascii del value, pero sin los ceros a la izquierda.
 */

module space_padding(
input clk,
input trigger,
input rst,
input [8*6 -1:0]no_padding,
output logic [8*6 -1:0]padding
    );

 //Declarations:------------------------------

 //FSM states type:
typedef enum logic [5:0] {sixthbyte,fifthbyte,fourthbyte,thirdbyte,secondbyte,firstbyte} state;
state pr_state, nx_state;

 //Statements:--------------------------------

 //FSM state register:
 always_ff @(posedge clk, posedge rst)
    if (rst | trigger) pr_state <= sixthbyte;
    else pr_state <= nx_state;

 //FSM combinational logic:
 always_comb begin
    padding = padding;   
    case (pr_state)
        sixthbyte: begin
        
            if (no_padding[47:40]== 8'b00110000) begin
            padding[47:40] = 8'b00100000;
            nx_state = fifthbyte;
            end
            else begin
            padding = no_padding;
            nx_state = sixthbyte;
        end
        end
        
        fifthbyte: begin
        
            if (no_padding[39:32]== 8'b00110000) begin
            padding[39:32] = 8'b00100000;
            nx_state = fourthbyte;
            end
            
            else begin
            padding[39:0] = no_padding[39:0];
            nx_state = fifthbyte;
            end
        end
    
 
        fourthbyte: begin
            if (no_padding[31:24]== 8'b00110000) begin
            padding[31:24] = 8'b00100000;
            nx_state = thirdbyte;
            end
            
            else begin
            padding[31:0] = no_padding[31:0];
            nx_state = fourthbyte;
            end
            end
            
        thirdbyte: begin
            if (no_padding[23:16]== 8'b00110000) begin
            padding[23:16] = 8'b00100000;
            nx_state = secondbyte;
            end
            
            else begin
            padding[23:0] = no_padding[23:0];
            nx_state = thirdbyte;
            end
            end
            
        secondbyte: begin
            if (no_padding[15:8]== 8'b00110000) begin
            padding[15:8] = 8'b00100000;
            nx_state = firstbyte;
            end
            
            else begin
            padding[15:0] = no_padding[15:0];
            nx_state = secondbyte;
            end
            end
            
        firstbyte: begin
            padding[7:0] = no_padding[7:0];
            nx_state = secondbyte;
            end
       default: begin
            padding = padding;
            nx_state = sixthbyte;
            end
    endcase
    end
 
endmodule

