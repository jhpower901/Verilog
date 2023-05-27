`timescale 1ns/100ps
`include "counter.v"
`include "gene_net.v"
`include "fixed_point_checker.v"
`include "cycle.v"

module tb_top;
endmodule


module tb_gene_net;
	reg clk;
	reg [7:0] init_val;
	wire [7:0] x;

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

	//instansiation gene_net
	gene_net G1 (.clk(clk), .x_in(init_val), .x_out(x));

	//input signal generation
	initial begin
		init_val = 8'b0000_0000;	//0 	fixed_point	0000_0000
		#10
		init_val = 8'b0011_1000;	//56 	cycle		0001_1100
		#10
		init_val = 8'b0110_0011;	//99 	fixed_point	0101_0011
		#10
		init_val = 8'b0111_1100;	//124 	cycle		1011_0010
		#10
		init_val = 8'b1111_1111;	//255 	fixed_point	0101_0011
		#10
		$finish;					//end simulation
	end

endmodule

module tb_fixed_point_cheker;
	reg clk;
	reg [7:0] init_val;
	wire [7:0] x;
	wire fixed_chk;

	//clk signal generation
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	gene_net G1 (.clk(clk), .x_in(init_val), .x_out(x));
	fixed_point_cheker F1 (.clk(clk), .init_val_chk(init_val), .x(x), .flag(fixed_chk));


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


endmodule

module tb_cycle;
	reg clk;
	reg [7:0] init_val;
	wire [7:0] x;
	wire cycle_chk;

	//clk signal generation
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	gene_net G1 (.clk(clk), .x_in(init_val), .x_out(x));
	cycle C1 (.clk(clk), .init_val_chk(init_val), .x(x), .flag(cycle_chk));

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

endmodule