`timescale 1ns/100ps
module counter(clk, rst, cnt);
	input wire clk, rst;
	output reg [3:0] cnt;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			cnt = 0;
		end else begin
			cnt = cnt + 1;
		end
	end
endmodule