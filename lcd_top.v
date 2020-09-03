module lcd_top(clk, sysrst, lcd_rs, lcd_rw, lcd_e, lcd_data, update, position);

input clk;
input sysrst;
input [4:0] position;
input update;

output lcd_rs, lcd_rw, lcd_e;
output [7:0] lcd_data;

wire clk_3m;
wire [7:0] lcd_data_in;

reg update_clk;
reg state;

div16 DivideBy16(.clk(clk), .rst(sysrst), .out(clk_3m));

//character_ram LCDRam(.address(char_address), .clk(lcd_en), .data(ram_data_in), .wen(), .q(lcd_data_in));

//char_ram_2port LCDRamDualPort(.data(display_data), .wraddress(position), .wrclock(update), .wren('b1), .rdaddress(char_address), .rdclock(lcd_en), .q(lcd_data_in))

lcd MyLCD(	.clk(clk_3m), .reset(sysrst),
				.lcd_rs(lcd_rs), .lcd_rw(lcd_rw), .lcd_e(lcd_e), .data(lcd_data), .stateout());

endmodule