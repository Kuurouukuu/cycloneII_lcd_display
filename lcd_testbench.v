`timescale 10ns/1ns
module lcd_testbench();

reg clk = 'b0;
reg sysrst = 'b1;

wire [7:0] lcd_data;
wire lcd_rs, lcd_rw, lcd_e;

lcd_top UUT(.clk(clk), .sysrst(sysrst), .lcd_rs(lcd_rs), .lcd_rw(lcd_rw), .lcd_e(lcd_e), .lcd_data(lcd_data));

initial begin
  forever #1 clk = ~clk;
end

endmodule