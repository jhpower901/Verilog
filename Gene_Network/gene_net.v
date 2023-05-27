`timescale 1ns/100ps

module gene_net(clk, x_in, x_out);
	input wire clk;
	input wire [7:0] x_in;
	output reg [7:0] x_out;
	reg [7:0] state;
	reg [7:0] x;

	always @(x_in)	begin
		x_out = x_in;
	end

	always @(posedge clk)	begin
		state = x_out;
		x[0] = ~state[2] & state[6] & ~state[7];
		x[1] = (state[4] | state[5]) & ~state[7];
		x[2] = state[7];
		x[3] = state[1] & ~state[6];
		x[4] = state[1] | state[3];
		x[5] = state[2] & ~state[7];
		x[6] = state[1] & ~state[7];
		x[7] = ~(state[0] | state[1]) & (state[3] | state[6]);
		x_out = x;
	end

endmodule