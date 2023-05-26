`timescale 1ns/100ps

module gene_net(x_in, x_out);
	input wire [7:0] x_in;
	output reg [7:0] x_out;

	x_out[0] = ~x_in[2] & x_in[6] & ~x_in[7];
	x_out[1] = (x_in[4] | x_in[5]) & ~x_in[7];
	x_out[2] = x_in[7];
	x_out[3] = x_in[1] & ~x_in[6];
	x_out[4] = x_in[1] | x_in[3];
	x_out[5] = x_in[2] & ~x_in[7];
	x_out[6] = x_in[1] & ~x_in[7];
	x_out[7] = ~(x_in[0] | x_in[1]) & (x_in[3] | x_in[6]);

endmodule