`timescale 1ns/1ns
module tb_assignmnet1();
	reg		[3:0]	count;			//init value 4bit counter
	wire			OUT;			//output

	assignment1 DUT(.A(count[3]),
					.B(count[2]),
					.C(count[1]),
					.D(count[0]),
					.OUT(OUT)		);

	initial begin
		for (count = 0; count < 4'b1111; count = count + 1'b1) begin
			//for switch combinations of inputs
			//in order for every 100 timestamps
			#100;
		end
		#100;
		$finish;
	end
endmodule