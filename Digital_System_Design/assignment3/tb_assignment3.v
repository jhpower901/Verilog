`timescale 1ns/1ns
module tb_assignment3;
reg CLK;               //clock
reg RST;               //active high reset signal
reg [2:0] ABC_input;   //ABC state input {C, B, A}
wire  [2:0] WINNER_DISP; //winner display {C, B, A}
wire  A_DISP, B_DISP, C_DISP; //A, B, C state indicater

//generate clock (DSD_5_SeqLogicIntro, p.22)
initial begin
    CLK = 1'b1;
    ABC_input = 3'b000;
    $monitor ($time, "{%b, %b, %b} -> %b(%b%b%b)", 
                ABC_input[2], ABC_input[1], ABC_input[0],
                WINNER_DISP, C_DISP, B_DISP, A_DISP);
end
always #5 CLK = ~CLK;

//test case
initial begin
    RST = 1'b1; #15; RST = 1'b0; #5;

    //case study 1
    ABC_input = 3'b000; #10;
    ABC_input = 3'b001; #10;
    ABC_input = 3'b100; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case study 2
    ABC_input = 3'b001; #10;
    ABC_input = 3'b110; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case study 3
    ABC_input = 3'b000; #10;
    ABC_input = 3'b111; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 A-B
    ABC_input = 3'b001; #10;
    ABC_input = 3'b010; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 A-C
    ABC_input = 3'b001; #10;
    ABC_input = 3'b100; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 B-A
    ABC_input = 3'b010; #10;
    ABC_input = 3'b001; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 B-C
    ABC_input = 3'b010; #10;
    ABC_input = 3'b100; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 C-A
    ABC_input = 3'b100; #10;
    ABC_input = 3'b001; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-1 C-B
    ABC_input = 3'b100; #10;
    ABC_input = 3'b010; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-2 A
    ABC_input = 3'b001; #10;
    ABC_input = 3'b110; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-2 B
    ABC_input = 3'b010; #10;
    ABC_input = 3'b101; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 1-2 C
    ABC_input = 3'b100; #10;
    ABC_input = 3'b011; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 2-1 A
    ABC_input = 3'b110; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 2-1 B
    ABC_input = 3'b101; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;

    //case: 2-1 C
    ABC_input = 3'b011; #10;
    #10; RST = 1'b1; #15; RST = 1'b0; #5;
    

    $stop;
end

hunch_fsm DUT (.CLK(CLK), .RST(RST), .A(ABC_input[0]), .B(ABC_input[1]), .C(ABC_input[2]),
               .WINNER_DISP(WINNER_DISP), .A_DISP(A_DISP), .B_DISP(B_DISP), .C_DISP(C_DISP));
endmodule