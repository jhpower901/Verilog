module primeNumDetector (
	input [3:0] n,
	output	    p
);
	wire w_and[3:0];

	and (w_and[0], ~n[3], ~n[2], n[1]);
	and (w_and[1], ~n[3],  n[2] ,n[0]);
	and (w_and[2], ~n[2],  n[1], n[0]);
	and (w_and[3],  n[2], ~n[1], n[0]);
	or  (p, w_and[0], w_and[1], w_and[2], w_and[3]);
endmodule
