module assignment1 (
	input A, B, C, D,
	output OUT
);
	assign OUT = ~(A & B) & C | ~D;
endmodule
