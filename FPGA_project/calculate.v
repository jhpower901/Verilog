module calculate (sw_clk, rst, operand1, operand2, operator, result);
	input sw_clk;
	input rst;										//reset
	input	signed 	[31:0]	operand1;				//피연산자 2
	input	signed 	[31:0]	operand2;				//피연산자 1
	input 			[2:0]	operator;				//연산자
	output	reg		[31:0]	result = 'h00CC0000;	//연산 결과 출력

	reg signed	[63:0]	ans;				//연산 결과

	always @(posedge sw_clk, negedge rst) begin
		if (~rst) begin
			ans <= 0;
		end else begin
			case(operator)
				0 : ans <= operand1 + operand2;
				1 : ans <= operand1 - operand2;
				2 : ans <= operand1 * operand2;
				3 : ans <= operand1 / operand2;
				4 : ans <= operand1 % operand2;
				default : ans <= 'h00EE0000;		//Error
			endcase
		end
	end

	always @(ans) begin
		if ( (-'sd100_000 < ans) && (ans < 'd1_000_000))
			result <= ans;		//표현 가능 범위일 때
		else
			result <= 'h00EE0000;			//표현 불가 범위일 때
	end
endmodule