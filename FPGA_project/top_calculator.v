module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	/*Board input*/
	input clock_50m;		//보드 입력 50MHz-clk
	input [15:0] pb;		//16bit key pad 입력
	/*segment_driver*/
	output [5:0] fnd_s;		//segment select negative decoder
	output [7:0] fnd_d;		//segment anode  positive decoder


	/*clock_divider*/
	wire sw_clk;				//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주

	/*keypad_driver*/
	wire [4:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire rst;					//reset

	/*calculate*/
	wire [31:0]	ans;			//연산 결과

	/*interface*/
	wire [31:0]	operand1;		//피연산자
	wire [31:0]	operand2;		//피연산자
	wire [2:0]	operator;		//연산자
	wire		cal_enable;		//연산기 enable
	wire [31:0]	fnd_serial;		//segment 출력 데이터


	/*clock 분주*/
	clock_divider	CLK     (.clock_50m(clock_50m),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));	
	/*segment 출력*/
	segment_driver	SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
	/*keypad 입력*/
	keypad_driver 	KDI     (.sw_clk(sw_clk), .pb(pb), .mode(mode),
							.eBCD(eBCD), .rst(rst));
	/*연산기+error detector*/
	calculate		CAL     (.enable(cal_enable), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.ans(ans));
	/*interface*/
	interface		UI		(.sw_clk(sw_clk), .rst(rst), .eBCD(eBCD), .ans(ans),
							.mode(mode), .operand1(operand1), .operand2(operand2), .operator(operator), .cal_enable(cal_enable), .fnd_serial(fnd_serial));
endmodule