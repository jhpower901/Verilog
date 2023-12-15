`timescale 10ns / 1ns
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

	initial begin
		repeat(20) begin
			#5
			npb <= npb ? npb << 1 : 'h0001 ;
			pb <= ~npb;
			#3
			pb <= 'hFFFF;
		end
	end

	/*keypad 입력*/
	keypad_driver  KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD), .rst(rst));
endmodule

module tb_clock_divider();
	reg clock_50m;
	reg rst;
	wire sw_clk;
	wire fnd_clk;

	initial begin
		rst <= 1;
		clock_50m <= 0;
		forever #1 clock_50m = ~clock_50m;
	end

	initial begin
		#10
		rst = 0;
		#100000
		rst = 1;
		#1000000000
		$finish;
	end


	/*clock 분주*/
	clock_divider  CLK     (.clock_50m(clock_50m), .rst(rst),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));		
endmodule

module tb_segment_driver();
	reg fnd_clk;
	reg rst;
	reg signed [31:0] fnd_serial;
	wire [5:0] fnd_s;
	wire [7:0] fnd_d;

	initial begin
		fnd_clk <= 0;
		fnd_serial <= 'h00CC_0000;
		rst <= 1;
		forever #1 fnd_clk = ~fnd_clk;
	end

	initial begin
		#10 fnd_serial = 1;
		#10 fnd_serial = 2;
		#10 fnd_serial = 3;
		#10 fnd_serial = 4;
		#10 fnd_serial = 5;
		#10 fnd_serial = 6;
		#10 fnd_serial = 7;
		#10 fnd_serial = 8;
		#10 fnd_serial = 9;
		#10 fnd_serial = 0;

		#100 fnd_serial = 'h00EE_0000;	//Error
		#10 fnd_serial = 'h0010_0000;	//PLUS
		#10 fnd_serial = 'h0020_0000;	//MINUS
		#10 fnd_serial = 'h0030_0000;	//MULTIPLE
		#10 fnd_serial = 'h0040_0000;	//DIVID
		#10 fnd_serial = 'h0050_0000;	//MODULO
		#10 fnd_serial = 'h00A0_0000;	//HAPPY
		#10 fnd_serial = 0;

		#100 fnd_serial = 1;
		#10 fnd_serial = 12;
		#10 fnd_serial = 123;
		#10 fnd_serial = 1234;
		#10 fnd_serial = 12345;
		#10 fnd_serial = 123456;
		#10 fnd_serial = 0;

		#100 fnd_serial = -1;
		#10 fnd_serial = -12;
		#10 fnd_serial = -123;
		#10 fnd_serial = -1234;
		#10 fnd_serial = -12345;
		#10 fnd_serial = 0;
		#10
		$finish;
	end

	/*segment 출력*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
endmodule