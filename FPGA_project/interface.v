module interface(sw_clk, rst, eBCD, ans, operand1, operand2, operator, fnd_serial);
	input sw_clk;						//switch clk
	/*key input*/
	input rst;							//비동기 reset
	input [4:0]	eBCD;					//키보드 입력
	/*claculate var*/
	input [31:0] ans;			//연산 결과
	output reg  [31:0]	operand1 = 0;	//피연산자
	output reg  [31:0]	operand2 = 0;	//피연산자
	output reg	 [2:0]	operator = 3;	//연산자
	/*segment serial*/
	output reg	[31:0]	fnd_serial;		//segment 출력 데이터


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
	reg 		signBit		= 0;	//부호 입력 버퍼
	reg	[27:0]	buffer		= 0;	//피연산자 절대값 입력 버퍼
	reg [2:0]	cnt_buffer	= 0;	//버퍼 카운터


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
						/*부호 입력*/
						if (buffer[3:0] == 'hc) begin	//부호 입력
							signBit = ~signBit;			//부호 비트 설정
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							fnd_serial <= 'hE000_0000;	//segment -0 출력
						end
						/*ans 입력*/
						else if (buffer[3:0] == 'he) begin	//ans 입력
							/*부호 비트+문자 결합 출력*/
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
						/*연산자 입력*/
						else if (buffer[3:0] > 'h9) begin	//연산자 입력이라면
							operand1 <= ans;				//첫번째 피연산자 ans 대입
							state <= operator_in;			//연산자 입력 모드
						end
						/*숫자 입력*/
						else begin
							//입력 공간이 있을 때 만 입력 받음 입력 무시
							if ((operand1 < 10_000 && signBit) || operand1 < 100_000) begin
								operand1 = operand1 * 10 + buffer[3:0];
							end
							cnt_buffer <= cnt_buffer - 1;	//buffer에서 문자 삭제
							buffer <= buffer >> 4;
							/*부호 비트+숫자 결합 출력*/
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
						end else begin					//숫자 입력 시
							state <= ideal;				//초기 상태로
						end
					end
				end

				ERROR : begin
					//error
				end
			endcase
		end
	end
endmodule