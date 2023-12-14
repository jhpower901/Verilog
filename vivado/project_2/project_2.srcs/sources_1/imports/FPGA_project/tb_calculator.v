`timescale 1ns / 100ps
`include "keypad_driver.v"

module tb_calculator();
	reg			sw_clk;
	reg	[15:0]	npb;
	reg	[15:0]	pb;
	wire [4:0]	eBCD;
	wire 		rst;

	initial begin
		sw_clk <= 0;
		npb <= 'h0000;
		pb <= ~npb;
		forever #0.5 sw_clk = ~sw_clk;
	end

	always @(posedge sw_clk) begin
		npb <= npb ? npb << 1 : 'h0001 ;
		pb <= ~npb;
	end

	/*keypad ют╥б*/
	keypad_driver  KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD), .rst(rst));

endmodule
