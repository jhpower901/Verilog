module switch_segment(clock_50m, pb, fnd_s, fnd_d);
	
	// input output.
	input clock_50m;			//보드 제공 clk
	input [15:0] pb;			//16bit key pad 입력
	output reg [3:0] fnd_s;		//segment select
	output reg [7:0] fnd_d;		//segment anode
	
	// clock.
	reg [15:0] npb;
	reg [31:0] init_counter;	//50MHz counter
	reg sw_clk;					//2^(-21) 분주 
	reg fnd_clk;				//2^(-17) 분주
	reg [1:0] fnd_cnt;			//segment selector
								//4자리를 번갈아 출력하기 위해 fnd_clk counter
	
	// 7-segment.
	reg [4:0] set_no1;			//segment display char1
	reg [4:0] set_no2;			//char2
	reg [4:0] set_no3;			//char3
	reg [4:0] set_no4;			//char4
	reg [6:0] seg_1000;			//segment cathode corresponding to char1
	reg [6:0] seg_100;			//corresponding to char2
	reg [6:0] seg_10;			//corresponding to char3
	reg [6:0] seg_1;			//corresponding to char4
	
	// pass check.
	reg [4:0] save_no1;			//password parameter
	reg [4:0] save_no2;
	reg [4:0] save_no3;
	reg [4:0] save_no4;
	reg pass_ok;				//password correct
	
	// switch(keypad) control.
	reg [15:0] pb_1st;		//key pad 입력 현재 상태
	reg [15:0] pb_2nd;		//key pad 입력 이전 상태
	reg sw_toggle;			//입력 모드
	
	// sw_status.
	reg [2:0] sw_status;
	parameter sw_idle = 0;		//대기 상태
	parameter sw_start = 1;		//idle 상태에서 'h1000 입력되었을 때 (enter)
	parameter sw_s1 = 2;		//첫번째 문자 출력 완료
	parameter sw_s2 = 3;		//두번째 문자 출력 완료
	parameter sw_s3 = 4;		//세번째 문자 출력 완료
	parameter sw_s4 = 5;		//네번째 문자 출력 완료
	// parameter sw_save = 6;
	// parameter sw_cancel = 7;
	
	// initial.
	initial begin
		sw_status <= sw_idle;	//sw_status 초기 설정 : idle 상태
		sw_toggle <= 0;
		npb <= 'h0000;		//imverted key in
		pb_1st <= 'h0000;	//switch control???
		pb_2nd <= 'h0000;
		set_no1 <= 18;		//set segment display character '-'
		set_no2 <= 18;
		set_no3 <= 18;
		set_no4 <= 18;
		save_no1 <= 2;		//set password
		save_no2 <= 5;
		save_no3 <= 8;
		save_no4 <= 0;
		pass_ok <= 1;
	end
	
	// input. clock divider.
	always begin
		/* 입력값을 반전시켜 저장
		 * 입력 스위치가 pull-up 되어있는 듯.
		 * 반전했을 때 하나의 bit만 H상태
		 * key 입력에 대해 encoding 필요
		 * 한번에 여러개의 키가 눌렸을 경우 처리 필요.
		 */
		npb <= ~pb;
		/* [31:0]init_counter 2^(-21) divid -> 50Mhz/(2^21)
		 * init_counter의 20번째 bit는 clock_50m이 2^20주기마다 값이 바뀜
		 * 따라서 sw_clk의 주파수는 50Mhz/(2^21) = 23.84Hz
		 * 주기는 41.94ms
		 * sw_clk = 23.84Hz
		 */
		sw_clk <= init_counter[20];		// clock for keypad(switch)
		/* 2^(-17) divide -> 50Mhz/(2^17) = 381.47Hz
		 * 주기는 2.6214ms
		 * fnd_clk = 381.47Hz
		 */
		fnd_clk <= init_counter[16];	// clock for 7-segment
	end
	
	// clock_50m. clock counter.
	always @(posedge clock_50m) begin
		//50MHz clock signal
		init_counter <= init_counter + 1;
	end
	
	// sw_clk = 23.84Hz. get two consecutive inputs to correct switch(keypad) error.
	always @(posedge sw_clk) begin
		pb_2nd <= pb_1st;		//이전 입력 저장
		pb_1st <= npb;			//현재 key pad 입력 반전 값
		
		if (pb_2nd == 'h0000 && pb_1st != pb_2nd) begin
			//이전 입력이 없고(중요!), 이전 입력과 현재 입력이 다를때
			//입력이 새로 들어왔을 때 입력 모드
			//하나의 키가 눌린 상태에서 또다른 키가 눌렸을 경우 입력 무시
			sw_toggle <= 1;
		end
		
		if (sw_toggle == 1 && pb_1st == pb_2nd) begin
			//입력 모드이고, 이전 입력과 현재 입력이 같을 때
			//키가 계속 눌려 있는 상태로 생각
			//입력 토글 끈다.
			sw_toggle <= 0;
			
			case (pb_1st)
			
				'h0001: /*1*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 1;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 1;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 1;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 1;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0002: /*2*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 2;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 2;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 2;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 2;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0004: /*3*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 3;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 3;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 3;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 3;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0008: /*A*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 12;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 12;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 12;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 12;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0010: /*4*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 4;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 4;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 4;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 4;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0020: /*5*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 5;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 5;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 5;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 5;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0040: /*6*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 6;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 6;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 6;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 6;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0080: /*b*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 13;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 13;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 13;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 13;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0100: /*7*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 7;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 7;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 7;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 7;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0200: /*8*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 8;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 8;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 8;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 8;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0400: /*9*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 9;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 9;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 9;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 9;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h0800: /*c*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 14;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 14;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 14;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 14;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h1000: begin	// enter
					case (sw_status)
						sw_idle: begin
							sw_status <= sw_start;
							set_no1 <= 18;
							set_no2 <= 18;
							set_no3 <= 18;
							set_no4 <= 18;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							if (set_no1 == save_no1 && set_no2 == save_no2
								&& set_no3 == save_no3 && set_no4 == save_no4) begin
								set_no1 <= 0;
								set_no2 <= 11;
								set_no3 <= 16;
								set_no4 <= 19;
								pass_ok <= 1;
							end
							else begin
								set_no1 <= 16;
								set_no2 <= 17;
								set_no3 <= 17;
								set_no4 <= 20;
								pass_ok <= 0;
							end
						end
						default: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h2000: /*0*/begin
					case (sw_status)
						sw_idle: begin
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 0;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 0;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 0;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h4000: /*P*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 11;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 11;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 11;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 11;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
				'h8000: /*d*/begin
					case (sw_status)
						sw_idle: begin
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
						sw_start: begin
							sw_status <= sw_s1;
							set_no1 <= 15;
							pass_ok <= 0;
						end
						sw_s1: begin
							sw_status <= sw_s2;
							set_no2 <= 15;
							pass_ok <= 0;
						end
						sw_s2: begin
							sw_status <= sw_s3;
							set_no3 <= 15;
							pass_ok <= 0;
						end
						sw_s3: begin
							sw_status <= sw_s4;
							set_no4 <= 15;
							pass_ok <= 0;
						end
						sw_s4: begin
							sw_status <= sw_idle;
							set_no1 <= 16;
							set_no2 <= 17;
							set_no3 <= 17;
							set_no4 <= 20;
							pass_ok <= 0;
						end
					endcase
				end
			endcase
		end
	end
	
	// 7-segment.
	always @(set_no1) begin
		case (set_no1)
			0: seg_1000 <= 'b0011_1111;			//0
			1: seg_1000 <= 'b0000_0110;			//1
			2: seg_1000 <= 'b0101_1011;			//2
			3: seg_1000 <= 'b0100_1111;			//3
			4: seg_1000 <= 'b0110_0110;			//4
			5: seg_1000 <= 'b0110_1101;			//5
			6: seg_1000 <= 'b0111_1101;			//6
			7: seg_1000 <= 'b0000_0111;			//7
			8: seg_1000 <= 'b0111_1111;			//8
			9: seg_1000 <= 'b0110_0111;			//9
			10: seg_1000 <= 'b0111_1000;		//t
			11: seg_1000 <= 'b0111_0011;		//P
			12: seg_1000 <= 'b0111_0111;		//A
			13: seg_1000 <= 'b0111_1100;		//b
			14: seg_1000 <= 'b0011_1001;		//C
			15: seg_1000 <= 'b0101_1110;		//d
			16: seg_1000 <= 'b0111_1001;		//E
			17: seg_1000 <= 'b0101_0000;		//r
			18: seg_1000 <= 'b0100_0000;		//-
			19: seg_1000 <= 'b0101_0100;
			default: seg_1000 <= 'b0000_0000;
		endcase
	end
	always @(set_no2) begin
		case (set_no2)
			0: seg_100 <= 'b0011_1111;
			1: seg_100 <= 'b0000_0110;
			2: seg_100 <= 'b0101_1011;
			3: seg_100 <= 'b0100_1111;
			4: seg_100 <= 'b0110_0110;
			5: seg_100 <= 'b0110_1101;
			6: seg_100 <= 'b0111_1101;
			7: seg_100 <= 'b0000_0111;
			8: seg_100 <= 'b0111_1111;
			9: seg_100 <= 'b0110_0111;
			10: seg_100 <= 'b0111_1000;
			11: seg_100 <= 'b0111_0011;
			12: seg_100 <= 'b0111_0111;
			13: seg_100 <= 'b0111_1100;
			14: seg_100 <= 'b0011_1001;
			15: seg_100 <= 'b0101_1110;
			16: seg_100 <= 'b0111_1001;
			17: seg_100 <= 'b0101_0000;
			18: seg_100 <= 'b0100_0000;
			19: seg_100 <= 'b0101_0100;
			default: seg_100 <= 'b0000_0000;
		endcase
	end
	always @(set_no3) begin
		case (set_no3)
			0: seg_10 <= 'b0011_1111;
			1: seg_10 <= 'b0000_0110;
			2: seg_10 <= 'b0101_1011;
			3: seg_10 <= 'b0100_1111;
			4: seg_10 <= 'b0110_0110;
			5: seg_10 <= 'b0110_1101;
			6: seg_10 <= 'b0111_1101;
			7: seg_10 <= 'b0000_0111;
			8: seg_10 <= 'b0111_1111;
			9: seg_10 <= 'b0110_0111;
			10: seg_10 <= 'b0111_1000;
			11: seg_10 <= 'b0111_0011;
			12: seg_10 <= 'b0111_0111;
			13: seg_10 <= 'b0111_1100;
			14: seg_10 <= 'b0011_1001;
			15: seg_10 <= 'b0101_1110;
			16: seg_10 <= 'b0111_1001;
			17: seg_10 <= 'b0101_0000;
			18: seg_10 <= 'b0100_0000;
			19: seg_10 <= 'b0101_0100;
			default: seg_10 <= 'b0000_0000;
		endcase
	end
	always @(set_no4) begin
		case (set_no4)
			0: seg_1 <= 'b0011_1111;
			1: seg_1 <= 'b0000_0110;
			2: seg_1 <= 'b0101_1011;
			3: seg_1 <= 'b0100_1111;
			4: seg_1 <= 'b0110_0110;
			5: seg_1 <= 'b0110_1101;
			6: seg_1 <= 'b0111_1101;
			7: seg_1 <= 'b0000_0111;
			8: seg_1 <= 'b0111_1111;
			9: seg_1 <= 'b0110_0111;
			10: seg_1 <= 'b0111_1000;
			11: seg_1 <= 'b0111_0011;
			12: seg_1 <= 'b0111_0111;
			13: seg_1 <= 'b0111_1100;
			14: seg_1 <= 'b0011_1001;
			15: seg_1 <= 'b0101_1110;
			16: seg_1 <= 'b0111_1001;
			17: seg_1 <= 'b0101_0000;
			18: seg_1 <= 'b0100_0000;
			19: seg_1 <= 'b0101_0100;
			default: seg_1 <= 'b0000_0000;
		endcase
	end
	
	// fnd_clk. output.
	always @(posedge fnd_clk) begin
		fnd_cnt <= fnd_cnt + 1;
		case (fnd_cnt)
			3: begin
				fnd_d <= seg_1000;
				fnd_s <= 'b0111;
			end
			2: begin
				fnd_d <= seg_100;
				fnd_s <= 'b1011;
			end
			1: begin
				fnd_d <= seg_10;
				fnd_s <= 'b1101;
			end
			0: begin
				fnd_d <= seg_1;
				fnd_s <= 'b1110;
			end
		endcase
	end
	
endmodule
