module ttest(
   input wire clock_50m,
   input wire [15:0] pb,
   output reg [7:0] fnd_s,
   output reg [7:0] fnd_d
);
   
   reg [29:0] counter;   // clock counter
   reg pb_clk; // push button clock
   reg sg_clk; // segment clock
   
   reg [15:0] npb; // inverse pb
   reg [15:0] pbs [1:0]; // save pb
   reg val_in; // input value checker
   reg [15:0] tmp;

   reg [3:0] ans [5:0];
   reg [2:0] opts [2:0];
   reg [2:0] opt;
   reg [3:0] opd [5:0];

   reg is_opt;
   reg is_opd;

   reg [7:0] sg_val [5:0]; // 0~6 segment set value
   reg [7:0] sg_pos; // segment set poition value
   
   reg err;

   integer i; // for using repetition
   integer j; // for using repetition
   integer k; // for using repetition
   
   initial begin
      counter = 30'b0;
      
      for(i = 0; i < 1; i = i + 1) begin
         pbs[i] = 8'b0;
      end
      val_in = 1'b0;
      tmp = 16'b0;

      is_opt = 1'b0;
      is_opd = 1'b0;is_opt = 1'b0;
      is_opd = 1'b0;

      for(i = 0; i < 6; i = i + 1) begin
         sg_val[i] = 8'b0;
      end

      sg_pos = 8'b0;
      
      err = 1'b0;

      j = 0;
      k = 0;
   end
   
   always begin
      npb = ~pb;
      pb_clk = counter[18];
      sg_clk = counter[15]; // 여기 
   end

   
   always @(posedge clock_50m) begin
      counter = counter + 1;
   end

   always @(posedge pb_clk) begin
      pbs[1] = pbs[0];
      pbs[0] = npb;

      if (pbs[1] == 4'h0000 && pbs[1] != pbs[0]) begin
         tmp = pbs[0];
         val_in = 1'b1;
      end else begin
         val_in = 1'b0;
      end
   end
   
   always @(posedge val_in) begin
   
      is_operand(tmp, is_opd);
      is_operator(tmp, is_opt);
      
      if (is_opd) begin
         
         print_num(tmp);
      end else if (is_opt) begin
      
         print_kor(tmp);
      end else begin
         sg_val[5] = 8'b0000_0000;
         sg_val[4] = 8'b0000_0000;
         sg_val[3] = 8'b0000_0000;
         sg_val[2] = 8'b0000_0000;
         sg_val[1] = 8'b0000_0000;
         sg_val[0] = 8'b0000_1001;
      end
   end

   task is_operand(
      input [15:0] val,
      output result
   );

      if (val == 16'h0001 || val == 16'h0002 ||
         val == 16'h0004 || val == 16'h0010 ||
         val == 16'h0020 || val == 16'h0040 ||
         val == 16'h0100 || val == 16'h0200 ||
         val == 16'h0400 || val == 16'h2000) begin

         result = 1'b1;
      end else begin
         result = 1'b0;
      end
   endtask

   task is_operator(
      input [15:0] val,
      output result
   );
      
      if (val == 16'h0008 || val == 16'h0080 ||
         val == 16'h0800 || val == 16'h4000 ||
         val == 16'h8000) begin

         result = 1'b1;
      end else begin
         result = 1'b0;
      end
   endtask

   task print_num(
      input [15:0] val
   );
      begin
         sg_val[5] = 8'b0000_0000;
         sg_val[4] = 8'b0000_0000;
         sg_val[3] = 8'b0000_0000;
         sg_val[2] = 8'b0000_0000;
         sg_val[1] = 8'b0000_0000;
         
         case (val)
            16'h2000: sg_val[0] = 8'b0011_1111; // 0
            16'h0001: sg_val[0] = 8'b0000_0110; // 1
            16'h0002: sg_val[0] = 8'b0101_1011; // 2
            16'h0004: sg_val[0] = 8'b0100_1111; // 3
            16'h0010: sg_val[0] = 8'b0110_0110; // 4
            16'h0020: sg_val[0] = 8'b0110_1101; // 5
            16'h0040: sg_val[0] = 8'b0111_1101; // 6
            16'h0100: sg_val[0] = 8'b0010_0111; // 7
            16'h0200: sg_val[0] = 8'b0111_1111; // 8
            16'h0400: sg_val[0] = 8'b0110_1111; // 9
            default: sg_val[0] = 8'b000_000;
         endcase
      end
   endtask
   
   
   task print_kor(
      input [15:0] val
   );
      case (val)
         16'h0008: begin // 더하기
            sg_val[5] = 8'b0011_1001; // ㄷ(11_1001)
            sg_val[4] = 8'b0100_0110; // ㅓ
            sg_val[3] = 8'b0101_1101; // ㅎ
            sg_val[2] = 8'b0111_0000; // ㅏ
            sg_val[1] = 8'b0000_0111; // ㄱ
            sg_val[0] = 8'b0000_0110; // ㅣ
         end
         16'h0080: begin // 빼기
            sg_val[5] = 8'b0111_1110; // ㅂ
            sg_val[4] = 8'b0111_1110; // ㅂ
            sg_val[3] = 8'b0111_0110; // ㅐ
            sg_val[2] = 8'b0000_0000; // 
            sg_val[1] = 8'b0000_0111; // ㄱ
            sg_val[0] = 8'b0000_0110; // ㅣ
         end
         16'h0800: begin // 곱하기
            sg_val[5] = 8'b0000_1101; // ㄱ(00_1101)
            sg_val[4] = 8'b0000_1011; // ㅗ
            sg_val[3] = 8'b0111_1110; // ㅂ
            sg_val[2] = 8'b0111_0000; // ㅏ
            sg_val[1] = 8'b0000_0111; // ㄱ
            sg_val[0] = 8'b0000_0110; // ㅣ
         end
         16'h8000: begin // 나누기
            sg_val[5] = 8'b0011_1000; // ㄴ
            sg_val[4] = 8'b0111_0000; // ㅏ
            sg_val[3] = 8'b0110_1000; // ㄴ
            sg_val[2] = 8'b0100_1000; // ㅡ
            sg_val[1] = 8'b0000_0111; // ㄱ
            sg_val[0] = 8'b0000_0110; // ㅣ
         end
         16'h4000: begin // 나머지
            sg_val[5] = 8'b0011_1000; // ㄴ
            sg_val[4] = 8'b0111_0000; // ㅏ
            sg_val[3] = 8'b0011_1111; // ㅁ
            sg_val[2] = 8'b0100_0110; // ㅓ
            sg_val[1] = 8'b0101_0111; // ㅈ
            sg_val[0] = 8'b0000_0110; // ㅣ
         end
         default: begin
            for (j = 0; j < 6; j = j + 1) begin
               sg_val[j] = 8'b000_000;
            end
         end
   
      endcase
   
   endtask
   
   always @(posedge sg_clk) begin
      
      case (k)
         0: sg_pos = 8'b1111_1110;
         1: sg_pos = 8'b1111_1101;
         2: sg_pos = 8'b1111_1011;
         3: sg_pos = 8'b1111_0111;
         4: sg_pos = 8'b1110_1111;
         5: sg_pos = 8'b1101_1111;
      endcase
   
      fnd_d = sg_val[k];
      fnd_s = sg_pos;
      
      if (k < 5) begin
         k = k + 1;
      end else begin
         k = 0;
      end
   end

endmodule