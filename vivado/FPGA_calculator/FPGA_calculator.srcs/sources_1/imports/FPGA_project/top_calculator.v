module top_calculator(clock_50m, pb, fnd_s, fnd_d);
	/*Board input*/
	input clock_50m;		//���� �Է� 50MHz-clk
	input [15:0] pb;		//16bit key pad �Է�
	/*segment_driver*/
	output [5:0] fnd_s;		//segment select negative decoder
	output [7:0] fnd_d;		//segment anode  positive decoder


	/*clock_divider*/
	wire sw_clk;				//2^(-21) ���� 
	wire fnd_clk;				//2^(-17) ����

	/*keypad_driver*/
	wire [4:0]	eBCD;			//extended BCD code Ű�е� �Է� ������
	wire rst;					//reset

	/*calculate*/
	wire [31:0]	ans;			//���� ���

	/*interface*/
	wire [31:0]	operand1;		//�ǿ�����
	wire [31:0]	operand2;		//�ǿ�����
	wire [2:0]	operator;		//������
	wire		cal_enable;		//����� enable
	wire [31:0]	fnd_serial;		//segment ��� ������


	/*clock ����*/
	clock_divider	CLK     (.clock_50m(clock_50m),
							.sw_clk(sw_clk), .fnd_clk(fnd_clk));	
	/*segment ���*/
	segment_driver SDI     (.fnd_clk(fnd_clk), .rst(rst), .fnd_serial(fnd_serial),
							.fnd_s(fnd_s), .fnd_d(fnd_d));
	/*keypad �Է�*/
	keypad_driver	KDI     (.sw_clk(sw_clk), .pb(pb),
							.eBCD(eBCD), .rst(rst));
	/*�����+error detector*/

	calculate		CAL     (.enable(cal_enable), .rst(rst), .operand1(operand1), .operand2(operand2), .operator(operator),
							.ans(ans));
	/*interface*/
	interface		UI		(.sw_clk(sw_clk), .rst(rst), .eBCD(eBCD), .ans(ans),
							.operand1(operand1), .operand2(operand2), .operator(operator), .cal_enable(cal_enable), .fnd_serial(fnd_serial));

endmodule