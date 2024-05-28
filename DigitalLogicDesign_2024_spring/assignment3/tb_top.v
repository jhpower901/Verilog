`timescale 1ns/1ns

module tb_top;
	reg [3:0] number;
	wire	  is_prime;
	
	initial begin
		for (number = 0; number < 4'b1111; number = number + 1) begin
			#10;
			$display("%4b is prime number? -> %s", number, is_prime?"yes":"no");
		end
		#10;
		$stop;
	end
	primeNumDetector DUT (number, is_prime);
endmodule
