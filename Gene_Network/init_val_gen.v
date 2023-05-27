module init_val_gen (clk, current_val, fixed, cycle, init_val_out);
	input wire [3:0] clk;					//clock signal
	input wire [7:0] current_val;			//currnet init value of GENE NETWORK
	input wire fixed, cycle;				//flag of fixed point & cycle
	output reg [7:0] init_val_out;			//output init val++

	always @(negedge clk) begin					//synchronized with negative edge clock signal
		if (fixed || cycle)						//if fixed or cycle occured
			init_val_out = current_val + 1;		//init val++
	end
endmodule