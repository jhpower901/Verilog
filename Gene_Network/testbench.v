`timescale 1ns/100ps
`include "gene_net.v"
`include "fixed_point_checker.v"
`include "cycle.v"

module testbench;
	reg [7:0] init_val;		//검증 대상이 되는 입력 신호
	wire [7:0] x_out;		//검증 대상이 되는 출력 신호

	//call
	gene_net ()

	inital
	begin
		init_val = 8'b0000_0000;	//0
		#20
		init_val = 8'b0011_1000;	//56
		#20
		init_val = 8'b0100_0001;	//65
		20
		init_val = 8'b0110_01000;	//200
		#20
		init_val = 8'b1111_1111;	//255
		#20
		$stop
	end

endmodule