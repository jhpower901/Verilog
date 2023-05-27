`timescale 1ns/100ps

module gene_net(clk, init_val_chk, x_out);
	input wire clk;					//clock signal
	input wire [7:0] init_val_chk;	//init value
	output reg [7:0] x_out;			//x[t+1]
	reg [7:0] state;				//x[t]
	reg [7:0] x;					//temporary value

	always @(init_val_chk)	begin	//if init val changed
		x_out = init_val_chk;		//set x[t] == init val
	end

	always @(posedge clk)	begin		//synchronized with positive edge clock signal
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