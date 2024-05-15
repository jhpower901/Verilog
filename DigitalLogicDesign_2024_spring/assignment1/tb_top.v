`timescale 1ns/1ns

module tb_top;
	reg		[7:0]	data_in;
	wire	[8:0]	data_send, data_error;
	wire			error_check;
	integer			i, error_count = 0;

	initial begin
		for(i = 0; i < 10; i = i + 1) begin
			data_in = $random;
			#10;
		end
		$finish;
	end

	always @(i) begin
		if (error_check)
			error_count = error_count + 1;
		
		$display("%2d: send    | %b -> parity bit : %b\n", i, data_send, data_send[0]);
		$display("    recieve | %b -> error chk : %d\n\n", data_error, error_check);
	end

	sender				DUT1 (.data_in(data_in), .data_out(data_send));
	channel	#(.KEY(2))	DUT2 (.data_in(data_send), .data_out(data_error));
	reciever			DUT3 (.data_in(data_error), .error_check(error_check));
endmodule

module tb_sender;
	reg		[7:0]	data_in;
	wire	[8:0]	data_send;

	initial begin
		repeat(10) begin
			data_in = $random;
			#10;
		end
		$finish;
	end

	always @(data_send) begin
		$display("{%b, %b} -> %b", data_in, data_send[0], data_send);
	end
	sender	DUT (.data_in(data_in), .data_out(data_send));
endmodule

module tb_channel;
	reg		[8:0]	data_in;
	wire	[8:0]	data_error[0:7];
	integer			i, j;

		initial begin
		for(i = 0; i < 10; i = i + 1) begin
			data_in = $random;
			#10;
		end
		$finish;
	end

	always @(data_error) begin
		$display("%2d: send | %b", i, data_in);
		for(j = 0; j < 8; j = j + 1)
			$display("    key:%d | %b", j, data_error[j]);
	end

	genvar key;
	generate
		for (key = 0; key < 8; key = key + 1) begin : hashkey
			channel	#(.KEY(key))	DUT (.data_in(data_in), .data_out(data_error[key]));
		end
	endgenerate
endmodule

module tb_reciever;
	reg		[8:0]	data_in;
	wire			error_check;

	initial begin
		repeat(10) begin
			data_in = $random;
			#10;
		end
		$finish;
	end
	always @(error_check) begin
		$display("%b -> parity : %b", data_in, error_check);
	end
	reciever	DUT (.data_in(data_in), .error_check(error_check));
endmodule