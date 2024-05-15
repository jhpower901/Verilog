module reciever (
	input	[8:0]	data_in,
	output			error_check
);
	assign error_check = ^data_in;
endmodule