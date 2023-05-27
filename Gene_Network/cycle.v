`timescale 1ns/100ps
module cycle (clk, cnt, init_val_chk, x, flag);
	input wire clk;
	input wire [3:0] cnt;
	input wire [7:0] init_val_chk;
	input wire [7:0] x;
	output reg flag;
	reg [7:0] state_1;
	reg [7:0] state_2;

	always @(init_val_chk) begin
		flag = 0;
	end

	always @(posedge clk) begin
		if (cnt > 2) begin
			if (state_2 == x)
				flag = 1;
			else
				flag = 0;
		end
		state_2 = state_1;
		state_1 = x;
	end
endmodule