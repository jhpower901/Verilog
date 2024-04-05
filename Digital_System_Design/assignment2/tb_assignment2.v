`timescale 1ns/1ns
module tb_assignmnet2 ();
	reg	 signed	[15:0]	in_A, in_B;
	reg		 	[2:0]	opcode;
	wire signed	[31:0]	result;
	wire				is_ovf;

	integer				i, ERROR;
	reg  signed	[31:0]	ref;

	initial begin
		ERROR = 0;
		for (i = 0; i < 10; i = i + 1) begin
			in_A = $random;
			in_B = $random;

			for (opcode = 0; opcode < 3'b111; opcode = opcode + 1) begin
				case (opcode)
					3'b000: ref = in_A + in_B;
					3'b001: ref = in_A - in_B;
					3'b010: ref = in_A * in_B;
					3'b011: begin
						in_B = {0, in_B[14:0]} % 17;
						ref = in_A << in_B;
					end
					3'b100: begin
						in_B = {0, in_B[14:0]} % 17;
						ref = in_A >> in_B;
					end
					3'b101: begin
						in_B = {0, in_B[14:0]} % 17;
						ref = in_A <<< in_B;
					end
					3'b110: begin
						in_B = {0, in_B[14:0]} % 17;
						ref = in_A >>> in_B;
					end
					default: ref = 0;
				endcase
				#100;
				if ($signed(ref) != $signed(result)) begin
					ERROR = ERROR + 1;
				end
				$display("ref: %d, res: %d\n", ref, result);
			end

		end
		$display("The number of errors: %d\n", ERROR);

		//overflow 1
		in_A = {4'b0111, 12'hFFF};
		in_B = 16'b1;
		opcode = 3'b000;
		#100;
		//overflow 2
		in_A = 16'hFFFF;
		in_B = {1'b1, 15'b1};
		opcode = 3'b000;
		#100;
		//overflow 3
		in_A = 16'hFFFF;
		in_B = {16'b1};
		opcode = 3'b001;
		#100;
		//overflow 4
		in_A = 16'b1;
		in_B = {1'b1, 15'b0};
		opcode = 3'b001;
		#100;

		$finish;
	end

	//assignmnet2 ALU (.in_A(in_A), .in_B(in_B), .opcode(opcode), .result(result), .is_ovf(is_ovf));
	simpleALU ALU (.in_A(in_A), .in_B(in_B), .opcode(opcode), .result(result), .is_ovf(is_ovf));

endmodule