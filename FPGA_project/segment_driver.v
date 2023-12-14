module segment_driver (fnd_clk, fnd_serial, fnd_s, fnd_d);
	input fnd_clk;				//fnd clock
	input [31:0] fnd_serial;	//출력해야하는 데이터
	output reg [5:0] fnd_s;	//segment select negative decoder 필요
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

		reg [7:0] segment [5:0];		//각 자리마다 출력되는 anode
		reg signBit;					//출력되는 데이터의 부호
		reg [31:0] data;				//fnd_serial 저장해 놓을 레지스터
		reg [3:0]  temp;				//임시 변수
		reg [2:0]  i;				//for loop 제어 변수

		begin
			/*입력 데이터에 따른 출력 값 지정*/
			//특정 문자 출력인 경우 확인
			case (fnd_serial)
				//Error
				'h00EE_0000 : begin
					segment[0] <= fnd_;
					segment[1] <= fnd_E;
					segment[2] <= fnd_r;
					segment[3] <= fnd_r;
					segment[4] <= fnd_o;
					segment[5] <= fnd_r;
				end
				//PLUS
				'h0010_0000 : begin
					segment[0] <= fnd_;
					segment[1] <= fnd_p;
					segment[2] <= fnd_L;
					segment[3] <= fnd_u;
					segment[4] <= fnd_5;
					segment[5] <= fnd_;
				end
				//MINUS
				'h0020_0000 : begin
					segment[0] <= fnd_n;
					segment[1] <= fnd_n;
					segment[2] <= fnd_i;
					segment[3] <= fnd_n;
					segment[4] <= fnd_u;
					segment[5] <= fnd_5;
				end
				//MULTIPLE
				'h0030_0000 : begin
					segment[0] <= fnd_;
					segment[1] <= fnd_;
					segment[2] <= fnd_n;
					segment[3] <= fnd_n;
					segment[4] <= fnd_u;
					segment[5] <= fnd_L;
				end
				//DIVID
				'h0040_0000 : begin
					segment[0] <= fnd_;
					segment[1] <= fnd_0;
					segment[2] <= fnd_i;
					segment[3] <= fnd_v;
					segment[4] <= fnd_i;
					segment[5] <= fnd_0;
				end
				//MODULO
				'h0050_0000 : begin
					segment[0] <= fnd_;
					segment[1] <= fnd_;
					segment[2] <= fnd_n;
					segment[3] <= fnd_n;
					segment[4] <= fnd_o;
					segment[5] <= fnd_D;
				end
				//HAPPY
				'h00A0_0000 : begin
					segment[0] <= fnd_H;
					segment[1] <= fnd_A;
					segment[2] <= fnd_p;
					segment[3] <= fnd_p;
					segment[4] <= fnd_y;
					segment[5] <= fnd_;
				end
				default : begin
					signBit <= fnd_serial[31];			//부호 비트 추출
					if (signBit)						//음수일 때
						data <= ~fnd_serial + 1;		//2의 보수
					for (i = 0; i < 6; i = i + 1) begin
						temp <=  data % 10;	//자릿 수 추출
						data <= data / 10;			//10진수 오른쪽 shift
						if (~|data && !temp)		//data == 0일 때 loop 탈출
							break;
						case (temp)			//10진수에 맞는 anode 저장
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
			endcase
			segment_serial <= {segment[5], segment[4], segment[3], segment[2], segment[1], segment[0]};
		end
	endtask

	always @(posedge fnd_clk) begin
		fnd_cnt <= fnd_cnt + 1;
		if (fnd_cnt == 6)
			fnd_cnt <= 6;
		set_segment(fnd_serial, segment_serial);		//전달 받은 데이터 디코딩
		segment[0] <= segment_serial[7:0];
		segment[1] <= segment_serial[15:8];
		segment[2] <= segment_serial[23:16];
		segment[3] <= segment_serial[31:24];
		segment[4] <= segment_serial[39:32];
		segment[5] <= segment_serial[47:40];
		fnd_d <= segment[fnd_cnt];									//해당 위치에 출력할 anode
		fnd_s <= ~(6'b00_0001 << fnd_cnt);							//segment 선택
	end


endmodule