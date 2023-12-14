module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	
	// input output.
	input clock_50m;			//보드 입력 clk
	input [15:0] pb;			//16bit key pad 입력
	output reg [3:0] fnd_s;		//segment select negative decoder
	output reg [7:0] fnd_d;		//segment anode  positive decoder

	wire sw_clk;					//2^(-21) 분주 
	wire fnd_clk;				//2^(-17) 분주
	wire [31:0]	fnd_serial;		//segment 출력 신호
	wire [3:0]	eBCD;			//extended BCD code 키패드 입력 데이터
	wire [31:0]	ans;			//연산 결과
	wire [31:0] operand1;		//피연산자1
	wire [31:0] operand2;		//피연산자2
	wire [2:0]	operator;		//연산자
	
	/*clock 분주*/
	clock_divider  CLK     (.clock_50m(clock_50m), .rst(rst),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));			
	/*segment 출력*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.nfnd_s(fnd_s), .fnd_d(fnd_d));
	/*keypad 입력*/
	keypad_driver  KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD));
	/*main 구동부*/
	interface      MAIN    (.sw_clk(sw_clk), .rst(rst), .eBCD(eBCD), .ans(ans),
							.operand1(operand1), .operand2(operand2), .operator(operator), .fnd_serial(fnd_serial));
	/*연산기+error detector*/
	calculate      CAL     (.sw_clk(sw_clk), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.result(ans));
	

endmodule

module clock_divider (clock_50m, rst, sw_clk, fnd_clk);
	input clock_50m;	//보드 입력 클럭
	input rst;			//리셋 버튼 입력(비동기)
	output sw_clk;		//sw 동작 clk
	output fnd_clk;		//segment 표시 주파수 clk

	reg [31:0] init_counter;	//50MHz counter
	reg sw_clk;					//2^(-21) 분주 
	reg fnd_clk;				//2^(-17) 분주


	// clock_50m. clock counter.
	always @(posedge clock_50m, negedge rst) begin
		if (~rst) begin
			init_counter <= 0;
			sw_clk <= 0;
			sw_clk <= 0;
		end else
			init_counter <= init_counter + 1;	//50MHz clock signal
	end

	/* clock divider
	* [31:0]init_counter 2^(-21) divid -> 50Mhz/(2^21)
	* init_counter의 20번째 bit는 clock_50m이 2^20주기마다 값이 바뀜
	* 따라서 sw_clk의 주파수는 50Mhz/(2^21) = 23.84Hz
	* 주기는 41.94ms
	* sw_clk = 23.84Hz
	*
	* 2^(-17) divide -> 50Mhz/(2^17) = 381.47Hz
	* 주기는 2.6214ms
	* fnd_clk = 381.47Hz
	*/
	always begin
		sw_clk <= init_counter[20];		// clock for keypad(switch)
		fnd_clk <= init_counter[16];	// clock for 7-segment
	end
	
endmodule


module segment_driver (fnd_clk, rst, fnd_serial, nfnd_s, fnd_d);
	input fnd_clk;
	input rst;
	input [31:0] fnd_serial;
	output reg [5:0] nfnd_s;	//segment select negative decoder 필요
	output reg [7:0] fnd_d;		//segment anode  positive decoder 

	integer i;
	reg [2:0] fnd_cnt;			//segment selector
	reg [7:0] segment [5:0]		//fnd 표시 위치별 데이터

	localparam fnd_0 = 8'b0011_1111;		//0
	localparam 1_fnd = 8'b0000_0110;		//1
	localparam 2_fnd = 8'b0101_1011;		//2
	localparam 3_fnd = 8'b0100_1111;		//3
	localparam 4_fnd = 8'b0110_0110;		//4
	localparam 5_fnd = 8'b0110_1101;		//5
	localparam 6_fnd = 8'b0111_1101;		//6
	localparam 7_fnd = 8'b0000_0111;		//7
	localparam 8_fnd = 8'b0111_1111;		//8
	localparam 9_fnd = 8'b0110_0111;		//9
	localparam t_fnd = 8'b0111_1000;		//t
	localparam p_fnd = 8'b0111_0011;		//P
	localparam A_fnd = 8'b0111_0111;		//A
	localparam b_fnd = 8'b0111_1100;		//b
	localparam c_fnd = 8'b0011_1001;		//C
	localparam d_fnd = 8'b0101_1110;		//d
	localparam E_fnd = 8'b0111_1001;		//E
	localparam r_fnd = 8'b0101_0000;		//r
	localparam __fnd = 8'b0100_0000;		//-
	localparam n_fnd	= 8'b0101_0100;		//n
	localparam X_fnd	= 8'b0000_0000;		//null



	always @(posedge fnd_clk, negedge rst) begin
		if (~rst) begin
			for (i = 0; i < 6; i = i + 1)
				segment[i] = X_fnd;
		end
	end

	always @(posedge fnd_clk) begin
		if (~(fnd_cnt < 6))
		fnd_cnt <= fnd_cnt + 1;
		case (fnd_cnt)
			3: begin
				fnd_d <= seg_1000;
				fnd_s <= 'b0111;
			end
		endcase
	end

endmodule

module interface (sw_clk, rst, eBCD, ans, operand1, operand2, operator, fnd_serial);
	input sw_clk;
	input rst;									//reset
	input [3:0]		eBCD;						//키패드 입력
	input		signed [31:0]	ans;			//연산 결과
	output	reg signed [31:0]	operand1;		//피연산자 2
	output	reg signed [31:0]	operand2;		//피연산자 1
	output	reg [2:0]			operator;		//연산자
	output	reg signed [31:0]	fnd_serial;		//segment 출력 데이터

	reg signBit;
	reg signed [30:0] buffer;

endmodule

module calculate (sw_clk, rst, operand1, operand2, operator, result);
	input sw_clk;
	input rst;								//reset
	input	signed 	[31:0]	operand1;		//피연산자 2
	input	signed 	[31:0]	operand2;		//피연산자 1
	input 			[2:0]	operator;		//연산자
	output	signed	[31:0]	result;			//연산 결과 출력

	reg signed	[63:0]	ans;				//연산 결과
endmodule