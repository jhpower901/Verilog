`timescale 1ns/100ps
module ham_dec(codeword, esti_bits);
    input [16:0]codeword;
    output reg [11:0]esti_bits;

    reg [0:4]syndrome;
    reg [16:0]codeword_reg;

    always @(*) begin
        codeword_reg = codeword;
        codeword_reg[13] = ~codeword[13]; // Error Occured at 14th.

        syndrome[0] = codeword_reg[0] ^ codeword_reg[2] ^ codeword_reg[4] ^ codeword_reg[6] ^ codeword_reg[8] ^ codeword_reg[10] ^ codeword_reg[12] ^ codeword_reg[14] ^ codeword_reg[16];
        syndrome[1] = codeword_reg[1] ^ codeword_reg[2] ^ codeword_reg[5] ^ codeword_reg[6] ^ codeword_reg[9] ^ codeword_reg[10] ^ codeword_reg[13] ^ codeword_reg[14];
        syndrome[2] = codeword_reg[3] ^ codeword_reg[4] ^ codeword_reg[5] ^ codeword_reg[6] ^ codeword_reg[11] ^ codeword_reg[12] ^ codeword_reg[13] ^ codeword_reg[14];
        syndrome[3] = codeword_reg[7] ^ codeword_reg[8] ^ codeword_reg[9] ^ codeword_reg[10] ^ codeword_reg[11] ^ codeword_reg[12] ^ codeword_reg[13] ^ codeword_reg[14];
        syndrome[4] = codeword_reg[15] ^ codeword_reg[16];

        if(syndrome) begin
            codeword_reg[syndrome - 1] = ~codeword_reg[syndrome - 1];
        end

        esti_bits = {codeword_reg[16], codeword_reg[14:8], codeword_reg[6:4], codeword_reg[2]};
    end
endmodule
