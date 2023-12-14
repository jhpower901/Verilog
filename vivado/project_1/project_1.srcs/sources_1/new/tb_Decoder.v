`timescale 1ns / 100ps
`include "Decoder1.v"

module tb_Decoder;
    reg enable;
    reg [2:0] x;
    wire [7:0] D1;
    wire [7:0] D2;
    
    initial begin
        enable = 0;
        x = 0;
        #10
        enable = 1;
        repeat(8) begin
            #5
            $display("DEC1 : %b", D1);
            $display("DEC2 : %b", D2);
            x = x + 1;
        end
        $finish;
    end
    
    Decoder1 DEC1 (.x(x), .en(enable), .D(D1));
    Decoder2 DEC2 (.x(x), .en(enable), .D(D2));
endmodule
