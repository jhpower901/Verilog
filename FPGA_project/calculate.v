module calculate (sw_clk, rst, operand1, operand2, operator, result);
	input sw_clk;
	input rst;								//reset
	input	signed 	[31:0]	operand1;		//피연산자 2
	input	signed 	[31:0]	operand2;		//피연산자 1
	input 			[2:0]	operator;		//연산자
	output	signed	[31:0]	result;			//연산 결과 출력

	reg signed	[63:0]	ans;				//연산 결과

	always @(negedge rst) begin
		if (~rst) begin
			ans <= 0;
		end
		case(operator)
			0 : ans <= operand1 + operand2;
			1 : ans <= operand1 - operand2;
			2 : ans <= operand1 * operand2;
			3 : ans <= operand1 / operand2;
			4 : ans <= operand1 % operand2;
		endcase
	end


endmodule