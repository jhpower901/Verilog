module segment_driver (fnd_clk, rst, fnd_serial, nfnd_s, fnd_d);
	input fnd_clk;
	input rst;
	input [31:0] fnd_serial;
	output reg [5:0] nfnd_s;	//segment select negative decoder 필요
	output reg [7:0] fnd_d;		//segment anode  positive decoder 

	integer i;
	reg [2:0] fnd_cnt;			//segment selector
	reg [7:0] segment [5:0];	//fnd 표시 위치별 데이터


	localparam fnd_0 = 8'b0011_1111;		//0
	localparam fnd_1 = 8'b0000_0110;		//1
	localparam fnd_2 = 8'b0101_1011;		//2
	localparam fnd_3 = 8'b0100_1111;		//3
	localparam fnd_4 = 8'b0110_0110;		//4
	localparam fnd_5 = 8'b0110_1101;		//5
	localparam fnd_6 = 8'b0111_1101;		//6
	localparam fnd_7 = 8'b0000_0111;		//7
	localparam fnd_8 = 8'b0111_1111;		//8
	localparam fnd_9 = 8'b0110_0111;		//9
	localparam fnd_t = 8'b0111_1000;		//t
	localparam fnd_p = 8'b0111_0011;		//P
	localparam fnd_A = 8'b0111_0111;		//A
	localparam fnd_b = 8'b0111_1100;		//b
	localparam fnd_c = 8'b0011_1001;		//C
	localparam fnd_D = 8'b0101_1110;		//d
	localparam fnd_E = 8'b0111_1001;		//E
	localparam fnd_r = 8'b0101_0000;		//r
	localparam fnd_h = 8'b0100_0000;		//-
	localparam fnd_n = 8'b0101_0100;		//n
	localparam fnd_	 = 8'b0000_0000;		//null



	always @(posedge fnd_clk, negedge rst) begin
		if (~rst) begin
			for (i = 0; i < 6; i = i + 1)
				segment[i] = fnd_;
		end
	end

	always @(posedge fnd_clk) begin
		if (~(fnd_cnt < 6))
		fnd_cnt <= fnd_cnt + 1;
	end

endmodule