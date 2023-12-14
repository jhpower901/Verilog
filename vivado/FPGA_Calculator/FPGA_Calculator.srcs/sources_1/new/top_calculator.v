`timescale 1ns / 1ns

module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	
	// input output.
	input clock_50m;			//보드 입력 clk
	input [15:0] pb;			//16bit key pad 입력
	output reg [3:0] fnd_s;		//segment select negative decoder
	output reg [7:0] fnd_d;		//segment anode  positive decoder 
	
	clock_divider  CLK     (); //clock 분주
	segment_driver SDI     (); //segment 출력
	keypad_driver  KDI     (); //keypad 입력
	interface      MAIN    (); //main 구동부
	calculate      CAL     (); //연산기+error detector
	




endmodule
