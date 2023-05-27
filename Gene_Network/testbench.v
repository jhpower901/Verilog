`timescale 1ns/100ps
`include "gene_net.v"
`include "fixed_point_checker.v"
`include "cycle.v"

module tb_top;


endmodule

module tb_gene_net;
	reg clock;
	reg [7:0] x_in;
	wire [7:0] x_out;

	//clock signal generation
	always begin
		clock = 0; #1;
		clock = 1; #1;
	end

	//file dumping
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0, tb_gene_net);
	end

	//input signal generation
	initial begin
		x_in = 8'b0000_0000;	//0 	fixed_point	0000_0000
		#20
		x_in = 8'b0011_1000;	//56 	cycle		0001_1100
		#20
		x_in = 8'b0110_0011;	//99 	fixed_point	0101_0011
		#20
		x_in = 8'b0111_1100;	//124 	cycle		1011_0010
		#20
		x_in = 8'b1111_1111;	//255 	fixed_point	0101_0011
		#20
		$finish;					//end simulation
	end

	gene_net G1 (
		.clock(clock),
		.x_in(x_in),
		.x_out(x_out)
		);

	always @(posedge clock)
		$display("Time %0t: x_in = %b, x_out = %b", $time, x_in, x_out);
endmodule

module tb_fixed_point_chk;
//
endmodule

module tb_cycle;
//
endmodule