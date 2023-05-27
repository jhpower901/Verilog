`timescale 1ns/100ps
module cycle (clk, init_val_chk, x, flag);
	input wire clk;						//clock signal
	input wire [7:0] init_val_chk;		//is init val changed?
	input wire [7:0] x;					//t+1 gene state
	output reg flag;					//cycle has occured!
	reg [3:0] cnt;						//counter
	reg [7:0] state_1;					//state of x[t]
	reg [7:0] state_2;					//state of x[t-1]

	always @(init_val_chk) begin	//if init val changed
		flag = 0;					//reset cycle  flag
		cnt = 0;					//counter reset
	end

	always @(posedge clk) begin		//synchronized with positive edge clock signal
		cnt <= cnt + 1;				//counter++
		if (cnt > 2) begin			//when counter > 2
			if (state_2 == x)			//when x[t-1] == x[t+1]
				flag = 1;					//It's cycle
			else
				flag = 0;
		end
		state_2 = state_1;			//save x[t-1]
		state_1 = x;				//save x[t]
	end
endmodule