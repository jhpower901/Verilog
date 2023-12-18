module clock_divider (clock_50m, sw_clk, fnd_clk);
	/* clock divider
	* [31:0]init_counter 2^(-21) divid -> 50Mhz/(2^21)
	* init_counter�� 20��° bit�� clock_50m�� 2^20�ֱ⸶�� ���� �ٲ�
	* ���� sw_clk�� ���ļ��� 50Mhz/(2^21) = 23.84Hz
	* �ֱ�� 41.94ms
	* sw_clk = 23.84Hz
	*
	* 2^(-17) divide -> 50Mhz/(2^17) = 381.47Hz
	* �ֱ�� 2.6214ms
	* fnd_clk = 381.47Hz
	*/
	input clock_50m;	//���� �Է� Ŭ��
	output sw_clk;		//sw ���� clk
	output fnd_clk;		//segment ǥ�� ���ļ� clk

	reg [31:0] init_counter = 0;	//50MHz counter
	reg sw_clk;					//2^(-21) ���� 
	reg fnd_clk;				//2^(-17) ����


	// clock_50m. clock counter.
	always @(posedge clock_50m) begin
		init_counter <= init_counter + 1;	//50MHz clock signal
		/*���� 50MHz ���� �ڵ�*/
		sw_clk <= init_counter[20];			// clock for keypad(switch)
		fnd_clk <= init_counter[16];		// clock for 7-segment
		/*testbench�� �ڵ�*/
		// sw_clk <= init_counter[5];		// clock for keypad(switch)
		// fnd_clk <= init_counter[1];		// clock for 7-segment
	end
	
endmodule