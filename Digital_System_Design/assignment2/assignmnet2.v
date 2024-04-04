module assignmnet2 (
	input  wire	signed	[15:0]	in_A, in_B,	//operand
	input  wire			[2:0] 	opcode,		//operator sel
	output reg	signed	[31:0]	result,		//result
	output reg					is_ovf		//overflow checker
	);
	always @(*) begin
		case (opcode)
			//singed add
			3'b000: begin
				result = in_A + in_B;
				//overflow check;요구사항 2에서 기술한 오버플로우 조건
				is_ovf = (~in_A[15] & ~in_B[15] & result[31]) | (in_A[15] & in_B[15] & ~result[31]);
			end
			//singed substract
			3'b001: begin
				result = in_A - in_B;
				//overflow check;요구사항 2에서 기술한 오버플로우 조건
				is_ovf = (in_A[15] & ~in_B[15] & ~result[31]) | (~in_A[15] & in_B[15] & result[31]);
			end
			//signed multiplication
			3'b010: begin
				result = in_A * in_B;
				is_ovf = 0;
			end
			//logical shift left
			3'b011: begin
				result = in_A << in_B;
				is_ovf = 0;
			end
			//logical shift right
			3'b100: begin
				result = in_A >> in_B;
				is_ovf = 0;
			end
			//arithmetic shift left
			3'b101: begin
				result = in_A <<< in_B;
				is_ovf = 0;
			end
			//arithnetic shift right
			3'b110: begin
				result = in_A >>> in_B;
				is_ovf = 0;
			end
			//rst
			3'b111: begin
				result = 0;
				is_ovf = 0;
			end
		endcase
	end
endmodule