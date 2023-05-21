`timescale 1ns/100ps
`include "ham_enc.v"
`include "ham_dec.v"
`include "bit_com.v"
`include "Top.v"

module tb_top();
reg [11:0]info_bits;
wire [11:0]esti_bits;
wire [3:0]ham_dis;

//top module instantiation
top top0(info_bits, esti_bits, ham_dis);

initial begin
	$dumpfile("dump.vcd");
	$dumpvars(3, tb_top);

	info_bits = 12'b0000_1010_1111;
	#20
	info_bits = 12'b1010_0101_1101;
	#20
	info_bits = 12'b1001_0111_1010;
	#20
	info_bits = 12'b0101_1101_0000;
	#20
	info_bits = 12'b1011_1111_1000;
	#20
	info_bits = 0;
end
endmodule

module tb_ham_enc();
	reg [11:0]info_bits;
	wire [16:0]codeword;

	ham_enc uut (.info_bits(info_bits), .codeword(codeword));

	initial begin
		$dumpvars(0, tb_ham_enc);

		info_bits = 12'b0000_1010_1111;
	end
endmodule

module tb_ham_dec();
	reg [16:0]codeword;
	wire [11:0]esti_bits;

	ham_dec uut (.codeword(codeword), .esti_bits(esti_bits));

	initial begin
		$dumpvars(1, tb_ham_dec);
		
		codeword = 17'b0_0000_1010_0111_0101;
		#20
		codeword = 0;
		
	end

endmodule

module tb_bit_com();
	reg [11:0]info_bits, esti_bits;
	wire [3:0]ham_dis;

	bit_com uut (.info_bits(info_bits), .esti_bits(esti_bits), .ham_dis(ham_dis));

	initial begin
		$dumpvars(2, tb_bit_com);

		info_bits = 12'b0000_1010_1111;
		esti_bits = 12'b0000_1011_1100; // haming distance 3
		#20
		info_bits = 12'b0000_1010_1111;
		esti_bits = 12'b0110_0011_1101; // haming distance 5
		#20
		info_bits = 12'b0000_1010_1111;
		esti_bits = 12'b0001_1000_1100; // haming distance 4
		#20
		info_bits = 12'b0010_1000_0111; 
		esti_bits = 12'b0000_1010_1111; // haming distance 3
		#20
		info_bits = 0;
		esti_bits = 0;
	end


endmodule