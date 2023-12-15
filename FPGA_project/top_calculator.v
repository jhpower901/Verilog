module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	input clock_50m;		//보드 입력 clk
	input [15:0] pb;		//16bit key pad 입력
	output [3:0] fnd_s;		//segment select negative decoder
	output [7:0] fnd_d;		//segment anode  positive decoder

	/*Clock*/
	wire sw_clk;				//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주

	/*key input*/
	wire [4:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire rst;					//reset

	/*System state*/
	reg [2:0]	state = 0;			//System state
	/*
		0: ideal
		1: waiting for operand1
		2: waiting for operand2
		3: waiting for calculation result

		System state circulate 0 -> 1 -> (2 -> 3 -> 4 ->) before enter '=' key!
	*/

	/*Buffer*/
	reg 		signBit;		//부호 입력 버퍼
	reg	[27:0]	buffer;			//피연산자 절대값 입력 버퍼
	reg [2:0]	cnt_buffer = 0	//버퍼 카운터

	/*claculate var*/
	reg signed	[31:0]	operand[0:1];	//피연산자
	reg			[2:0]	operator;		//연산자
	wire signed	[31:0]	ans;			//연산 결과

	/*segment serial*/
	reg			[31:0]	fnd_serial;		//segment 출력 데이터


	/*buffer 입력*/
	always @(posedge eBCD[4]) begin
		cnt_buffer = cnt_buf0fer + 1;			//버퍼에 입력된 문자 수
		buffer = (buffer << 4) + eBCD[3:0];		//버퍼에 문자 저장
	end


	/*buffer 처리*/
	always @(negedge sw_clk, negedge rst) begin
		if (~rst) begin
			/*reset state*/
			state		<= 0;
			/*reset buffer*/
			signBit		<= 0;
			buffer		<= 0;
			cnt_buffer	<= 0;
			/*reset calculator input*/
			operand[0]	<= 0;
			operand[1]	<= 0;
			operator	<= 0;
			/*reset segment serial*/
			fnd_serial = 'h00CC_0000;
		end else begin
			case(state)
				0 : fnd_serial = 'h0000_0000;
				1 : begin
					if (eBCD[4]) begin
						buffer = buffer * 10 + eBDC[3:0];
					end

					//입력 enable bit 확인
					if (eBCD[4]) begin
						/*
							연산자 별 code
							=:	0 000
							*:	1 001
							/:	2 010
							+:	3 011
							-:	4 100
							%:	5 101
						*/
						case(eBCD[3:0])
							'ha: /* /% */ begin
								buffer3 = (buffer3 == 3'b010) || (buffer3 == 3'b101) ? ~buffer3 : 3'b010;
							end
							'hb: /* * */ begin
								buffer3 = 3'b001;
							end
							'hc: /* +- */ begin
								buffer3 = (buffer3 == 3'b011) || (buffer3 == 3'b100) ? ~buffer3 : 3'b011;
							end
							'he: /* ans */ begin
								
							end
							'hf: /* = */
							default : 
						endcase

				end
				2 : begin
				
					end
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
							.result(ans));
endmodule