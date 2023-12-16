module segment_driver (fnd_clk, rst, fnd_serial, fnd_s, fnd_d);
	input fnd_clk;				//fnd clock
	input rst;
	input [31:0] fnd_serial;	//출력해야하는 데이터
	output reg [5:0] fnd_s;		//segment select negative decoder 필요
	output reg [7:0] fnd_d;		//segment anode  positive decoder 

	reg [2:0] fnd_cnt = 0;		//segment selector
	reg [7:0] segment [5:0];	//fnd 표시 위치별 데이터
	reg [47:0] segment_serial;	//출력 anode serial


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
	localparam fnd_N = 8'b0011_0111;		//N
	localparam fnd_u = 8'b0011_1110;		//u
	localparam fnd_i = 8'b0011_0000;		//i
	localparam fnd_L = 8'b0011_1110;		//L
	localparam fnd_v = 8'b0001_1100;		//v
	localparam fnd_o = 8'b0101_1100;		//o
	localparam fnd_H = 8'b0111_0110;		//H
	localparam fnd_y = 8'b0110_0110;		//y
	localparam fnd_	 = 8'b0000_0000;		//null


	/*fnd_serial에 대응되는 문자 segment에 저장*/
	task set_segment;
		input [31:0] fnd_serial;		//출력해야하는 데이터
		output [47:0] segment_serial;	//출력 anode serial

		reg [31:0] data;				//데이터의 절댓값
		reg [7:0] segment [5:0];		//각 자리마다 출력되는 anode
		reg signBit;					//출력되는 데이터의 부호

		begin
			/*입력 데이터에 따른 출력 값 지정*/
			//특정 문자 출력인 경우 확인
			case (fnd_serial)
				//NULL
				'h00CC_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_;
					segment[3] <= fnd_;
					segment[2] <= fnd_;
					segment[1] <= fnd_;
					segment[0] <= fnd_;
				end
				//Error
				'h00EE_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_E;
					segment[3] <= fnd_r;
					segment[3] <= fnd_r;
					segment[1] <= fnd_o;
					segment[0] <= fnd_r;
				end
				//PLUS
				'h0030_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_p;
					segment[3] <= fnd_L;
					segment[2] <= fnd_u;
					segment[1] <= fnd_5;
					segment[0] <= fnd_;
				end
				//MINUS
				'h0040_0000 : begin
					segment[5] <= fnd_n;
					segment[4] <= fnd_n;
					segment[3] <= fnd_i;
					segment[2] <= fnd_n;
					segment[1] <= fnd_u;
					segment[0] <= fnd_5;
				end
				//MULTIPLE
				'h0010_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_;
					segment[3] <= fnd_n;
					segment[2] <= fnd_n;
					segment[1] <= fnd_u;
					segment[0] <= fnd_L;
				end
				//DIVID
				'h0020_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_0;
					segment[3] <= fnd_i;
					segment[2] <= fnd_v;
					segment[1] <= fnd_i;
					segment[0] <= fnd_0;
				end
				//MODULO
				'h0050_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_;
					segment[3] <= fnd_n;
					segment[2] <= fnd_n;
					segment[1] <= fnd_o;
					segment[0] <= fnd_D;
				end
				//HAPPY
				'h00A0_0000 : begin
					segment[5] <= fnd_H;
					segment[4] <= fnd_A;
					segment[3] <= fnd_p;
					segment[2] <= fnd_p;
					segment[1] <= fnd_y;
					segment[0] <= fnd_;
				end
				//ANS
				'h00B0_0000 : begin
					segment[5] <= fnd_;
					segment[4] <= fnd_;
					segment[3] <= fnd_;
					segment[2] <= fnd_A;
					segment[1] <= fnd_N;
					segment[0] <= fnd_5;
				end
				//-ANS
				'hE0B0_0000 : begin
					segment[5] <= fnd_h;
					segment[4] <= fnd_;
					segment[3] <= fnd_;
					segment[2] <= fnd_A;
					segment[1] <= fnd_N;
					segment[0] <= fnd_5;
				end
				//Negative
				'hE000_000 : begin
					segment[5] <= fnd_h;
					segment[4] <= fnd_;
					segment[3] <= fnd_;
					segment[2] <= fnd_;
					segment[1] <= fnd_;
					segment[0] <= fnd_0;
				end
				default : begin
					signBit = fnd_serial[31];			//부호 비트 추출
					if (signBit)						//음수일 때
						data = ~fnd_serial + 1;			//2의 보수
					else
						data = fnd_serial;


					case (data % 10)
						0 : segment[0] <= fnd_0;
						1 : segment[0] <= fnd_1;
						2 : segment[0] <= fnd_2;
						3 : segment[0] <= fnd_3;
						4 : segment[0] <= fnd_4;
						5 : segment[0] <= fnd_5;
						6 : segment[0] <= fnd_6;
						7 : segment[0] <= fnd_7;
						8 : segment[0] <= fnd_8;
						9 : segment[0] <= fnd_9;
					endcase
					if (!(data / 10))
						segment[1] <= fnd_;
					else begin
						case ((data / 10) % 10)
							0 : segment[1] <= fnd_0;
							1 : segment[1] <= fnd_1;
							2 : segment[1] <= fnd_2;
							3 : segment[1] <= fnd_3;
							4 : segment[1] <= fnd_4;
							5 : segment[1] <= fnd_5;
							6 : segment[1] <= fnd_6;
							7 : segment[1] <= fnd_7;
							8 : segment[1] <= fnd_8;
							9 : segment[1] <= fnd_9;
						endcase
					end
					if (!(data / 100))
						segment[2] <= fnd_;
					else begin
						case ((data / 100) % 10)
							0 : segment[2] <= fnd_0;
							1 : segment[2] <= fnd_1;
							2 : segment[2] <= fnd_2;
							3 : segment[2] <= fnd_3;
							4 : segment[2] <= fnd_4;
							5 : segment[2] <= fnd_5;
							6 : segment[2] <= fnd_6;
							7 : segment[2] <= fnd_7;
							8 : segment[2] <= fnd_8;
							9 : segment[2] <= fnd_9;
						endcase
					end
					if (!(data / 1000))
						segment[3] <= fnd_;
					else begin
						case ((data / 1000) % 10)
							0 : segment[3] <= fnd_0;
							1 : segment[3] <= fnd_1;
							2 : segment[3] <= fnd_2;
							3 : segment[3] <= fnd_3;
							4 : segment[3] <= fnd_4;
							5 : segment[3] <= fnd_5;
							6 : segment[3] <= fnd_6;
							7 : segment[3] <= fnd_7;
							8 : segment[3] <= fnd_8;
							9 : segment[3] <= fnd_9;
						endcase
					end
					if (!(data / 10000))
						segment[4] <= fnd_;
					else begin
						case ((data / 10000) % 10)
							0 : segment[4] <= fnd_0;
							1 : segment[4] <= fnd_1;
							2 : segment[4] <= fnd_2;
							3 : segment[4] <= fnd_3;
							4 : segment[4] <= fnd_4;
							5 : segment[4] <= fnd_5;
							6 : segment[4] <= fnd_6;
							7 : segment[4] <= fnd_7;
							8 : segment[4] <= fnd_8;
							9 : segment[4] <= fnd_9;
						endcase
					end
					if (signBit)							//음수일 때
						segment[5] <= fnd_h;				//부호 출력
					else begin
						if (!(data / 100000))
							segment[5] <= fnd_;
						else begin
							case ((data / 100000) % 10)
								0 : segment[5] <= fnd_0;
								1 : segment[5] <= fnd_1;
								2 : segment[5] <= fnd_2;
								3 : segment[5] <= fnd_3;
								4 : segment[5] <= fnd_4;
								5 : segment[5] <= fnd_5;
								6 : segment[5] <= fnd_6;
								7 : segment[5] <= fnd_7;
								8 : segment[5] <= fnd_8;
								9 : segment[5] <= fnd_9;
							endcase
						end
					end
				end
			endcase
			segment_serial <= {segment[5], segment[4], segment[3], segment[2], segment[1], segment[0]};
		end
	endtask


	always @(posedge fnd_clk, negedge rst) begin
		if (~rst) begin
			segment[0] <= fnd_h;
			segment[1] <= fnd_h;
			segment[2] <= fnd_h;
			segment[3] <= fnd_h;
			segment[4] <= fnd_h;
			segment[5] <= fnd_h;
		end else begin
			set_segment(fnd_serial, segment_serial);		//전달 받은 데이터 디코딩
			segment[0] <= segment_serial[7:0];
			segment[1] <= segment_serial[15:8];
			segment[2] <= segment_serial[23:16];
			segment[3] <= segment_serial[31:24];
			segment[4] <= segment_serial[39:32];
			segment[5] <= segment_serial[47:40];
		end

		fnd_cnt <= (fnd_cnt == 5) ? 0 : fnd_cnt + 1;		//fnd selector count
		fnd_d <= segment[fnd_cnt];						//해당 위치에 출력할 anode
		fnd_s <= ~(6'b00_0001 << fnd_cnt);				//segment 선택
	end

endmodule