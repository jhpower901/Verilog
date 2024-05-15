module tb_assignment3;
wire CLK;               //clock
wire RST;               //active high reset signal
wire [2:0] ABC_input;   //ABC state input
reg  [2:0] WINNER_DISP; //winner display {C, B, A}
reg  A_DISP, B_DISP, C_DISP //A, B, C state indicater

//generate clock (DSD_5_SeqLogicIntro, p.22)
inital CLK = 0;
always #5 CLK = ~CLK;




endmodule