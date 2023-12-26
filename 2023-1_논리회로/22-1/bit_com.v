`timescale 1ns/100ps
module bit_com(info_bits, esti_bits, ham_dis);
    input [11:0]info_bits, esti_bits;
    output reg [3:0]ham_dis;

    reg [11:0]info_bits_reg;
    reg [11:0]esti_bits_reg;
    integer sum;
    integer i;

    always @(*) begin
        info_bits_reg = info_bits;
        esti_bits_reg = esti_bits;

        sum = 0;
        for (i = 0; i < 12; i = i + 1) begin
            if (info_bits_reg[i] != esti_bits_reg[i]) begin
                sum = sum + 1;
            end
        end

        ham_dis = sum;
    end

endmodule