module simpleALU (
	input		signed	[15:0]	in_A, in_B,	//operand
	input 				[2:0] 	opcode,		//operator sel
	output	reg	signed	[31:0]	result,		//result
	output	reg					is_ovf		//overflow checker
);
	wire [15:0] res_add, res_sub, res_shi;
	wire [31:0] res_mul;
	wire		ovf_add, ovf_sub, ovf_mul, ovf_shi;

	always @(*) begin
		case (opcode)
			3'b000: begin
				result <= {{16{res_add[15]}}, res_add};
				is_ovf <= ovf_add;
			end
			3'b001: begin
				result <= {{16{res_sub[15]}}, res_sub};
				is_ovf <= ovf_sub;
			end
			3'b010: begin
				result <= res_mul;
				is_ovf <= ovf_mul;
			end
			3'b011, 3'b100, 3'b101, 3'b110: begin
				result <= {{16{res_shi[15]}}, res_shi};
				is_ovf <= ovf_shi;
			end
			default: begin
				result <= 32'bx;
				is_ovf <= 1'bx;
			end
		endcase
	end

	adder		adder1		(.in_A(in_A), .in_B(in_B), .result(res_add), .is_ovf(ovf_add));
	subtractor	subtractor1	(.in_A(in_A), .in_B(in_B), .result(res_sub), .is_ovf(ovf_sub));
	multiplier	multiplier1	(.in_A(in_A), .in_B(in_B), .result(res_mul), .is_ovf(ovf_mul));
	shifters	shifters1	(.in_A(in_A), .in_B(in_B), .opcode(opcode[1:0]), .result(res_shi), .is_ovf(ovf_shi));
endmodule

module adder (
	input  signed	[15:0]	in_A, in_B,	//operand
	output signed	[15:0]	result,		//result
	output 					is_ovf		//overflow checker
);
	assign result = in_A + in_B;
	//overflow check;요구사항 2에서 기술한 오버플로우 조건
	assign is_ovf = (~in_A[15] & ~in_B[15] & result[15]) | (in_A[15] & in_B[15] & ~result[15]);
endmodule

module subtractor (
	input  signed	[15:0]	in_A, in_B,	//operand
	output signed	[15:0]	result,		//result
	output 					is_ovf		//overflow checker
);
	assign result = in_A - in_B;
	//overflow check;요구사항 2에서 기술한 오버플로우 조건
	assign is_ovf = (in_A[15] & ~in_B[15] & ~result[15]) | (~in_A[15] & in_B[15] & result[15]);
endmodule

module multiplier (
	input  signed	[15:0]	in_A, in_B,	//operand
	output signed	[31:0]	result,		//result
	output 					is_ovf		//overflow checker
);
	assign result = in_A * in_B;
	assign is_ovf = 0;
endmodule

module shifters (
	input	signed	[15:0]	in_A,
	input			[15:0]	in_B,		//operand
	input 			[1:0] 	opcode,		//operator sel
	output	signed	[15:0]	result,		//result
	output					is_ovf		//overflow checker
);
	assign is_ovf = 0;
	assign result = 	(opcode == 2'b11) ? in_A << in_B :	//logical shift left
					(opcode == 2'b00) ? in_A >> in_B :	//logical shift right
					(opcode == 2'b01) ? in_A <<< in_B :	//arithmetic shift left
					(opcode == 2'b10) ? {{16{in_A[15]}}, in_A} >>> in_B :	//arithnetic shift right
					16'bx;
		
endmodule