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
    output reg  [2:0]   WINNER_DISP,
    output reg          A_DISP, B_DISP, C_DISP
);
// state define
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

// state machine of eche input
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        A_DISP <= 0;
        B_DISP <= 0;
        C_DISP <= 0;
    end else begin
        A_DISP <= A_DISP|A;
        B_DISP <= B_DISP|B;
        C_DISP <= C_DISP|C;
    end
end


// part1: Initialize and update the state register
always @(posedge CLK or posedge RST) begin
    if (RST)    n_state <= S_INIT;
    else        c_state <= n_state;
end

//part2: Determine next state
always @(*) begin
    case (c_state)
        S_INIT:
            begin
                case ({C, B, A})
                    3'b000: n_state = c_state;
                    3'b001: n_state = S_AS;
                    3'b010: n_state = S_BS;
                    3'b100: n_state = S_CS;
                    3'b011: n_state = S_CW;
                    3'b101: n_state = S_BW;
                    3'b110: n_state = S_AW;
                    3'b111: n_state = S_DRAW;
                    default: n_state = c_state;
                endcase
            end
        S_AS:
            begin
                case ({C, B})
                    3'b00: n_state = c_state;
                    3'b01: n_state = S_ABW;
                    3'b10: n_state = S_ACW;
                    3'b11: n_state = S_AW;
                    default: n_state = c_state;
                endcase
            end
        S_BS:
            begin
                case ({C, A})
                    3'b00: n_state = c_state;
                    3'b01: n_state = S_ABW;
                    3'b10: n_state = S_BCW;
                    3'b11: n_state = S_BW;
                    default: n_state = c_state;
                endcase
            end
        S_CS:
            begin
                case ({B, A})
                    3'b00: n_state = c_state;
                    3'b01: n_state = S_ACW;
                    3'b10: n_state = S_BCW;
                    3'b11: n_state = S_CW;
                    default: n_state = c_state;
                endcase
            end
        default: n_state = c_state;
    endcase
end

//part3 : Determine output
always @(*) begin
    case (c_state)
        S_AW:   WINNER_DISP = 3'b001;
        S_BW:   WINNER_DISP = 3'b010;
        S_CW:   WINNER_DISP = 3'b100;
        S_ABW:  WINNER_DISP = 3'b011;
        S_BCW:  WINNER_DISP = 3'b110;
        S_ACW:  WINNER_DISP = 3'b101;
        S_DRAW: WINNER_DISP = 3'b111;
        default: WINNER_DISP = 3'b000;
    endcase
end

endmodule