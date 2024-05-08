/*
 * 0101 Sequence Detector
 * state :  R0      11...
 *          RZ      00...
 *          Z20     01
 *          Z202Z   010
 */
module sequence_detector_using_function(clock, x, reset_n, z);
    input       clock, x, reset_n;
    output  reg z;
    reg [1:0] state;
    localparam  R0    = 2'b00,
                RZ    = 2'b01,
                Z20   = 2'b10,
                Z202Z = 2'b11;
    //initialize and update the state register
    always @(posedge clock, negedge reset_n) begin
        if (!reset_n)  state <= R0;
        else           state <= next_state(state, x);
    end

    //determine next state using function
    function next_state (
        input state, x
    );
        case (state)
            R0: next_state = x ? R0 : RZ;
            RZ: next_state = x ? Z20 : RZ;
            Z20: next_state = x ? R0 : Z202Z;
            Z202Z: next_state = x ? Z20 : RZ;
            default: next_state = R0;
        endcase
    endfunction

    //determine output
    always @(state, x) begin
        case (state)
            R0: z = x ? 0 : 0;
            RZ: z = x ? 0 : 0;
            Z20: z = x ? 0 : 0;
            Z202Z: z = x ? 1 : 0;
            default: z = 0;
        endcase
    end
endmodule

module sequence_detector_using_always(clock, x, reset_n, z);
    input       clock, x, reset_n;
    output  reg z;
    reg [1:0] c_state, n_state;
    localparam  R0    = 2'b00,
                RZ    = 2'b01,
                Z20   = 2'b10,
                Z202Z = 2'b11;
    //initialize and update the state register
    always @(posedge clock, negedge reset_n) begin
        if (!reset_n)  c_state <= R0;
        else           c_state <= n_state;
    end

    //determine next state using always
    always @(c_state, x) begin
        case (c_state)
            R0: n_state = x ? R0 : RZ;
            RZ: n_state = x ? Z20 : RZ;
            Z20: n_state = x ? R0 : Z202Z;
            Z202Z: n_state = x ? Z20 : RZ;
            default: n_state = R0;
        endcase
    end

    //determine output
    always @(c_state, x) begin
        case (c_state)
            R0: z = x ? 0 : 0;
            RZ: z = x ? 0 : 0;
            Z20: z = x ? 0 : 0;
            Z202Z: z = x ? 1 : 0;
            default: z = 0;
        endcase
    end
endmodule