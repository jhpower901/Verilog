`timescale 1ns/100ps
// `include "ham_enc.v"
// `include "ham_dec.v"
// `include "bit_com.v"

module top(info_bits, esti_bits, ham_dis);
    input [11:0]info_bits;
    output [11:0]esti_bits;
    output [3:0]ham_dis;

    wire [16:0]codeword;

    //ham_enc, ham_dec, bit_com Instantiation
    ham_enc enc(.info_bits(info_bits), .codeword(codeword));
    ham_dec dec(.codeword(codeword), .esti_bits(esti_bits));
    bit_com comp(.info_bits(info_bits), .esti_bits(esti_bits), .ham_dis(ham_dis));
    
endmodule
