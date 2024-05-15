module gray2excess(
	input  wire [3:0] gray,
	output wire [3:0] excess
);
	assign excess[3] = gray[2]&~gray[1]|gray[2]&gray[0];
	assign excess[2] = gray[3]&gray[0]|~gray[2]&gray[0]|gray[1]&~gray[0];
	assign excess[1] = ~gray[0];
	assign excess[0] = ~gray[3]&gray[2]&~gray[1]&gray[0]
			  |gray[2]&gray[1]&~gray[0]
			  |~gray[2]&~gray[1]&~gray[0]
			  |gray[3]&~gray[0]
 			  |~gray[2]&gray[1]&gray[0];
endmodule
