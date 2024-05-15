module channel #(
	parameter	[2:0]	KEY = 7
)(
	input		[0:8]	data_in,
	output	reg	[0:8]	data_out
);
	reg	[2:0]	single_bit_error;
	reg	[0:8]	temp;
	always @(*) begin
		/*hash function*/
		single_bit_error[0] = data_in[0] & data_in[1] ^ data_in[6];
		single_bit_error[1] = data_in[2] & data_in[3] ^ data_in[7];
		single_bit_error[2] = data_in[4] & data_in[5];
		single_bit_error = single_bit_error ^ KEY;

		/*error inject*/
		temp = data_in;
		temp[single_bit_error] = single_bit_error[0];
		data_out = temp;
	end
endmodule