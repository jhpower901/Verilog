module cmp8b_insigned_BehavialModel (
	input	[7:0]	P, Q,
	output	reg		PGTQ, PEQQ, PLTQ
);

always @(*) begin
	PGTQ = 1'b0;	// P>Q
	PEQQ = 1'b0;	// P==Q
	PLTQ = 1'b0;	// P<Q

	if (P > Q)
		PGTQ = 1'b1;
	else if (P == Q)
		PEQQ = 1'b1;
	else
		PLTQ = 1'b1;
end

endmodule

module parity_check #(
	parameter 			BITS = 8
) (
	input	[BITS-1:0]	IN1, IN2,
	output				EVEN
);

	//일단 모르겠음

endmodule

module cmp8b_insigned_StructualModel (
	input	[7:0]	P, Q,
	output	reg		PGTQ, PEQQ, PLTQ
);
	wire 	[7:1]	trunc_eq_w;			//i번째 bit 앞의 값들이 같은지 비교해서 결과를 저장할 벡터
	integer j;
	genvar i;
	generate
		for (i = 7; i >= 1; i = i - 1)
			parity_check #(i) pc ( .IN1(P[7:i]), .IN2(Q[7:i]), .EVEN(trunc_eq_w[i]));
	endgenerate

	always @(*) begin
		PGTQ = 1'b0;
		PEQQ = 1'b0;
		if (P[7]&~Q[7])
			PGTQ = 1'b1;
		else
		for (j = 6; j > 0; j = j - 1) begin
			if (P[j]&~Q[j] && trunc_eq_w[j+1])
				PGTQ = 1'b1;
		end
		if (~(P[0]^Q[0]) && trunc_eq_w[1])
			PEQQ = 1'b1;
		PLTQ = (~PEQQ && ~PGTQ) ? 1'b1 : 1'b0;
	end
endmodule