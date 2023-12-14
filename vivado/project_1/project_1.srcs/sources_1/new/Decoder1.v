`timescale 1ns / 1ps
module Decoder1(x, D, en);
    input [2:0] x;
    input       en;
    output reg [7:0] D;
    
    always @(en or x) begin
        D = 8'h00;
        if (en) begin
            case(x)
                3'h0 : D = 8'h01;
                3'h1 : D = 8'h02;
                3'h2 : D = 8'h04;
                3'h3 : D = 8'h08;
                3'h4 : D = 8'h10;
                3'h5 : D = 8'h20;
                3'h6 : D = 8'h40;
                3'h7 : D = 8'h80;
            endcase         
        end     
   end
endmodule

`timescale 1ns / 1ps
module Decoder2(x, D, en);
    input [2:0] x;
    input       en;
    output [7:0] D;
    
    assign D = en ? 1'b1 << x : 8'h00;
endmodule
