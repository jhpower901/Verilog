module switch_segment(clock_50m, pb, fnd_s, fnd_d);
	
	// input output.
	input clock_50m;
	input [15:0] pb;
	output reg [3:0] fnd_s;
	output reg [7:0] fnd_d;
	
	// clock.
	reg [15:0] npb;
	reg [31:0] init_counter;
	reg sw_clk;
	reg fnd_clk;
	reg [1:0] fnd_cnt;
	
	// 7-segment.
	reg [4:0] set_no1;
	reg [4:0] set_no2;
	reg [4:0] set_no3;
	reg [4:0] set_no4;
	reg [6:0] seg_1000;
	reg [6:0] seg_100;
	reg [6:0] seg_10;
	reg [6:0] seg_1;
	
	// pass check.
	reg [4:0] save_no1;
	reg [4:0] save_no2;
	reg [4:0] save_no3;
	reg [4:0] save_no4;
	reg pass_ok;
	
	// switch(keypad) control.
	reg [15:0] pb_1st;
	reg [15:0] pb_2nd;
	reg sw_toggle;
	
	// sw_status.
	reg [2:0] sw_status;
	parameter sw_idle = 0;
	parameter sw_start = 1;
	parameter sw_s1 = 2;
	parameter sw_s2 = 3;
	parameter sw_s3 = 4;
	parameter sw_s4 = 5;
	// parameter sw_save = 6;
	// parameter sw_cancel = 7;
	
	// initial.
	initial begin
		sw_status <= sw_idle;
		sw_toggle <= 0;
		npb <= 'h0000;
		pb_1st <= 'h0000;
		pb_2nd <= 'h0000;
		set_no1 <= 18;
		set_no2 <= 18;
		set_no3 <= 18;
		set_no4 <= 18;
		save_no1 <= 2;
		save_no2 <= 5;
		save_no3 <= 8;
		save_no4 <= 0;
		pass_ok <= 1;
	end
	
	// input. clock divider.
	always begin
		npb <= ~pb;						// input
		sw_clk <= init_counter[20];		// clock for keypad(switch)
		fnd_clk <= init_counter[16];	// clock for 7-segment
	end
	
	// clock_50m. clock counter.
	always @(posedge clock_50m) begin
		init_counter <= init_counter + 1;
	end
	
	// sw_clk. get two consecutive inputs to correct switch(keypad) error.
	always @(posedge sw_clk) begin
		pb_2nd <= pb_1st;
		pb_1st <= npb;
		
		if (pb_2nd == 'h0000 && pb_1st != pb_2nd) begin
			sw_toggle <= 1;
		end
		
		if (sw_toggle == 1 && pb_1st == pb_2nd) begin
			sw_toggle <= 0;
			
			case (pb_1st)
			
				'h0001: begin
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
				'h0002: begin
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
				'h0004: begin
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
				'h0008: begin
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
				'h0010: begin
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
				'h0020: begin
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
				'h0040: begin
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
				'h0080: begin
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
				'h0100: begin
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
				'h0200: begin
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
				'h0400: begin
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
				'h0800: begin
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
							if (set_no1 == save_no1 && set_no2 == save_no2 && set_no3 == save_no3 && set_no4 == save_no4) begin
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
				'h2000: begin
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
				'h4000: begin
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
				'h8000: begin
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
			0: seg_1000 <= 'b0011_1111;
			1: seg_1000 <= 'b0000_0110;
			2: seg_1000 <= 'b0101_1011;
			3: seg_1000 <= 'b0100_1111;
			4: seg_1000 <= 'b0110_0110;
			5: seg_1000 <= 'b0110_1101;
			6: seg_1000 <= 'b0111_1101;
			7: seg_1000 <= 'b0000_0111;
			8: seg_1000 <= 'b0111_1111;
			9: seg_1000 <= 'b0110_0111;
			10: seg_1000 <= 'b0111_1000;
			11: seg_1000 <= 'b0111_0011;
			12: seg_1000 <= 'b0111_0111;
			13: seg_1000 <= 'b0111_1100;
			14: seg_1000 <= 'b0011_1001;
			15: seg_1000 <= 'b0101_1110;
			16: seg_1000 <= 'b0111_1001;
			17: seg_1000 <= 'b0101_0000;
			18: seg_1000 <= 'b0100_0000;
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
