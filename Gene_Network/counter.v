`timescale 1ns/100ps
module counter(clk, rst, cnt);
	input wire clk, rst;
	output reg [3:0] cnt;

  always @(posedge clk or posedge rst)
	if (rst)	cnt <= 0;
	else		cnt <= cnt + 1;

endmodule