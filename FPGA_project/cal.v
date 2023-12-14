// gene_net.v

module gene_net(input wire [7:0] x_in ,output reg [7:0] x_out ); //module 모듈_이름 (포트 이름...)

     always @(x_in[0],x_in[1],x_in[2],x_in[3],x_in[4],x_in[5],x_in[6],x_in[7]) begin     //always @() 괄호안의 값이 변화할 때 마다 아래 문장을 실행
    x_out[0] = ~x_in[2] & x_in[6] & ~x_in[7];
    x_out[1] = (x_in[4] | x_in[5]) & ~x_in[7];
    x_out[2] = x_in[7];
    x_out[3] = x_in[1] & ~x_in[6];
    x_out[4] = x_in[1] | x_in[3];
    x_out[5] = x_in[2] & ~x_in[7];
    x_out[6] = x_in[1] & ~x_in[7];
    x_out[7] = ~(x_in[0] | x_in[1]) & (x_in[3] | x_in[6]);
    end
	
endmodule