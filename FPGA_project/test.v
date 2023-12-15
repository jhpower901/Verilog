module test (fnd_clk, fnd_serial, segment_serial);
	input fnd_clk;
	input [31:0] fnd_serial;		//출력해야하는 데이터
	output reg [47:0] segment_serial;	//출력 anode serial

	reg [31:0] data;			//fnd_serial 저장해 놓을 레지스터
	reg [3:0]  temp;			//임시 변수
	reg [7:0] segment [5:0];		//각 자리마다 출력되는 anode
	reg signBit;					//출력되는 데이터의 부호
	reg [2:0]  i;				//for loop 제어 변수

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
	localparam fnd_C = 8'b0011_1001;		//C
	localparam fnd_D = 8'b0101_1110;		//d
	localparam fnd_E = 8'b0111_1001;		//E
	localparam fnd_r = 8'b0101_0000;		//r
	localparam fnd_h = 8'b0100_0000;		//-
	localparam fnd_n = 8'b0101_0100;		//n
	localparam fnd_u = 8'b0011_1110;		//u
	localparam fnd_i = 8'b0011_0000;		//i
	localparam fnd_L = 8'b0011_1110;		//L
	localparam fnd_v = 8'b0001_1100;		//v
	localparam fnd_o = 8'b0101_1100;		//o
	localparam fnd_H = 8'b0111_0110;		//H
	localparam fnd_y = 8'b0110_0110;		//y
	localparam fnd_	 = 8'b0000_0000;		//null




	always @(posedge fnd_clk) begin
		signBit = fnd_serial[31];			//부호 비트 추출
		if (signBit)						//음수일 때
			data = ~fnd_serial + 1;			//2의 보수
		else
			data = fnd_serial;


		for (i = 0; i < 6; i = i + 1) begin
			temp =  data % 10;		//자릿 수 추출
			data = data / 10;		//10진수 오른쪽 shift
			if (!data)		//data == 0일 때 loop 탈출
				segment[i] <= fnd_;
			else begin
				case (temp)					//10진수에 맞는 anode 저장
					0 : segment[i] <= fnd_0;
					1 : segment[i] <= fnd_1;
					2 : segment[i] <= fnd_2;
					3 : segment[i] <= fnd_3;
					4 : segment[i] <= fnd_4;
					5 : segment[i] <= fnd_5;
					6 : segment[i] <= fnd_6;
					7 : segment[i] <= fnd_7;
					8 : segment[i] <= fnd_8;
					9 : segment[i] <= fnd_9;
				endcase
			end
			if (signBit)							//음수일 때
				segment[5] <= fnd_h;				//부호 출력
		end
		segment_serial <= {segment[5], segment[4], segment[3], segment[2], segment[1], segment[0]};
	end
endmodule