`timescale 1ns/100ps
module ham_enc(info_bits, codeword);
    input [11:0]info_bits;
    output [16:0]codeword;

    wire p1 = info_bits[0] ^ info_bits[1] ^ info_bits[3] ^ info_bits[4] ^ info_bits[6] ^ info_bits[8] ^ info_bits[10] ^ info_bits[11];
    wire p2 = info_bits[0] ^ info_bits[2] ^ info_bits[3] ^ info_bits[5] ^ info_bits[6] ^ info_bits[9] ^ info_bits[10];
    wire p3 = info_bits[1] ^ info_bits[2] ^ info_bits[3] ^ info_bits[7] ^ info_bits[8] ^ info_bits[9] ^ info_bits[10];
    wire p4 = info_bits[4] ^ info_bits[5] ^ info_bits[6] ^ info_bits[7] ^ info_bits[8] ^ info_bits[9] ^ info_bits[10];
    wire p5 = info_bits[11];

    assign codeword = {info_bits[11], p5, info_bits[10:4], p4, info_bits[3:1], p3, info_bits[0], p2, p1};
endmodule
