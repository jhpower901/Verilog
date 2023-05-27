module init_val_gen (clk, current_val, fixed, cycle, init_val_out);
	input wire [3:0] clk;
	input wire [7:0] current_val;
	input wire fixed, cycle;
	output reg [7:0] init_val_out;

	always @(posedge clk) begin
		if (fixed || cycle)
			init_val_out = current_val + 1;

	end
endmodule