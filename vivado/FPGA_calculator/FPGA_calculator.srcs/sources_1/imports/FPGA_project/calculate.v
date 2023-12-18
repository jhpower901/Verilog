module calculate (enable, rst, operand1, operand2, operator, ans);
	input enable;							//연산기 enable
	input rst;										//reset
	input	signed 	[31:0]	operand1;				//피연산자 2
	input	signed 	[31:0]	operand2;				//피연산자 1
	input 			[2:0]	operator;				//연산자
	output	reg	signed [31:0]	ans = 0;		//연산 결과 출력

	reg signed	[63:0]	result;				//연산 결과

	always @(posedge enable, negedge rst) begin
		if (~rst) begin
			result <= 0;
		end else begin
			/*
				연산자 별 code
				=:	0 000
				*:	1 001
				/:	2 010
				+:	3 011
				-:	4 100
				%:	5 101
			*/
			case(operator)
				1 : result <= operand1 * operand2;
				2 : if (operand2)
						result <= operand1 / operand2;	//DIV 0!
					else result <= 'h00EE0000;
				3 : result <= operand1 + operand2;
				4 : result <= operand1 - operand2;
				5 : if (operand2)
						result <= operand1 % operand2;	//DIV 0!
					else result <= 'h00EE0000;
				default : result <= 'h00CC0000;		//NULL
			endcase
		end
	end

	always @(result) begin
		if (-64'sd100_000 < result && result < 64'sd1_000_000)
			ans <= result;			//표현 가능 범위일 때
		else
			ans <= 'h00EE0000;		//표현 불가 범위일 때
	end
endmodule