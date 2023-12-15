module calculate (sw_clk, rst, operand1, operand2, operator, ans);
	input sw_clk;
	input rst;										//reset
	input	signed 	[31:0]	operand1;				//피연산자 2
	input	signed 	[31:0]	operand2;				//피연산자 1
	input 			[2:0]	operator;				//연산자
	output	reg		[31:0]	ans = 'h00CC0000;	//연산 결과 출력

	reg signed	[63:0]	result;				//연산 결과

	always @(posedge sw_clk, negedge rst) begin
		if (~rst) begin
			result <= 0;
		end else begin
			case(operator)
				0 : result <= operand1 + operand2;
				1 : result <= operand1 - operand2;
				2 : result <= operand1 * operand2;
				3 : result <= operand1 / operand2;
				4 : result <= operand1 % operand2;
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