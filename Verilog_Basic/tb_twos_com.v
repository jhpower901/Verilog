module tb_twos_com();
	reg [7:0] i_twos;
	wire [7:0] o_twos;

	twos_com twos_com0(.i_twos (i_twos), .o_twos (o_twos));

	initial begin
		i_twos = 8'b10010010;
		#20
		i_twos = 8'b00010111;
		#20
		i_twos = 8'b11001000;
	end
endmodule
