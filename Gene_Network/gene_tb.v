`timescale 1ps/1ps	
	
	genvar init, index;
	reg [7:0] init_val;

	initial
	begin
		init_val = 8'b0000_0000;
	end

	for (init = 0; init < 256; init_val = init + 1 )
	begin
		assign x_out[0] = ~x_in[2] & x_in[6] & ~x_in[7];
		assign x_out[1] = (x_in[4] | x_in[5]) & ~x_in[7];
		assign x_out[2] = x_in[7];
		assign x_out[3] = x_in[1] & ~x_in[6];
		assign x_out[4] = x_in[1] | x_in[3];
		assign x_out[5] = x_in[2] & ~x_in[7];
		assign x_out[6] = x_in[1] & ~x_in[7];
		assign x_out[7] = ~(x_in[0] | x_in[1]) & (x_in[3] | x_in[6]);

		for (index = 0; index < 8; index = index + 1)
			assign x_out[index];
	end
