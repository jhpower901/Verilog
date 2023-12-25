/*
	가장 먼저 눌린 키 값을 1clk width 동안 출력.
	계속 누르고 있어도 1 clk width 동안만 신호가 출력됨.
	posedge sw_clk 부터 다음 posedge까지 1주기 동안 출력 유지
	negedge에서 keypad 값 읽어와 이용.
	읽어들인 값 buffer에 저장
*/


module keypad_driver (sw_clk, pb, mode, eBCD, rst);
	input sw_clk;				//clock 신호
	input [15:0] pb;			//pull-pu 되어있는 스위치 벡터
	input mode;					//버퍼 읽기 모드
	output reg [4:0] eBCD;		//키 입력에 대응되는 출력 코드
	output rst;					//비동기 reset

	reg [15:0] pb_1st;			//key pad 입력 현재 상태
	reg [15:0] pb_2nd;			//key pad 입력 이전 상태
	reg sw_toggle;				//입력 모드

	reg [4:0]	temp;			//버퍼에 저장될 입력 데이터
	reg [34:0]	buffer = 0;			//버퍼
	reg [2:0]	cnt_buffer = 0;		//버퍼에 저장된 데이터 수 카운터

	assign rst = pb[12];		//비동기 reset

	always @(posedge sw_clk, negedge rst, posedge mode) begin
		if (~rst) begin
			pb_2nd <= 16'h0000;
			pb_1st <= 16'h0000;
			sw_toggle <= 0;
			temp <= 5'h00;
			buffer <= 35'b0;
			cnt_buffer <= 3'b000;
		end 
		else if (mode) begin
			buffer		= buffer >> 5;		//buffer에서 문자 삭제
			cnt_buffer	= cnt_buffer ? cnt_buffer - 1 : cnt_buffer;	//buffer에서 문자 삭제
			eBCD		= buffer[4:0];		//FIFO 출력
		end
		else begin
			pb_2nd <= pb_1st;		//이전 입력 저장
			pb_1st <= ~pb;			//현재 key pad 입력 반전 값
			
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
				/*
				* eBCD code mapping
				* 맨 앞 1bit는 입력 enable임
				* 0 1 2 3 4 5 6 7 8 9 a  b c  d  e   f
				* 0 1 2 3 4 5 6 7 8 9 /% * +- AC ans =
				*/
				case (pb_1st)
					'h0001:	temp = 5'h11;		//1
					'h0002: temp = 5'h12;		//2
					'h0004: temp = 5'h13;		//3
					'h0008: temp = 5'h1a;		// /,%
					'h0010: temp = 5'h14;		//4
					'h0020: temp = 5'h15;		//5
					'h0040: temp = 5'h16;		//6
					'h0080: temp = 5'h1b;		//*
					'h0100: temp = 5'h17;		//7
					'h0200: temp = 5'h18;		//8
					'h0400: temp = 5'h19;		//9
					'h0800: temp = 5'h1c;		//+-
					//'h1000: temp = 5'h1d;	//AC 'h1000는 비동기 rst 신호임
					'h2000: temp = 5'h10;		//0
					'h4000: temp = 5'h1e;		//ans
					'h8000: temp = 5'h1f;		//=
					default:temp = 5'h00;		//입력이 없는 상태
				endcase
				if (temp[4]) begin
					buffer = buffer + ({30'h00_0000, temp} << (5 * cnt_buffer));		//버퍼에 문자 저장
					cnt_buffer = cnt_buffer + 1;						//버퍼에 입력된 문자 수
					eBCD = buffer[4:0];		//FIFO 출력
				end
				else begin
					eBCD = buffer[4:0];		//FIFO 출력
				end
			end
		end
	end
endmodule