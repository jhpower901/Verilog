module assignment1 (
	input A, B, C, D,
	output OUT
);
	wire A1, O1;

	//assign OUT = ~(A & B) & C | ~D;

	and	(A1, A, B);
	or	(O1, A1, ~C);
	nand(OUT, O1, D);

endmodule