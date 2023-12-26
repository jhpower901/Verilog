`timescale 1ns/100ps
`include "gene_net.v"
`include "fixed_point_checker.v"
`include "cycle.v"
`include "init_val_gen.v"

module tb_top;
	/***gene_net INPUT***/
	reg clk;							//clock signal
	reg [7:0] init_val;					//init value of gene network
	/***init_val_gen INPUT***/
	wire [7:0] init_mod;				//modified init value of gene network
	/***gene_net OUTPUT***/
	wire [7:0] x;						//current state of gene network
	/***fixed_point_checker OUTPUT***/
	wire fixed_chk;						//flag of fixed point checking
	/***cycle OUTPUT***/
	wire cycle_chk;						//flag of fixed point checking

	//clk signal generation
	initial begin
		clk = 0;
		init_val = 8'b0000_0000;
		forever #0.5 clk = ~clk;
	end

	always @(init_mod) begin
		if (init_mod == 0)
			$finish;
		init_val = init_mod;
	end

	init_val_gen INIT		(.clk(clk), .current_val(init_val), .fixed(fixed_chk), .cycle(cycle_chk), .init_val_out(init_mod));
	cycle CYCLE				(.clk(clk), .rst(init_val), .x(x), .flag(cycle_chk));
	fixed_point_cheker FIX	(.clk(clk), .rst(init_val), .x(x), .flag(fixed_chk));
	gene_net GENE			(.clk(clk), .init_val_chk(init_val), .x_out(x));

endmodule
