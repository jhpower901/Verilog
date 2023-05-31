`timescale 1ns/100ps
module cycle (clk, rst, x, flag);
	input wire clk;						//clock signal
	input wire [7:0] rst;		//is init val changed?
	input wire [7:0] x;					//t+1 gene state
	output reg flag;					//cycle has occured!
	reg [3:0] cnt;						//counter
	reg [7:0] state_1;					//state of x[t]
	reg [7:0] state_2;					//state of x[t-1]

	always @(rst) begin	//if init val changed
		flag = 0;					//reset cycle  flag
		cnt = 0;					//counter reset
	end

	always @(posedge clk) begin		//synchronized with positive edge clock signal
		cnt <= cnt + 1;				//counter++
		if (cnt > 2) begin			//when counter > 2
			if (state_2 == x && state_1 != x) begin			//when x[t-1] == x[t+1]
<<<<<<< HEAD
				flag = 1;					//It's cycle
				$display("init: %b -> cycle_pnt: %b", rst, x);
=======
				flag = 1;									//It's cycle
				$display("init: %d -> cycle_pnt: %b", rst, x);
>>>>>>> 5a261705bd7ce5e9a7e8f6cc7ebb676da95037f7
			end else
				flag = 0;
		end
		state_2 = state_1;			//save x[t-1]
		state_1 = x;				//save x[t]
	end
endmodule