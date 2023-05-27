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
		forever #1 clk = ~clk;
	end

	always @(init_mod) begin
		if (init_mod == 0)
			$finish;
		init_val = init_mod;
	end

	init_val_gen INIT (.clk(clk), .current_val(init_val), .fixed(fixed_chk), .cycle(cycle_chk), .init_val_out(init_mod));
	cycle CYCLE (.clk(clk), .init_val_chk(init_val), .x(x), .flag(cycle_chk));
	fixed_point_cheker FIX (.clk(clk), .init_val_chk(init_val), .x(x), .flag(fixed_chk));
	gene_net GENE (.clk(clk), .init_val_chk(init_val), .x_out(x));

endmodule

/*
gene_net TESTBENCH
	Give set of init value composed of making variable network state and verify module
*/
module tb_gene_net;
	/***gene_net INPUT***/
	reg clk;				//clock signal
	reg [7:0] init_val;		//init value of gene network
	/***gene_net OUTPUT***/
	wire [7:0] x;			//current state of gene network

	//clk signal generation
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	//file dumping
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0, tb_gene_net);
	end

	//input signal generation
	initial begin
		init_val = 8'b0000_0000;	//0 	fixed_point	-> 0000_0000
		#10
		init_val = 8'b0011_1000;	//56 	cycle occur	-> 0001_1100
		#10
		init_val = 8'b0110_0011;	//99 	fixed_point	-> 0101_0011
		#10
		init_val = 8'b0111_1100;	//124 	cycle occur	-> 1011_0010
		#10
		init_val = 8'b1111_1111;	//255 	fixed_point	-> 0101_0011
		#10
		$finish;					//end simulation
	end

	//instansiation gene_net
	gene_net GENE (.clk(clk), .init_val_chk(init_val), .x_out(x));

endmodule

/*
fixed_point_cheker TESTBENCH
	1. Input sets of init value that create various network states are entered into the module.
	2. Then again, input it's output to fixeg_point_checkr module.
*/
module tb_fixed_point_cheker;
	/***gene_net INPUT***/
	reg clk;							//clock signal
	reg [7:0] init_val;					//init value of gene network
	/***gene_net OUTPUT***/
	wire [7:0] x;						//current state of gene network
	/***fixed_point_checker OUTPUT***/
	wire fixed_chk;						//flag of fixed point checking
										//1: fixed point  0:none
	//clk signal generation
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
		init_val = 8'b0000_0000;	//0 	fixed_point	0000_0000
		#20
		init_val = 8'b0011_1000;	//56 	cycle		0001_1100
		#20
		init_val = 8'b0110_0011;	//99 	fixed_point	0101_0011
		#20
		init_val = 8'b0111_1100;	//124 	cycle		1011_0010
		#20
		init_val = 8'b1111_1111;	//255 	fixed_point	0101_0011
		#20
		$finish;					//end simulation
	end

	//instansiation gene_net
	fixed_point_cheker FIX (.clk(clk), .init_val_chk(init_val), .x(x), .flag(fixed_chk));
	gene_net GENE (.clk(clk), .x_in(init_val), .x_out(x));

endmodule

/*
cycle TESTBENCH
	1. Input sets of init value that create various network states are entered into the module.
	2. Then again, input it's output to cycle module.
*/
module tb_cycle;
	/***gene_net INPUT***/
	reg clk;							//clock signal
	reg [7:0] init_val;					//init value of gene network
	/***gene_net OUTPUT***/
	wire [7:0] x;						//current state of gene network
	/***cycle OUTPUT***/
	wire cycle_chk;						//flag of cycle checking
										//1: cycle  0:none
	//clk signal generation
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
			init_val = 8'b0000_0000;	//0 	fixed_point	0000_0000
			#20
			init_val = 8'b0011_1000;	//56 	cycle		0001_1100
			#20
			init_val = 8'b0110_0011;	//99 	fixed_point	0101_0011
			#20
			init_val = 8'b0111_1100;	//124 	cycle		1011_0010
			#20
			init_val = 8'b1111_1111;	//255 	fixed_point	0101_0011
			#20
			$finish;					//end simulation
		end

	//instansiation gene_net
	cycle CYCLE (.clk(clk), .init_val_chk(init_val), .x(x), .flag(cycle_chk));
	gene_net GENE (.clk(clk), .init_val_chk(init_val), .x_out(x));

endmodule