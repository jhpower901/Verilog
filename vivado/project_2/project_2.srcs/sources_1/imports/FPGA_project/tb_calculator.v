`timescale 10ns / 1ns
`include "keypad_driver.v"

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

	/*segment Ãâ·Â*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
endmodule