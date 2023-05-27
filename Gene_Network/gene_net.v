`timescale 1ns/100ps

module gene_net(clk, x_in, x_out);
	input wire clk;
	input wire [7:0] x_in;
	output reg [7:0] x_out;
	reg [7:0] state;
	
	always @(x_in) begin
		state <= x_in;
	end

	always @(posedge clk)
	begin
		x_out[0] <= ~state[2] & state[6] & ~state[7];
		x_out[1] <= (state[4] | state[5]) & ~state[7];
		x_out[2] <= state[7];
		x_out[3] <= state[1] & ~state[6];
		x_out[4] <= state[1] | state[3];
		x_out[5] <= state[2] & ~state[7];
		x_out[6] <= state[1] & ~state[7];
		x_out[7] <= ~(state[0] | state[1]) & (state[3] | state[6]);
		state = x_out;
	end

	always @(x_in) begin
		state <= x_in;
	end

endmodule