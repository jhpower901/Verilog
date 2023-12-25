module clock_divider (clock_50m, sw_clk, fnd_clk);
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
	input clock_50m;	//보드 입력 클럭
	output sw_clk;		//sw 동작 clk
	output fnd_clk;		//segment 표시 주파수 clk

	reg [31:0] init_counter = 0;	//50MHz counter
	reg sw_clk;					//2^(-21) 분주 
	reg fnd_clk;				//2^(-17) 분주


	// clock_50m. clock counter.
	always @(posedge clock_50m) begin
		init_counter <= init_counter + 1;	//50MHz clock signal
		/*실제 50MHz 동작 코드*/
		sw_clk <= init_counter[20];			// clock for keypad(switch)
		fnd_clk <= init_counter[16];		// clock for 7-segment
		/*testbench용 코드*/
		//sw_clk <= init_counter[5];		// clock for keypad(switch)
		//fnd_clk <= init_counter[1];		// clock for 7-segment
	end
	
endmodule