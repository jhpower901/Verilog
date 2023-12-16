`timescale 1ns / 1ns
`include "keypad_driver.v"
`include "clock_divider.v"
`include "segment_driver.v"
`include "interface.v"

module tb_keypad_driver();
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
		#10 $finish;
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
		#10 rst <= 0;
		#10 rst <= 1;
		#20 fnd_serial <= 'h00EE_0000;	//Error
		#10 fnd_serial <= 'h0030_0000;	//PLUS
		#10 fnd_serial <= 'h0040_0000;	//MINUS
		#10 fnd_serial <= 'h0010_0000;	//MULTIPLE
		#10 fnd_serial <= 'h0020_0000;	//DIVID
		#10 fnd_serial <= 'h0050_0000;	//MODULO
		#10 fnd_serial <= 'h00B0_0000;	//ANS
		#10 fnd_serial <= 'hE0B0_0000;	//-ANS
		#10 fnd_serial <= 'hE000_000;	//-0
		#10 fnd_serial <= 0;

		#50 fnd_serial <= 1;
		#10 fnd_serial <= 12;
		#10 fnd_serial <= 123;
		#10 fnd_serial <= 1234;
		#10 fnd_serial <= 12345;
		#10 fnd_serial <= 123456;
		#10 fnd_serial <= 0;

		#50 fnd_serial <= 1;
		#10 fnd_serial <= 10;
		#10 fnd_serial <= 100;
		#10 fnd_serial <= 1000;
		#10 fnd_serial <= 10000;
		#10 fnd_serial <= 100000;

		#50 fnd_serial <= -1;
		#10 fnd_serial <= -12;
		#10 fnd_serial <= -123;
		#10 fnd_serial <= -1234;
		#10 fnd_serial <= -12345;
		#10 fnd_serial <= 0;
		#10
		$finish;
	end

	/*segment 출력*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
endmodule

module tb_calulate();
	reg sw_clk;
	reg rst;
	reg [31:0] operand1;
	reg [31:0] operand2;
	reg [2:0]  operator;
	wire [31:0] ans;

	initial begin
		sw_clk <= 0;
		rst <= 1;
		forever #1 sw_clk = ~sw_clk;
	end

	initial begin
		#10	operand1 <= 10;
			operand2 <= 101;
			operator <= 3;			//+
		#10	operand1 <= 10;
			operand2 <= 101;
			operator <= 4;			//-
		#10	operand1 <= 10;
			operand2 <= 101;
			operator <= 1;			//*
		#10	operand1 <= 10;
			operand2 <= 101;
			operator <= 2;			///
		#10	operand1 <= 10;
			operand2 <= 101;
			operator <= 5;			//%

		#50	operand1 <= -10;
			operand2 <= 101;
			operator <= 3;			//+
		#10	operand1 <= -10;
			operand2 <= 101;
			operator <= 4;			//-
		#10	operand1 <= -10;
			operand2 <= 101;
			operator <= 1;			//*
		#10	operand1 <= -10;
			operand2 <= 101;
			operator <= 2;			///
		#10	operand1 <= -10;
			operand2 <= 101;
			operator <= 5;			//%

		#50	operand1 <= -10;
			operand2 <= -101;
			operator <= 3;			//+
		#10	operand1 <= -10;
			operand2 <= -101;
			operator <= 4;			//-
		#10	operand1 <= -10;
			operand2 <= -101;
			operator <= 1;			//*
		#10	operand1 <= -10;
			operand2 <= -101;
			operator <= 2;			///
		#10	operand1 <= -10;
			operand2 <= -101;
			operator <= 5;			//%

		#50	operand1 <= 100000;
			operand2 <= -500;
			operator <= 3;			//+
		#10	operand1 <= 100000;
			operand2 <= -500;
			operator <= 4;			//-
		#10	operand1 <= 100000;
			operand2 <= -500;
			operator <= 1;			//*
		#10	operand1 <= 100000;
			operand2 <= -500;
			operator <= 2;			///
		#10	operand1 <= 100000;
			operand2 <= -500;
			operator <= 5;			//%

		#50	operand1 <= 1023;
			operand2 <= 0;
			operator <= 3;			//+
		#10	operand1 <= 1023;
			operand2 <= 0;
			operator <= 4;			//-
		#10	operand1 <= 1023;
			operand2 <= 0;
			operator <= 1;			//*
		#10	operand1 <= 1023;
			operand2 <= 0;
			operator <= 2;			///
		#10	operand1 <= 1023;
			operand2 <= 0;
			operator <= 5;			//%
		#10 $finish;
	end

	/*연산기+error detector*/
	calculate      CAL     (.sw_clk(sw_clk), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.ans(ans));
endmodule

module tb_interface();
	reg clock_50m;		//보드 입력 clk
	reg [15:0] pb;		//16bit key pad 입력
	/*segment_driver*/
	wire [5:0] fnd_s;		//segment select negative decoder
	wire [7:0] fnd_d;		//segment anode  positive decoder

	/*clock_divider*/
	wire sw_clk;				//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주

	/*keypad_driver*/
	wire [4:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire rst;					//reset

	/*calculate*/
	wire [31:0]	ans = 0;			//연산 결과

	/*interface*/
	wire [31:0]	operand1 = 0;		//피연산자
	wire [31:0]	operand2 = 0;		//피연산자
	wire [2:0]	operator = 3;		//연산자
	wire [31:0]	fnd_serial;			//segment 출력 데이터


	initial begin
		clock_50m <= 0;
		pb <= ~'h0000;
		forever #1 clock_50m = ~clock_50m;
	end

	initial begin
		//1
		#200 pb <= ~'h0001; #200
		#200 pb <= ~'h0000; #200
		//2
		#200 pb <= ~'h0002; #200
		#200 pb <= ~'h0000; #200
		//3
		#200 pb <= ~'h0004; #200
		#200 pb <= ~'h0000; #200
		//+
		#200 pb <= ~'h0800; #200
		#200 pb <= ~'h0000; #200
		//+
		#200 pb <= ~'h0800; #200
		#200 pb <= ~'h0000; #200
		//1
		#200 pb <= ~'h0001; #200
		#200 pb <= ~'h0000; #200
		//1
		#200 pb <= ~'h0001; #200
		#200 pb <= ~'h0000; #200
		//*
		#200 pb <= ~'h0080; #200
		#200 pb <= ~'h0000; #200
		//-
		#200 pb <= ~'h0800; #200
		#200 pb <= ~'h0000; #200
		//ans
		#200 pb <= ~'h4000; #200
		#200 pb <= ~'h0000; #200
		//=
		#200 pb <= ~'h8000; #200
		#200 pb <= ~'h0000; #200
		//0
		#200 pb <= ~'h2000; #200
		#200 pb <= ~'h0000; #200
		//-
		#200 pb <= ~'h0800; #200
		#200 pb <= ~'h0000; #200
		//-
		#200 pb <= ~'h0800; #200
		#200 pb <= ~'h0000; #200
		//9
		#200 pb <= ~'h0400; #200
		#200 pb <= ~'h0000; #200
		///
		#200 pb <= ~'h0008; #200
		#200 pb <= ~'h0000; #200
		//9
		#200 pb <= ~'h0400; #200
		#200 pb <= ~'h0000; #200
		//3
		#200 pb <= ~'h0004; #200
		#200 pb <= ~'h0000; #200
		//=
		#200 pb <= ~'h8000; #200
		#200 pb <= ~'h0000; #200
		//3
		#200 pb <= ~'h0004; #200
		#200 pb <= ~'h0000; #200
		//3
		#200 pb <= ~'h0004; #200
		#200 pb <= ~'h0000; #200
		//3
		#200 pb <= ~'h0004; #200
		#200 pb <= ~'h0000; #200
		//rst
		#200 pb <= ~'h8000; #200
		#200 pb <= ~'h0000; #200
		$finish;
	end




	/*clock 분주*/
	clock_divider	CLK     (.clock_50m(clock_50m), .rst(rst),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));	
	/*segment 출력*/
	segment_driver	SDI     (.fnd_clk(fnd_clk), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
	/*keypad 입력*/
	keypad_driver	KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD), .rst(rst));
	/*연산기+error detector*/
	calculate		CAL     (.sw_clk(sw_clk), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.ans(ans));
	/*interface*/
	interface		UI		(.sw_clk(sw_clk), .rst(rst), .eBCD(eBCD), .ans(ans),
							.operand1(operand1), .operand2(operand2), .operator(operator), .fnd_serial(fnd_serial));
endmodule
