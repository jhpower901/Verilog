module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	input clock_50m;		//보드 입력 clk
	input [15:0] pb;		//16bit key pad 입력
	output [3:0] fnd_s;		//segment select negative decoder
	output [7:0] fnd_d;		//segment anode  positive decoder

	/*Clock*/
	reg sw_clk;					//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주

	/*key input*/
	wire [3:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire rst;					//reset

	/*Buffer*/
	reg signBit;						//입력 버퍼 부호
	reg signed [30:0] buffer;			//입력 버퍼 절대값

	/*claculate var*/
	reg signed	[31:0]	ans;			//연산 결과
	reg signed	[31:0]	operand[0:1];	//피연산자
	reg			[2:0]	operator;		//연산자

	/*segment Transfer*/
	reg signed [31:0]	fnd_serial;		//segment 출력 데이터




	/*clock 분주*/
	clock_divider  CLK     (.clock_50m(clock_50m), .rst(rst),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));			
	/*segment 출력*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.nfnd_s(fnd_s), .fnd_d(fnd_d));
	/*keypad 입력*/
	keypad_driver  KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD), .rst(rst));
	/*연산기+error detector*/
	calculate      CAL     (.sw_clk(sw_clk), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.result(ans));
	

endmodule