module interface(sw_clk, rst, eBCD, ans, operand1, operand2, operator, cal_enable, fnd_serial);
	input sw_clk;						//switch clk
	/*key input*/
	input rst;							//비동기 reset
	input [4:0]	eBCD;					//키보드 입력
	/*claculate var*/
	input [31:0] ans;			//연산 결과
	output reg  [31:0]	operand1 = 0;	//피연산자
	output reg  [31:0]	operand2 = 0;	//피연산자
	output reg	 [2:0]	operator = 3;	//연산자
	output reg			cal_enable = 0;	//연산기 enable
	/*segment serial*/
	output reg	[31:0]	fnd_serial;		//segment 출력 데이터


	/*연산자 별 operator code*/
	localparam EQU		= 3'b000;
	localparam TIMES	= 3'b001;
	localparam DIV		= 3'b010;
	localparam PLUS		= 3'b011;
	localparam MINUS	= 3'b100;
	localparam MOD		= 3'b101;
	/*
	* eBCD code mapping
	* 맨 앞 1bit는 입력 enable임
	* 0 1 2 3 4 5 6 7 8 9 a  b c  d  e   f
	* 0 1 2 3 4 5 6 7 8 9 /% * +- AC ans =
	*/	


	/*System state*/
	/*
		0: ideal
		1: waiting for operand1
		2: waiting for operand2
		3: waiting for calculation result

		System state circulate 0 -> 1 -> (2 -> 3 -> 4 ->) before enter '=' key!
	*/
	localparam ideal		= 0;	//대기 모드
	localparam operand1_in	= 1;	//첫번째 피연산자 입력 모드
	localparam operator_in	= 2;
	localparam operand2_in	= 3;
	localparam calculating	= 4;
	localparam result		= 5;
	localparam ERROR		= 6;
	reg [2:0]	state = ideal;			//System state


	/*Buffer*/
	reg 		signBit		= 0;	//부호 입력 버퍼
	reg	[27:0]	buffer		= 0;	//피연산자 절대값 입력 버퍼
	reg [2:0]	cnt_buffer	= 0;	//버퍼 카운터
	reg	[31:0]	mem;				//ans 메모리
	reg [2:0]   cnt_input	= 0;	//입력 카운터


	/*buffer 입력*/
	always @(posedge eBCD[4]) begin
		buffer <= buffer + ({24'h00_0000, eBCD[3:0]} << (4 * cnt_buffer));		//버퍼에 문자 저장
		cnt_buffer <= cnt_buffer + 1;						//버퍼에 입력된 문자 수
	end

	/*buffer 처리*/
	always @(posedge sw_clk, negedge rst) begin
		if (~rst) begin
			/*reset state*/
			state		<= ideal;		//상태 초기화
			/*reset buffer*/
			signBit		<= 0;			//부호 비트 초기화
			buffer		<= 0;			//입력 버퍼 초기화
			cnt_buffer	<= 0;			//버퍼 카운터 초기화
			mem			<= 0;			//memory 초기화
			/*reset calculator input*/
			operand1	<= 0;			//피연산자 초기화
			operand2	<= 0;			//피연산자 초기화
			operator	<= 0;			//연산자 초기화
			cnt_input	<= 0;			//입력 카운터 초기화
			/*reset segment serial*/
			fnd_serial = 'h00CC_0000;	//segment 꺼짐
		end else begin
			case(state)
				//대기 상태
				ideal : begin
					mem <= ans;
					if (cnt_buffer) begin				//버퍼에 입력 값 있는 경우
						state <= operand1_in;		//state 피연산자 입력 모드로
					end
					else begin
						/*reset calculator input*/
						operand1	<= 0;			//피연산자 초기화
						operand2	<= 0;			//피연산자 초기화
						operator	<= 0;			//연산자 초기화
						cnt_input	<= 0;			//입력 카운터 초기화
						cal_enable	<= 0;
						signBit		<= 0;			//부호 비트 초기화
						fnd_serial = 'h0000_0000;	//segment 0 출력
					end
				end

				operand1_in : begin				//첫번째 피연산자 입력 모드
					cal_enable	<= 0;
					if (cnt_buffer) begin
						/*연산자 입력*/
						if(buffer[3:0] > 'h9) begin
							/*아무 숫자도 입력되지 않았을 때 연산자 누르는 경우*/
							if (!cnt_input) begin
								/*맨 처음 부호 입력*/
								if (buffer[3:0] == 'hc) begin	//부호 입력
									signBit = ~signBit;			//부호 비트 설정
									cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
									buffer <= buffer >> 4;
									
									if (signBit) begin
										fnd_serial = 'hE000_0000;	//segment -0 출력
									end else begin
										fnd_serial = 'h0000_0000;	//segment 0 출력
									end
								end
								/*맨 처음 ans 입력*/
								else if (buffer[3:0] == 'he) begin	//ans 입력
									/*부호 비트+문자 결합 출력*/
									if (signBit) begin
										operand1 <= ~mem + 1;
										fnd_serial = 'hE0B0_0000;	//-ANS 출력
									end else begin
										operand1 <= mem;
										fnd_serial = 'h00B0_0000;	//ANS 출력
									end
									cnt_input <= cnt_input +1;		//입력 카운터 증가
									cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
									buffer <= buffer >> 4;							
								end
							end
							else begin
								if (signBit)
									operand1 = ~operand1 + 1;
								state <= operator_in;			//연산자 입력 모드
							end
						end
						/*숫자 입력*/
						else begin
							//입력 공간이 있을 때 만 입력 받음 입력 무시
							if ((operand1 < 10_000 && signBit) || operand1 < 100_000) begin
								operand1 = operand1 * 10 + buffer[3:0];
								cnt_input <= cnt_input +1;		//입력 카운터 증가
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							/*부호 비트+숫자 결합 출력*/
							if (signBit)
								fnd_serial = ~operand1 + 1;
							else
								fnd_serial = operand1;
						end
					end
				end

				operator_in : begin				//연산자 입력 모드
					cal_enable	<= 0;
					signBit		<= 0;			//sign 비트 초기화
					cnt_input	<= 0;			//입력 카운터 초기화
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
								if (operator) begin				//입력받은 연산자가 있을 때
									state <= operand2_in;	//두번째 피연산자 입력 모드
								end
								else begin
									cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
									buffer <= buffer >> 4;
								end
							end
							'hf: /* = */ begin
								cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
								buffer <= buffer >> 4;
							end
							default: state <= operand2_in;	//두번째 피연산자 입력 모드
						endcase
					end
					fnd_serial = {operator, 20'h0_0000};
				end

				operand2_in : begin			//두번째 피연산자 입력 모드
					cal_enable	<= 0;
					if (cnt_buffer) begin
						/*연산자 입력*/
						if (buffer[3:0] > 'h9) begin		//연산자 입력이라면
							/*아무 숫자도 입력되지 않았을 때 연산자 누르는 경우
							*연산자 입력 모드에서 0을 누르고 넘어올 경우 가능함
							*/
							if (!cnt_input) begin
								/*맨 처음 부호 입력*/
								if (buffer[3:0] == 'hc) begin	//부호 입력
									signBit = ~signBit;			//부호 비트 설정
									cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
									buffer <= buffer >> 4;
									
									if (signBit) begin
										fnd_serial = 'hE000_0000;	//segment -0 출력
									end else begin
										fnd_serial = 'h0000_0000;	//segment 0 출력
									end
								end
								/*맨 처음 ans 입력*/
								else if (buffer[3:0] == 'he) begin	//ans 입력
									/*부호 비트+문자 결합 출력*/
									if (signBit) begin
										operand2 <= ~mem + 1;
										fnd_serial = 'hE0B0_0000;	//-ANS 출력
									end else begin
										operand2 <= mem;
										fnd_serial = 'h00B0_0000;	//ANS 출력
									end
									cnt_input <= cnt_input +1;		//입력 카운터 증가
									cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
									buffer <= buffer >> 4;							
								end
							end
							else begin
								cal_enable	<= 1;				//ans 얻어옴
								state <= calculating;			//계산 모드
							end
						end
						/*숫자 입력*/
						else begin
						//입력 공간이 있을 때만 입력 받음 입력 무시
							if ((operand2 < 10_000 && signBit) || operand2 < 100_000) begin	//입력 공간이 있을 때
								operand2 = operand2 * 10 + buffer[3:0];
								cnt_input <= cnt_input +1;		//입력 카운터 증가
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							/*부호 비트+숫자 결합 출력*/
							if (signBit)
								fnd_serial = ~operand2 + 1;
							else
								fnd_serial = operand2;
						end
					end
				end

				calculating : begin			//결과 출력 모드
					cnt_input	<= 0;		//입력 카운터 초기화
					cal_enable	<= 0;
					if (cnt_buffer) begin
						/*입력된 연산자가 등호일 때*/
						if(buffer[3:0] == 'hf) begin	// 등호 입력
							/*overflow 확인*/
							if (ans == 'h00EE_0000)
								state <= ERROR;			//Error state 초기화
							else
								fnd_serial = ans;		//연산 결과 출력
							/*reset buffer*/
							signBit		<= 0;			//부호 비트 초기화
							buffer		<= 0;			//입력 버퍼 초기화
							cnt_buffer	<= 0;			//버퍼 카운터 초기화
							/*reset calculator input*/
							operand1	<= 0;			//피연산자 초기화
							operand2	<= 0;			//피연산자 초기화
							operator	<= 0;			//연산자 초기화
						end
						/*입력된 연산자가 ans 일 때*/
						else if (buffer[3:0] == 'he) begin
							state <= ideal;		//연산자 입력 모드
						end
						/*입력된 연산자가 등호가 아닐 때*/
						else if (buffer[3:0] > 'h9) begin
							state <= operator_in;		//연산자 입력 모드
							operand1 <= ans;			//피연산자1에 ans 대입
							operand2 <= 0;				//피연산자 초기화
							signBit	 <= 0;			//sign 비트 초기화
						end
						/*연산 결과 출력 모드에서 숫자 입력 시*/
						else begin						//숫자 입력 시
							state <= ideal;				//초기 화면으로
						end
					end
				end

				ERROR : begin
					//error
					fnd_serial = 'h00EE_0000;
				end
			endcase
		end
	end
endmodule