module MUX2x1_StructualModel (
	input	SEL, EN_L, A, B,
	output	F
);
	wire sel_l;
	wire en;
	wire out1;
	wire out2;

	not (sel_l, SEL);
	not (en, EN_L);
	and (out1, en, sel_l, A);
	and (out2, en, SEL, B);
	or 	(F, out1, out2);
endmodule

module MUX2x1_DataflowModel (
	input	SEL, EN_L, A, B,
	output	F
);
	//assign F = ~EN_L & (~SEL & A | SEL & B);
	assign F = EN_L ? 1'b0 : (SEL ? B : A);
endmodule

module MUX2x1_BehavialModel (
	input		SEL, EN_L, A, B,
	output	reg	F
);
	always @(*) begin
		if (EN_L) begin
			F = 1'b0;
		end else begin
			case (SEL)
				0 : F = A;
				1 : F = B;
				default	: F = 'bx;
			endcase
		end
	end
endmodule