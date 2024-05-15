// 2024 Spring Digital System Desing
// assignment3 : FSM-HunchGame
// Due date : 2024.05.24.
// 전자공학과 20 안재형

/**
 * A, B, C의 상태를 확인하여 눈치게임 승자(WINNER_DISP)와 A, B, C의 상태(*_DISP)를 출력한다.
 *
 * @input CLK   clock signal
 * @input RST   active high reset signal
 * @input A, B, C input status
 * @output WINNER_DISP  display winner
 * @*_DISP indicate whether A/B/C is standing or not
 */
module hunch_fsm(
    input CLK, RST,
    input A, B, C,
    output reg  [2:0]   WINNER_DISP
    output reg          A_DISP, B_DISP, C_DISP
);
// state 정의
localparam S_INIT   = 0;
localparam S_AS     = 1;
localparam S_BS     = 2;
localparam S_CS     = 3;
localparam S_AW     = 4;
localparam S_BW     = 5; 
localparam S_CW     = 6;
localparam S_ABW    = 7;
localparam S_ACW    = 8;
localparam S_BCW    = 9;
localparam S_DRAW   = 10;

// register define
reg [3:0]   c_state;    //current state
reg [3:0]   n_state;    //next state



// part1: register  sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST)    n_state <= S_INIT;
    else        c_state <= n_state;
end

//part2: Next-State Logic


endmodule