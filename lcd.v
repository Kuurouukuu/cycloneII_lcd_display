
module lcd(clk, reset, lcd_rs, lcd_rw, lcd_e, data, update);

// Parameter definition
parameter IDLE = 'b000_0000_0000;
parameter CLEAR = 'b000_0000_0001;
parameter RETURNCURSOR = 'b000_0000_0010;
parameter SETMODE = 'b000_0000_0100;
parameter SWITCHMODE = 'b000_0000_1000;
parameter SHIFT = 'b000_0001_0000;
parameter SETFUNCTION = 'b000_0010_0000;
parameter SETCGRAM = 'B000_0100_0000;
parameter SETDDRAM = 'b000_1000_0000;
parameter READFLAG = 'b001_0000_0000;
parameter WRITERAM = 'b010_0000_0000;
parameter READRAM = 'b100_0000_0000;

parameter cur_inc = 1'b1;
parameter cur_dec = 1'b0;
parameter cur_shift = 1'b1;
parameter cur_noshift = 1'b0;
parameter open_display = 1'b1;
parameter open_cur = 1'b0;
parameter blank_cur = 1'b0;
parameter shift_display = 1'b1;
parameter shift_cur = 1'b0;
parameter right_shift = 1'b1;
parameter left_shift = 1'b0;
parameter datawidth8 = 1'b1;
parameter datawidth4 = 1'b0;
parameter twoline = 1'b1;
parameter oneline = 1'b0;
parameter font5x10 = 1'b1;
parameter font5x7 = 1'b0;

parameter DIVSS = 15;
parameter [15:0] divcnt = 'b1001110001000000;

// Port definition
input clk, reset;

input update;

output reg lcd_rs, lcd_rw;
output reg lcd_e = 1'b0;
output reg [7:0] data;

// Register Definition
reg [15:0] clkcnt = 16'b0;
reg tc_clkcnt = 1'b0;
reg clk_div = 1'b0;
reg clk_int = 1'b0;
reg flag = 1'b0;
reg [7:0] data_in = 'h41;
reg [10:0] state = IDLE;
reg [6:0] counter = 'b0;
reg [4:0] div_counter = 'b0;

//Module instantiation
character_ram LCDRam(.address(counter), .clk(), .data(), .wen(), .q());

// Sequential
always @(posedge clk or negedge reset)
begin
	if (reset == 'b0) 
	begin
		clkcnt <= 'd0;
	end
	else
		begin
			if (clkcnt == divcnt)
			begin
				clkcnt <= 'b0;
				tc_clkcnt <= 'b1;
			end
			else
			begin
				clkcnt <= clkcnt + 1;
				tc_clkcnt <= 'b0;
			end
		end
end

always@(posedge tc_clkcnt or negedge reset)
begin
	if (reset == 'b0)
		clk_div <= 'b0;
	else
		clk_div <= ~clk_div;
end 

always@(posedge clk_div or negedge reset)
begin
	if (reset == 'b0)
		clk_int <= 'b0;
	else
		clk_int <= ~clk_int;
end 

always@(negedge clk_div)
begin
	if (reset == 'b0)
		lcd_e <= 'b0;
	else
		lcd_e <= ~lcd_e;
end 

always@(posedge clk_int or negedge reset)
begin
	if (reset == 'b0)
	begin
		state <= IDLE;
		counter <= 'b0;
		flag <= 'b0;
		div_counter <= 'b0;
	end else
	begin
		case (state)
			IDLE :begin 
				if (flag == 'b0)
				begin
					state <= SETFUNCTION;
					flag <= 'b1;
					counter <= 'b0;
					div_counter <= 'b0;
				end else
				begin
					if (div_counter < DIVSS)
					begin
						div_counter <= div_counter + 1;
						state <= IDLE;
					end else
					begin
						div_counter <= 'b0;
						state <= SHIFT;
					end
				end
			 end
			 CLEAR :begin 
				state <= SETMODE;
			 end
			 RETURNCURSOR :begin 
				state <= WRITERAM;
			 end
			 SETMODE :begin 
				state <= WRITERAM;
			 end
			 SWITCHMODE :begin 
				state <= CLEAR;
			 end
			 SHIFT :begin 
				state <= IDLE;
			 end
			 SETFUNCTION :begin 
				state <= SWITCHMODE;
			 end
			 SETCGRAM :begin 
				state <= IDLE;	
			 end
			 SETDDRAM :begin 
				state <= WRITERAM;
			 end
			 READFLAG :begin 
				state <= IDLE;
			 end
			 WRITERAM :begin 
				if (counter == 40)
				begin
					state <= SETDDRAM;
					counter <= counter + 1;
				end else if ((counter != 40) && (counter < 81))
				begin
					state <= WRITERAM;
					counter <= counter + 1;
					data_in <= data_in + 'd1;
				end else
					state <= SHIFT;
			 end
			 READRAM :begin 
				state <= IDLE;
			 end
			 default: begin
				state <= IDLE;
			 end
		endcase
	end
end 
// Combination

always@(*)
begin
	case (state)
		 IDLE :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b1;
			data =  {8{1'bz}};
		 end
		 CLEAR :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = 'b0000_0001;
		 end
		 RETURNCURSOR :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = 'b0000_0010;
		 end
		 SETMODE :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = {6'b0000_01, cur_inc, cur_noshift};
		 end
		 SWITCHMODE :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = {5'b0000_1, open_display, open_cur, blank_cur};
		 end
		 SHIFT :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = {4'b0001, shift_display, left_shift, 2'b00};
		 end
		 SETFUNCTION :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = {3'b001, datawidth8, twoline, font5x10, 2'b00};
		 end
		 SETCGRAM :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			data = 'b0100_0000;
		 end
		 SETDDRAM :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b0;
			if (counter == 0)
				data = 'b1000_0000;
			else if (counter != 0)
				data = 'b1100_0000;
		 end
		 READFLAG :begin 
			lcd_rs = 'b0;
			lcd_rw = 'b1;
			data =  {8{1'bz}};
		 end
		 WRITERAM :begin 
			lcd_rs = 'b1;
			lcd_rw = 'b0;
			data = data_in;
		 end
		 READRAM :begin 
			lcd_rs = 'b1;
			lcd_rw = 'b1;
			data =  {8{1'bz}};
		 end
	endcase
end

// Assignment
endmodule