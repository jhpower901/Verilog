module keypad_driver (sw_clk, pb, eBCD, rst);
	input sw_clk;
	input [15:0] pb;
	output reg [4:0] eBCD;
	output rst;

	reg [15:0] pb_1st;			//key pad �Է� ���� ����
	reg [15:0] pb_2nd;			//key pad �Է� ���� ����
	reg sw_toggle;				//�Է� ���

	assign rst = pb[12];

	always @(posedge sw_clk, negedge rst) begin
		if (~rst) begin
			pb_2nd <= 'h0000;
			pb_1st <= 'h0000;
			sw_toggle <= 0;
			eBCD <= 'h00;
		end else begin
			pb_2nd <= pb_1st;		//���� �Է� ����
			pb_1st <= ~pb;			//���� key pad �Է� ���� ��
			
			if (pb_2nd == 'h0000 && pb_1st != pb_2nd) begin
				//���� �Է��� ����(�߿�!), ���� �Է°� ���� �Է��� �ٸ���
				//�Է��� ���� ������ �� �Է� ���
				//�ϳ��� Ű�� ���� ���¿��� �Ǵٸ� Ű�� ������ ��� �Է� ����
				sw_toggle <= 1;
			end
			
			if (sw_toggle == 1 && pb_1st == pb_2nd) begin
				//�Է� ����̰�, ���� �Է°� ���� �Է��� ���� ��
				//Ű�� ��� ���� �ִ� ���·� ����
				//�Է� ��� ����.
				sw_toggle <= 0;
				/*
				* eBCD code mapping
				* �� �� 1bit�� �Է� enable��
				* 0 1 2 3 4 5 6 7 8 9 a  b c  d  e   f
				* 0 1 2 3 4 5 6 7 8 9 /% * +- AC ans =
				*/
				case (pb_1st)
					'h0001: /*1*/begin
						eBCD <= 5'h11;
					end
					'h0002: /*2*/begin
						eBCD <= 5'h12;
					end
					'h0004: /*3*/begin
						eBCD <= 5'h13;
					end
					'h0008: /*/%*/begin
						eBCD <= 5'h1a;
					end
					'h0010: /*4*/begin
						eBCD <= 5'h14;
					end
					'h0020: /*5*/begin
						eBCD <= 5'h15;
					end
					'h0040: /*6*/begin
						eBCD <= 5'h16;
					end
					'h0080: /***/begin
						eBCD <= 5'h1b;
					end
					'h0100: /*7*/begin
						eBCD <= 5'h17;
					end
					'h0200: /*8*/begin
						eBCD <= 5'h18;
					end
					'h0400: /*9*/begin
						eBCD <= 5'h19;
					end
					'h0800: /*+-*/begin
						eBCD <= 5'h1c;
					end
					'h1000: /*AC*/begin
						eBCD <= 5'h1d;
					end
					'h2000: /*0*/begin
						eBCD <= 5'h10;
					end
					'h4000: /*ans*/begin
						eBCD <= 5'h1e;
					end
					'h8000: /*=*/begin
						eBCD <= 5'h1f;
					end
				endcase
			end else begin
				eBCD <= 5'h00;				//�Է��� ���� ����
			end
		end
	end
endmodule