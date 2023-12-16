`timescale 10ns / 1ns
`include "keypad_driver.v"
`include "clock_divider.v"
`include "segment_driver.v"

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

module tb_top_calculator();
	reg clock_50m;		//보드 입력 clk
	reg [15:0] pb;		//16bit key pad 입력
	wire [3:0] fnd_s;		//segment select negative decoder
	wire [7:0] fnd_d;		//segment anode  positive decoder

	/*Clock*/
	wire sw_clk;				//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주

	/*key input*/
	wire [4:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire rst;					//reset


	/*연산자 별 operator code*/
	localparam EQU		= 3'b000;
	localparam TIMES	= 3'b001;
	localparam DIV		= 3'b010;
	localparam PLUS		= 3'b011;
	localparam MINUS	= 3'b100;
	localparam MOD		= 3'b101;

	/*System state*/
	/*
		0: ideal
		1: waiting for operand1
		2: waiting for operand2
		3: waiting for calculation result

		System state circulate 0 -> 1 -> (2 -> 3 -> 4 ->) before enter '=' key!
	*/
	localparam ideal		= 0;
	localparam operand1_in	= 1;
	localparam operator_in	= 2;
	localparam operand2_in	= 3;
	localparam calculating	= 4;
	localparam result		= 5;
	localparam ERROR		= 6;
	reg [2:0]	state = ideal;			//System state


	/*Buffer*/
	reg 		signBit;		//부호 입력 버퍼
	reg	[27:0]	buffer;			//피연산자 절대값 입력 버퍼
	reg [2:0]	cnt_buffer = 0;	//버퍼 카운터

	/*claculate var*/
	reg  [31:0]	operand1 = 0;		//피연산자
	reg  [31:0]	operand2 = 0;		//피연산자
	reg	 [2:0]	operator = 3;		//연산자
	wire [31:0]	ans = 0;			//연산 결과

	/*segment serial*/
	reg			[31:0]	fnd_serial;		//segment 출력 데이터


	/*buffer 입력*/
	always @(posedge eBCD[4]) begin
		cnt_buffer = cnt_buffer + 1;			//버퍼에 입력된 문자 수
		buffer = (buffer << 4) + eBCD[3:0];		//버퍼에 문자 저장
	end


	/*buffer 처리*/
	always @(negedge sw_clk, negedge rst) begin
		if (~rst) begin
			/*reset state*/
			state		<= ideal;		//상태 초기화
			/*reset buffer*/
			signBit		<= 0;			//부호 비트 초기화
			buffer		<= 0;			//입력 버퍼 초기화
			cnt_buffer	<= 0;			//버퍼 카운터 초기화
			/*reset calculator input*/
			operand1	<= 0;			//피연산자 초기화
			operand2	<= 0;			//피연산자 초기화
			operator	<= 0;			//연산자 초기화
			/*reset segment serial*/
			fnd_serial = 'h00CC_0000;	//segment 꺼짐
		end else begin
			case(state)
				//대기 상태
				ideal : begin
					fnd_serial <= 'h0000_0000;	//segment 0 출력
					if (cnt_buffer)				//버퍼에 입력 값 있는 경우
						state <= operand1_in;		//state 피연산자 입력 모드로
				end

				operand1_in : begin
					if (cnt_buffer) begin
						if (buffer[3:0] == 'hc) begin	//부호 입력
							signBit = ~signBit;			//부호 비트 설정
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							fnd_serial <= 'hE000_0000;	//segment -0 출력
						end
						else if (buffer[3:0] == 'he) begin	//ans 입력
							if (signBit) begin
								operand1 <= ~ans + 1;
								fnd_serial <= 'hE0B0_0000;	//-ANS 출력
							end else begin
								operand1 <= ans;
								fnd_serial <= 'h00B0_0000;	//ANS 출력
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;							
						end
						else if (buffer[3:0] > 'h9) begin	//연산자 입력이라면
							operand1 <= ans;				//첫번째 피연산자 ans 대입
							state <= operator_in;			//연산자 입력 모드
						end else begin
							if ((operand1 < 10_000 && signBit) || operand1 < 100_000) begin	//입력 공간이 있을 때
								operand1 <= operand1 * 10 + buffer[3:0];
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							if (signBit)
								fnd_serial <= ~operand1 + 1;
							else
								fnd_serial <= operand1;
						end
					end
				end

				operator_in : begin
					if (cnt_buffer) begin
						case(buffer[3:0])
							'ha: /* /% */ begin
								operator <= (operator == DIV) || (operator == MOD) ? ~operator : DIV;
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							'hb: /* * */ begin
								operator <= TIMES;
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							'hc: /* +- */ begin
								operator <= (operator == PLUS) || (operator == MINUS) ? ~operator : PLUS;
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							'he: /* ans */ begin
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							'hf: /* = */ begin
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							'h0: /* 0 */ begin
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							default: state <= operand2_in;	//두번째 피연산자 입력 모드
						endcase
					end
					fnd_serial <= {operator, 20'h0_0000};
				end

				operand2_in : begin
					if (cnt_buffer) begin
						if (buffer[3:0] == 'hc) begin	//부호 입력
							signBit = ~signBit;			//부호 비트 설정
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							fnd_serial <= 'hE000_0000;	//segment -0 출력
						end
						else if (buffer[3:0] == 'he) begin	//ans 입력
							if (signBit) begin
								operand2 <= ~ans + 1;
								fnd_serial <= 'hE0B0_0000;	//-ANS 출력
							end else begin
								operand2 <= ans;
								fnd_serial <= 'h00B0_0000;	//ANS 출력
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;							
						end
						else if (buffer[3:0] > 'h9) begin	//연산자 입력이라면
							state <= calculating;			//계산 모드
						end else begin
							if ((operand2 < 10_000 && signBit) || operand2 < 100_000) begin	//입력 공간이 있을 때
								operand2 <= operand2 * 10 + buffer[3:0];
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							if (signBit)
								fnd_serial <= ~operand2 + 1;
							else
								fnd_serial <= operand2;
						end
					end
				end

				calculating : begin
					if (cnt_buffer) begin
						if(buffer[3:0] == 'hf) begin	// 등호 입력
							/*reset buffer*/
							signBit		<= 0;			//부호 비트 초기화
							buffer		<= 0;			//입력 버퍼 초기화
							cnt_buffer	<= 0;			//버퍼 카운터 초기화
							/*reset calculator input*/
							operand1	<= 0;			//피연산자 초기화
							operand2	<= 0;			//피연산자 초기화
							operator	<= 0;			//연산자 초기화
							if (ans == 'h00EE_0000)
								state <= ERROR;
							else
								fnd_serial <= ans;
							
						end
						else if (buffer[3:0] > 'h9) begin
							state <= operator_in;		//연산자 입력 모드
							operand1 <= ans;			//피연산자1에 ans 대입
						end else begin
							state <= ideal;
						end
					end
				end

				ERROR : begin
					//error
				end
			endcase
		end
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



	initial begin
		clock_50m <= 0;
		pb <= ~'h0000;
		forever #1 clock_50m = ~clock_50m;
	end

	initial begin
		//1
		#100 pb <= ~'h0001; #100
		#100 pb <= ~'h0000; #100
		//2
		#100 pb <= ~'h0002; #100
		#100 pb <= ~'h0000; #100
		//3
		#100 pb <= ~'h0004; #100
		#100 pb <= ~'h0000; #100
		//+
		#100 pb <= ~'h0800; #100
		#100 pb <= ~'h0000; #100
		//+
		#100 pb <= ~'h0800; #100
		#100 pb <= ~'h0000; #100
		//1
		#100 pb <= ~'h0001; #100
		#100 pb <= ~'h0000; #100
		//1
		#100 pb <= ~'h0001; #100
		#100 pb <= ~'h0000; #100
		//*
		#100 pb <= ~'h0080; #100
		#100 pb <= ~'h0000; #100
		//-
		#100 pb <= ~'h0800; #100
		#100 pb <= ~'h0000; #100
		//ans
		#100 pb <= ~'h4000; #100
		#100 pb <= ~'h0000; #100
		//=
		#100 pb <= ~'h8000; #100
		#100 pb <= ~'h0000; #100
		//0
		#100 pb <= ~'h2000; #100
		#100 pb <= ~'h0000; #100
		//-
		#100 pb <= ~'h0800; #100
		#100 pb <= ~'h0000; #100
		//-
		#100 pb <= ~'h0800; #100
		#100 pb <= ~'h0000; #100
		//9
		#100 pb <= ~'h0400; #100
		#100 pb <= ~'h0000; #100
		///
		#100 pb <= ~'h0008; #100
		#100 pb <= ~'h0000; #100
		//9
		#100 pb <= ~'h0400; #100
		#100 pb <= ~'h0000; #100
		//3
		#100 pb <= ~'h0004; #100
		#100 pb <= ~'h0000; #100
		//=
		#100 pb <= ~'h8000; #100
		#100 pb <= ~'h0000; #100
		//3
		#100 pb <= ~'h0004; #100
		#100 pb <= ~'h0000; #100
		//3
		#100 pb <= ~'h0004; #100
		#100 pb <= ~'h0000; #100
		//3
		#100 pb <= ~'h0004; #100
		#100 pb <= ~'h0000; #100
		//rst
		#100 pb <= ~'h8000; #100
		#100 pb <= ~'h0000; #100
		$finish;
	end
endmodule