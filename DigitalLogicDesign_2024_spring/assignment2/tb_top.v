`timescale 1ns/1ns
module tb_top;
 	reg  [3:0] in;
	wire [3:0] out;
	wire [3:0] gray;

	initial begin
		for (in = 0; in < 4'b1111; in = in + 1) begin
			#10;
			$display("%2d: %b -> %b", in, gray, out);
		end
		$finish;
	end

	bin2gray    DUT1 (.bin(in), .gray(gray));
	gray2excess DUT2 (.gray(gray), .excess(out));
endmodule