// fixed_point_checker.v
module fixed_point_checker(
  
  input reg [7:0] x_t_plus_1    // 현재 입력값은 1개이다.
  output reg fixed point
);
 reg [7:0] x_t,
  
  
  always @(x_t_plus_1[0], x_t_plus_1[1],x_t_plus_1[2], x_t_plus_1[3], x_t_plus_1[4], x_t_plus_1[5], x_t_plus_1[6], x_t_plus_1[7]) begin
    if (x_t[0] == x_t_plus_1[0] && x_t[1] == x_t_plus_1[1] && x_t[2] == x_t_plus_1[2] && x_t[3] == x_t_plus_1[3] &&
        x_t[4] == x_t_plus_1[4] && x_t[5] == x_t_plus_1[5] && x_t[6] == x_t_plus_1[6] && x_t[7] == x_t_plus_1[7])
      fixed_point = 1;
    else
      fixed_point = 0;
      
    x_t[0] = x1;
    x_t[1] = x2;
    x_t[2] = x3;
    x_t[3] = x4;
    x_t[4] = x5;
    x_t[5] = x6;
    x_t[6] = x7;
    x_t[7] = x8;
  end

endmodule


  
