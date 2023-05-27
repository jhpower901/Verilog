`timescale 1ns/100ps
module fixed_point_cheker(clk, , init_val_chk, x, flag);
	input wire clk;
	input wire [7:0] init_val_chk;
	input wire [7:0] x;
	output reg flag;
	reg [7:0] state;

	always @(init_val_chk) begin
		flag = 0;
		state = 0;
	end

	always @(posedge clk) begin
		if (state == x)
			flag = 1;
		else
			flag = 0;
		state = x;
	end
endmodule