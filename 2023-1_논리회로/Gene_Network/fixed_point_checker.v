`timescale 1ns/100ps
module fixed_point_cheker(clk, rst, x, flag);
	input wire clk;						//clock signal
	input wire [7:0] rst;		//is init val changed?
	input wire [7:0] x;					//current gene state
	output reg flag;					//Fixed point has been FOUND!
	reg [7:0] state;					//state of x[t]

	always @(rst) begin		//if init val changed
		flag = 0;						//reset cycle  flag
	end

	always @(posedge clk) begin		//synchronized with positive edge clock signal
		if (state == x)	begin			//when x[t-1] == x[t+1]
			flag = 1;					//FIXED POINT!!!	
			$display("init: %d -> fixed_pnt: %b", rst, x);
		end else
			flag = 0;
		state = x;					//save x[t]
	end
endmodule