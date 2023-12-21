module codeeee(clock_50m, pb, fnd_s, fnd_d);
   
   // input output.
   input clock_50m;
   input [15:0] pb;
   output reg [5:0] fnd_s;
   output reg [7:0] fnd_d;
   
   // clock.
   reg [15:0] npb;
   reg [31:0] init_counter;
   reg sw_clk;
   reg fnd_clk;
   reg [2:0] fnd_cnt;
   
   //add variable
   reg signed [40:0] temp; //because 999,999*999,999=999,998,000,001, and 2^40 is 1,099,511,627,776 so we need 41bit for signed register
   reg [3:0] opcage;
   reg [19:0] numbercage;
   reg more;
   reg eof;
   reg divide0;
   reg overflow;
   
   // 7-segment.
   reg [4:0] set_no1;
   reg [4:0] set_no2;
   reg [4:0] set_no3;
   reg [4:0] set_no4;
   reg [4:0] set_no5;
   reg [4:0] set_no6;
   reg [6:0] seg_100000;
   reg [6:0] seg_10000;
   reg [6:0] seg_1000;
   reg [6:0] seg_100;
   reg [6:0] seg_10;
   reg [6:0] seg_1;
   
   
   
   // switch(keypad) control.
   reg [15:0] pb_1st;
   reg [15:0] pb_2nd;
   reg sw_toggle;
   
   // sw_status.
   reg [2:0] sw_status;
   parameter sw_start = 0;
   parameter sw_s1 = 1;
   parameter sw_s2 = 2;
   parameter sw_s3 = 3;
   parameter sw_s4 = 4;
   parameter sw_s5 = 5;
   parameter sw_s6 = 6;
   parameter sw_er = 7;

   
   // initial.
   initial begin
      sw_status <= sw_start;
      sw_toggle <= 0;
      npb <= 'h0000;
      pb_1st <= 'h0000;
      pb_2nd <= 'h0000;
      set_no1 <= 30;
      set_no2 <= 30;
      set_no3 <= 30;
      set_no4 <= 30;
      set_no5 <= 30;
      set_no6 <= 30;
      temp = 0;
      opcage = 0;
      numbercage =0;
      more = 0;
      eof = 0;
      divide0 = 0;
      overflow = 0;
   end
   
   // input. clock divider.
   always begin
      npb <= ~pb;                  // input, pb is meaning push button
      sw_clk <= init_counter[20];      // clock for keypad(switch)
      fnd_clk <= init_counter[16];   // clock for 7-segment
   end
   
   // clock_50m. clock counter.
   always @(posedge clock_50m) begin
      init_counter <= init_counter + 1;
   end
   
   // sw_clk. get two consecutive inputs to correct switch(keypad) error.
   always @(posedge sw_clk) begin
      pb_2nd <= pb_1st;
      pb_1st <= npb;
      
      if (pb_2nd == 'h0000 && pb_1st != pb_2nd) begin
         sw_toggle <= 1;
      end
      
      if (sw_toggle == 1 && pb_1st == pb_2nd) begin
         sw_toggle <= 0;
         
         case (pb_1st)
                 'h0001: begin //1
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 1;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 1;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 1;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 1;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 1;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 1;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end

            'h0002: begin //2
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 2;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 2;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 2;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 2;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 2;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 2;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0004: begin //3
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 3;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 3;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 3;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 3;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 3;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 3;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0008: begin // +
               if (more == 0) begin
                  case (sw_status)
                     sw_start: begin
                        if(set_no1 == 0) begin
                           numbercage = 0;
                        end
                        else if(opcage == 1) begin//be careful! : In shift state, don't touch,push number,,,,,,,only operator 
                           more = 1;
                           
                        end
                        else begin
                           eof = 1;
                        end
                     end
                     sw_s1: begin
                        numbercage = set_no1;
                     end
                     sw_s2: begin
                        numbercage = set_no1*10+set_no2;
                     end
                     sw_s3: begin
                        numbercage = set_no1*100+set_no2*10+set_no3;
                     end
                     sw_s4: begin
                        numbercage = set_no1*1000+set_no2*100+set_no3*10+set_no4;
                     end
                     sw_s5: begin
                        numbercage = set_no1*10000+set_no2*1000+set_no3*100+set_no4*10+set_no5;
                     end
                     sw_s6: begin
                        numbercage = set_no1*100000+set_no2*10000+set_no3*1000+set_no4*100+set_no5*10+set_no6;
                     end
                  endcase
                  
                  case (opcage)
                     0: begin //get first op
                        temp = numbercage;
                     end
                     1: begin      //+
                        if(more == 0) begin
                           temp = temp + numbercage;
                        end
                     end
                     2: begin      //-
                        temp = temp - numbercage;
                     end
                     3: begin      //*
                        temp = temp * numbercage;
                     end
                     4: begin      // div(/)
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp / numbercage;
                        end
                     end
                     5: begin      //%
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp % numbercage;
                        end
                     end
                  endcase
                  
                  if((temp > 999999)||(temp < -99999)) begin
                     overflow = 1;
                  end
                  
                  if (divide0 == 1 || overflow == 1 || eof == 1) begin
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 0;
                     temp = 0;
                     numbercage = 0;
                     divide0 = 0;
                     overflow = 0;
                     eof = 0;
                     more = 0;
                  end
                  else if (more == 0) begin
                     set_no1 <= 30;
                     set_no2 <= 12;   //A
                     set_no3 <= 15;   //d
                     set_no4 <= 15;   //d
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 1;
                  end
                  else begin
                     set_no1 <= 30;      //m0rE
                     set_no2 <= 17;   //r
                     set_no3 <= 19;   //n
                     set_no4 <= 0;   //0
                     set_no5 <= 17;   //r
                     set_no6 <= 16;   //E
                  end
                  
                  sw_status <= sw_start;
               end
               else begin
                  set_no1 <= 16;
                  set_no2 <= 17;
                  set_no3 <= 17;
                  set_no4 <= 30;
                  set_no5 <= 30;
                  set_no6 <= 30;
                  opcage = 0;
                  temp = 0;
                  numbercage = 0;
                  divide0 = 0;
                  overflow = 0;
                  eof = 0;
                  more = 0;
               end
            end
            'h0010: begin //4
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 4;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 4;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 4;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 4;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 4;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 4;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0020: begin //5
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 5;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 5;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 5;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 5;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 5;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 5;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0040: begin //6
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 6;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 6;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 6;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 6;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 6;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 6;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0080: begin // (-)
               if(more == 0) begin
                  case (sw_status)
                     sw_start: begin
                        if(set_no1 != 0) begin
                           eof = 1;
                        end
                        else begin
                           numbercage = 0;
                        end
                     end
                     sw_s1: begin
                        numbercage = set_no1;
                     end
                     sw_s2: begin
                        numbercage = set_no1*10+set_no2;
                     end
                     sw_s3: begin
                        numbercage = set_no1*100+set_no2*10+set_no3;
                     end
                     sw_s4: begin
                        numbercage = set_no1*1000+set_no2*100+set_no3*10+set_no4;
                     end
                     sw_s5: begin
                        numbercage = set_no1*10000+set_no2*1000+set_no3*100+set_no4*10+set_no5;
                     end
                     sw_s6: begin
                        numbercage = set_no1*100000+set_no2*10000+set_no3*1000+set_no4*100+set_no5*10+set_no6;
                     end
                  endcase   
                  
                  case (opcage)
                     0: begin //get first op
                        temp = numbercage;
                     end
                     1: begin      //+
                        temp = temp + numbercage;
                     end
                     2: begin      //-
                        temp = temp - numbercage;
                     end
                     3: begin      //*
                        temp = temp * numbercage;
                     end
                     4: begin      // div(/)
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp / numbercage;
                        end
                     end
                     5: begin      //%
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp % numbercage;
                        end
                     end
                  endcase
                  
                  if((temp > 999999)||(temp < -99999)) begin
                     overflow = 1;
                  end
                  
                  if (divide0 == 1 || overflow == 1 || eof == 1) begin
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 0;
                     divide0 = 0;
                     temp = 0;
                     numbercage = 0;
                     overflow = 0;
                     eof = 0;
                     more = 0;
                  end
                  else begin
                     set_no1 <= 30;
                     set_no2 <= 20;   //S
                     set_no3 <= 21;   //u
                     set_no4 <= 13;   //b
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 2;
                  end
                  
                  sw_status <= sw_start;
               end
               else begin
                  set_no1 <= 16;
                  set_no2 <= 17;
                  set_no3 <= 17;
                  set_no4 <= 30;
                  set_no5 <= 30;
                  set_no6 <= 30;
                  opcage = 0;
                  numbercage = 0;
                  temp = 0;
                  divide0 = 0;
                  more = 0;
                  overflow = 0;
                  eof = 0;
               end
            end
            'h0100: begin //7
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 7;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 7;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 7;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 7;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 7;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 7;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0200: begin //8
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 8;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 8;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 8;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 8;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 8;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 8;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h0400: begin //9
               case (sw_status)
                  sw_start: begin
                     sw_status <= sw_s1;
                     set_no1 <= 9;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 9;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 9;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 9;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 9;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 9;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
                       'h0800: begin // X (Mul)
               if (more == 0) begin
                  case (sw_status)
                     sw_start: begin
                        if(set_no1 != 0) begin
                           eof = 1;
                        end
                        else begin
                           numbercage = 0;
                        end
                     end
                     sw_s1: begin
                        numbercage = set_no1;
                     end
                     sw_s2: begin
                        numbercage = set_no1*10+set_no2;
                     end
                     sw_s3: begin
                        numbercage = set_no1*100+set_no2*10+set_no3;
                     end
                     sw_s4: begin
                        numbercage = set_no1*1000+set_no2*100+set_no3*10+set_no4;
                     end
                     sw_s5: begin
                        numbercage = set_no1*10000+set_no2*1000+set_no3*100+set_no4*10+set_no5;
                     end
                     sw_s6: begin
                        numbercage = set_no1*100000+set_no2*10000+set_no3*1000+set_no4*100+set_no5*10+set_no6;
                     end
                  endcase   
                  
                  case (opcage)
                     0: begin //get first op
                        temp = numbercage;
                     end
                     1: begin      //+
                        temp = temp + numbercage;
                     end
                     2: begin      //-
                        temp = temp - numbercage;
                     end
                     3: begin      //*
                        temp = temp * numbercage;
                     end
                     4: begin      // div(/)
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp / numbercage;
                        end
                     end
                     5: begin      //%
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp % numbercage;
                        end
                     end
                  endcase
                  
                  if((temp > 999999)||(temp < -99999)) begin
                     overflow = 1;
                  end
                  
                  if (divide0 == 1 || overflow == 1 || eof == 1) begin
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 0;
                     divide0 = 0;
                     temp = 0;
                     numbercage = 0;
                     overflow = 0;
                     eof = 0;
                     more = 0;
                  end
                  else begin
                     set_no1 <= 30;      //mul 
                     set_no2 <= 17;   //r
                     set_no3 <= 19;   //n
                     set_no4 <= 21;   //u
                     set_no5 <= 1;   //1
                     set_no6 <= 30;
                     opcage = 3;
                  end
                  
                  sw_status <= sw_start;
               end
               else begin
                  set_no1 <= 16;
                  set_no2 <= 17;
                  set_no3 <= 17;
                  set_no4 <= 30;
                  set_no5 <= 30;
                  set_no6 <= 30;
                  opcage = 0;
                  numbercage = 0;
                  temp = 0;
                  divide0 = 0;
                  more = 0;
                  overflow = 0;
                  eof = 0;
               end
            end
                       'h1000: begin   // enter
               if (more ==0) begin
                  case (sw_status)
                     sw_start: begin
                        if(set_no1 != 0) begin
                           eof = 1;
                        end
                        else begin
                           numbercage = 0;
                        end
                     end
                     sw_s1: begin
                        numbercage = set_no1;
                     end
                     sw_s2: begin
                        numbercage = set_no1*10+set_no2;
                     end
                     sw_s3: begin
                        numbercage = set_no1*100+set_no2*10+set_no3;
                     end
                     sw_s4: begin
                        numbercage = set_no1*1000+set_no2*100+set_no3*10+set_no4;
                     end
                     sw_s5: begin
                        numbercage = set_no1*10000+set_no2*1000+set_no3*100+set_no4*10+set_no5;
                     end
                     sw_s6: begin
                        numbercage = set_no1*100000+set_no2*10000+set_no3*1000+set_no4*100+set_no5*10+set_no6;
                     end
                  endcase
                  
                  case (opcage)
                     0: begin //get first op
                        temp = numbercage;
                     end
                     1: begin      //+
                        temp = temp + numbercage;
                     end
                     2: begin      //-
                        temp = temp - numbercage;
                     end
                     3: begin      //*
                        temp = temp * numbercage;
                     end
                     4: begin      // div(/)
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp / numbercage;
                        end
                     end
                     5: begin      //%
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp % numbercage;
                        end
                     end
                  endcase
               
                  if((temp > 999999)||(temp < -99999)) begin
                     overflow = 1;
                  end
                  
                  if (divide0 == 1 || overflow == 1 || eof == 1) begin
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                     temp = 0;
                     numbercage = 0;
                     more = 0;
                     overflow = 0;
                     eof = 0;
                     divide0 = 0;
                  end
                  else if (temp >= 0) begin
                     if(temp/100000 == 0) begin
                        if((temp%100000)/10000 == 0) begin
                           if((temp%10000)/1000 == 0) begin
                              if((temp%1000)/100 == 0) begin
                                 if((temp%100)/10 == 0) begin
                                    if(temp%10 == 0) begin
                                       set_no1 <= 0;      
                                       set_no2 <= 30;
                                       set_no3 <= 30;   
                                       set_no4 <= 30;   
                                       set_no5 <= 30;   
                                       set_no6 <= 30;
                                    end
                                    else begin
                                       set_no1 <= (temp%10);
                                       set_no2 <= 30;
                                       set_no3 <= 30;   
                                       set_no4 <= 30;   
                                       set_no5 <= 30;   
                                       set_no6 <= 30;
                                    end
                                 end
                                 else begin
                                    set_no1 <= (temp%100)/10;
                                    set_no2 <= (temp%10);
                                    set_no3 <= 30;   
                                    set_no4 <= 30;   
                                    set_no5 <= 30;   
                                    set_no6 <= 30;   
                                 end
                              end
                              else begin
                                 set_no1 <= (temp%1000)/100;   
                                 set_no2 <= (temp%100)/10;
                                 set_no3 <= (temp%10);
                                 set_no4 <= 30;   
                                 set_no5 <= 30;   
                                 set_no6 <= 30;   
                              end
                           end
                           else begin
                              set_no1 <= (temp%10000)/1000;   
                              set_no2 <= (temp%1000)/100;   
                              set_no3 <= (temp%100)/10;
                              set_no4 <= (temp%10);
                              set_no5 <= 30;   
                              set_no6 <= 30;   
                           end
                        end
                        else begin
                           set_no1 <= (temp%100000)/10000;   
                           set_no2 <= (temp%10000)/1000;   
                           set_no3 <= (temp%1000)/100;   
                           set_no4 <= (temp%100)/10;
                           set_no5 <= (temp%10);
                           set_no6 <= 30;   
                        end
                     end
                     else begin
                        set_no1 <= temp/100000;   
                        set_no2 <= (temp%100000)/10000;   
                        set_no3 <= (temp%10000)/1000;   
                        set_no4 <= (temp%1000)/100;   
                        set_no5 <= (temp%100)/10;
                        set_no6 <= (temp%10);
                     end
                  end
                  else begin;
                     set_no1 <= 18;
                     temp = temp*(-1);
                     if(temp/10000 == 0) begin
                        if((temp%10000)/1000 == 0) begin
                           if((temp%1000)/100 == 0) begin
                              if((temp%100)/10 == 0) begin
                                 set_no2 <= (temp%10);
                                 set_no3 <= 30; 
                                 set_no4 <= 30;   
                                 set_no5 <= 30;   
                                 set_no6 <= 30;
                              end
                              else begin
                                 set_no2 <= (temp%100)/10;
                                 set_no3 <= (temp%10);
                                 set_no4 <= 30;   
                                 set_no5 <= 30;   
                                 set_no6 <= 30;   
                              end
                           end
                           else begin
                              set_no2 <= (temp%1000)/100;   
                              set_no3 <= (temp%100)/10;
                              set_no4 <= (temp%10);
                              set_no5 <= 30;   
                              set_no6 <= 30;   
                           end
                        end
                        else begin
                           set_no2 <= (temp%10000)/1000;   
                           set_no3 <= (temp%1000)/100;   
                           set_no4 <= (temp%100)/10;
                           set_no5 <= (temp%10);
                           set_no6 <= 30;   
                        end
                     end
                     else begin
                        set_no2 <= (temp%100000)/10000;   
                        set_no3 <= (temp%10000)/1000;   
                        set_no4 <= (temp%1000)/100;   
                        set_no5 <= (temp%100)/10;
                        set_no6 <= (temp%10);
                     end
                  end
  
                  sw_status <= sw_start;
                  opcage = 0;
                  temp = 0;
                  numbercage = 0;
               end
               else begin
                  set_no1 <= 16;
                  set_no2 <= 17;
                  set_no3 <= 17;
                  set_no4 <= 30;
                  set_no5 <= 30;
                  set_no6 <= 30;
                  divide0 = 0;
                  temp = 0;
                  numbercage = 0;
                  more = 0;
                  overflow = 0;
                  eof = 0;
               end
            end
            'h2000: begin      //0
               case (sw_status)
                  
                  sw_start: begin
                     set_no1 <= 0;
                     set_no2 <= 30;
                     set_no3 <= 30;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
                  sw_s1: begin
                     sw_status <= sw_s2;
                     set_no2 <= 0;
                  end
                  sw_s2: begin
                     sw_status <= sw_s3;
                     set_no3 <= 0;
                  end
                  sw_s3: begin
                     sw_status <= sw_s4;
                     set_no4 <= 0;
                  end
                  sw_s4: begin
                     sw_status <= sw_s5;
                     set_no5 <= 0;
                  end
                  sw_s5: begin
                     sw_status <= sw_s6;
                     set_no6 <= 0;
                  end
                  sw_s6: begin
                     sw_status <= sw_start;
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                  end
               endcase
            end
            'h4000: begin //CE: Clear Entry
               if(more == 0) begin
                  set_no1 <= 30;
                  set_no2 <= 30;
                  set_no3 <= 30;
                  set_no4 <= 30;
                  set_no5 <= 30;
                  set_no6 <= 30;
               end
               else begin
                  set_no1 <= 30;      //ClEAr
                  set_no2 <= 14;   //C
                  set_no3 <= 1;   //1
                  set_no4 <= 16;   //E
                  set_no5 <= 12;   //A
                  set_no6 <= 17;   //r
                  opcage = 0;
                  divide0 = 0;
                  temp = 0;
                  numbercage = 0;
                  overflow = 0;
                  eof = 0;
                  more = 0;
               end
               sw_status <= sw_start;
            end
            'h8000: begin // div(/)
               if(more == 0) begin   
                  case (sw_status)
                     sw_start: begin
                        eof = 1;
                     end
                     sw_s1: begin
                        numbercage = set_no1;
                     end
                     sw_s2: begin
                        numbercage = set_no1*10+set_no2;
                     end
                     sw_s3: begin
                        numbercage = set_no1*100+set_no2*10+set_no3;
                     end
                     sw_s4: begin
                        numbercage = set_no1*1000+set_no2*100+set_no3*10+set_no4;
                     end
                     sw_s5: begin
                        numbercage = set_no1*10000+set_no2*1000+set_no3*100+set_no4*10+set_no5;
                     end
                     sw_s6: begin
                        numbercage = set_no1*100000+set_no2*10000+set_no3*1000+set_no4*100+set_no5*10+set_no6;
                     end
                  endcase   
                  
                  case (opcage)
                     0: begin //get first op
                        temp = numbercage;
                     end
                     1: begin      //+
                        temp = temp + numbercage;
                     end
                     2: begin      //-
                        temp = temp - numbercage;
                     end
                     3: begin      //*
                        temp = temp * numbercage;
                     end
                     4: begin      // div(/)
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp / numbercage;
                        end
                     end
                     5: begin      //%
                        if(numbercage==0) begin
                           divide0 = 1;
                        end
                        else begin
                           temp = temp % numbercage;
                        end
                     end
                  endcase
                  
                  if((temp > 999999)||(temp < -99999)) begin
                     overflow = 1;
                  end
                  
                  if (divide0 == 1 || overflow == 1 || eof == 1) begin
                     set_no1 <= 16;
                     set_no2 <= 17;
                     set_no3 <= 17;
                     set_no4 <= 30;
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 0;
                     divide0 = 0;
                     temp = 0;
                     numbercage = 0;
                     more = 0;
                     overflow = 0;
                     eof = 0;
                  end
                  else begin
                     set_no1 <= 30;
                     set_no2 <= 15;   //d
                     set_no3 <= 1;   //1
                     set_no4 <= 21;   //v
                     set_no5 <= 30;
                     set_no6 <= 30;
                     opcage = 4;
                  end
               end
               else begin
                  set_no1 <= 30;      //mod
                  set_no2 <= 17;   //r
                  set_no3 <= 19;   //n
                  set_no4 <= 0;   //0
                  set_no5 <= 15;   //d
                  set_no6 <= 30;
                  opcage = 5;
                  more = 0;
               end
               
               sw_status <= sw_start;
            end
         endcase
      end
   end
   
   // 7-segment.
   always @(set_no1) begin
      case (set_no1)
         0: seg_100000 <= 'b0011_1111; //0
         1: seg_100000 <= 'b0000_0110; //1 or small L or Large I
         2: seg_100000 <= 'b0101_1011; //2
         3: seg_100000 <= 'b0100_1111; //3
         4: seg_100000 <= 'b0110_0110; //4
         5: seg_100000 <= 'b0110_1101; //5
         6: seg_100000 <= 'b0111_1101; //6
         7: seg_100000 <= 'b0000_0111; //7 
         8: seg_100000 <= 'b0111_1111; //8
         9: seg_100000 <= 'b0110_0111; //9 or q
         10: seg_100000 <= 'b0111_1000; //t
         11: seg_100000 <= 'b0111_0011; //p
         12: seg_100000 <= 'b0111_0111; //A or R
         13: seg_100000 <= 'b0111_1100; //b
         14: seg_100000 <= 'b0011_1001; //C
         15: seg_100000 <= 'b0101_1110; //d
         16: seg_100000 <= 'b0111_1001; //E 
         17: seg_100000 <= 'b0101_0000; //r
         18: seg_100000 <= 'b0100_0000; //-
         19: seg_100000 <= 'b0101_0100; //n
         20: seg_100000 <= 'b0110_1101; //S
         21: seg_100000 <= 'b0001_1100; //u or v
         default: seg_100000 <= 'b0000_0000; //off
      endcase
   end
   
   always @(set_no2) begin
      case (set_no2)
         0: seg_10000 <= 'b0011_1111;
         1: seg_10000 <= 'b0000_0110;
         2: seg_10000 <= 'b0101_1011;
         3: seg_10000 <= 'b0100_1111;
         4: seg_10000 <= 'b0110_0110;
         5: seg_10000 <= 'b0110_1101;
         6: seg_10000 <= 'b0111_1101;
         7: seg_10000 <= 'b0000_0111;
         8: seg_10000 <= 'b0111_1111;
         9: seg_10000 <= 'b0110_0111;
         10: seg_10000 <= 'b0111_1000;
         11: seg_10000 <= 'b0111_0011;
         12: seg_10000 <= 'b0111_0111;
         13: seg_10000 <= 'b0111_1100;
         14: seg_10000 <= 'b0011_1001;
         15: seg_10000 <= 'b0101_1110;
         16: seg_10000 <= 'b0111_1001;
         17: seg_10000 <= 'b0101_0000;
         18: seg_10000 <= 'b0100_0000;
         19: seg_10000 <= 'b0101_0100;
         20: seg_10000 <= 'b0110_1101; //S
         21: seg_10000 <= 'b0001_1100; //u
         default: seg_10000 <= 'b0000_0000;
      endcase
   end
   always @(set_no3) begin
      case (set_no3)
         0: seg_1000 <= 'b0011_1111;
         1: seg_1000 <= 'b0000_0110;
         2: seg_1000 <= 'b0101_1011;
         3: seg_1000 <= 'b0100_1111;
         4: seg_1000 <= 'b0110_0110;
         5: seg_1000 <= 'b0110_1101;
         6: seg_1000 <= 'b0111_1101;
         7: seg_1000 <= 'b0000_0111;
         8: seg_1000 <= 'b0111_1111;
         9: seg_1000 <= 'b0110_0111;
         10: seg_1000 <= 'b0111_1000;
         11: seg_1000 <= 'b0111_0011;
         12: seg_1000 <= 'b0111_0111;
         13: seg_1000 <= 'b0111_1100;
         14: seg_1000 <= 'b0011_1001;
         15: seg_1000 <= 'b0101_1110;
         16: seg_1000 <= 'b0111_1001;
         17: seg_1000 <= 'b0101_0000;
         18: seg_1000 <= 'b0100_0000;
         19: seg_1000 <= 'b0101_0100;
         20: seg_1000 <= 'b0110_1101; //S
         21: seg_1000 <= 'b0001_1100; //u
         default: seg_1000 <= 'b0000_0000;
      endcase
   end
   always @(set_no4) begin
      case (set_no4)
         0: seg_100 <= 'b0011_1111;
         1: seg_100 <= 'b0000_0110;
         2: seg_100 <= 'b0101_1011;
         3: seg_100 <= 'b0100_1111;
         4: seg_100 <= 'b0110_0110;
         5: seg_100 <= 'b0110_1101;
         6: seg_100 <= 'b0111_1101;
         7: seg_100 <= 'b0000_0111;
         8: seg_100 <= 'b0111_1111;
         9: seg_100 <= 'b0110_0111;
         10: seg_100 <= 'b0111_1000;
         11: seg_100 <= 'b0111_0011;
         12: seg_100 <= 'b0111_0111;
         13: seg_100 <= 'b0111_1100;
         14: seg_100 <= 'b0011_1001;
         15: seg_100 <= 'b0101_1110;
         16: seg_100 <= 'b0111_1001;
         17: seg_100 <= 'b0101_0000;
         18: seg_100 <= 'b0100_0000;
         19: seg_100 <= 'b0101_0100;
         20: seg_100 <= 'b0110_1101; //S
         21: seg_100 <= 'b0001_1100; //u
         default: seg_100 <= 'b0000_0000;
      endcase
   end
   always @(set_no5) begin
      case (set_no5)
         0: seg_10 <= 'b0011_1111;
         1: seg_10 <= 'b0000_0110;
         2: seg_10 <= 'b0101_1011;
         3: seg_10 <= 'b0100_1111;
         4: seg_10 <= 'b0110_0110;
         5: seg_10 <= 'b0110_1101;
         6: seg_10 <= 'b0111_1101;
         7: seg_10 <= 'b0000_0111;
         8: seg_10 <= 'b0111_1111;
         9: seg_10 <= 'b0110_0111;
         10: seg_10 <= 'b0111_1000;
         11: seg_10 <= 'b0111_0011;
         12: seg_10 <= 'b0111_0111;
         13: seg_10 <= 'b0111_1100;
         14: seg_10 <= 'b0011_1001;
         15: seg_10 <= 'b0101_1110;
         16: seg_10 <= 'b0111_1001;
         17: seg_10 <= 'b0101_0000;
         18: seg_10 <= 'b0100_0000;
         19: seg_10 <= 'b0101_0100;
         20: seg_10 <= 'b0110_1101; //S
         21: seg_10 <= 'b0001_1100; //u
         default: seg_10 <= 'b0000_0000;
      endcase
   end
   always @(set_no6) begin
      case (set_no6)
         0: seg_1 <= 'b0011_1111;
         1: seg_1 <= 'b0000_0110;
         2: seg_1 <= 'b0101_1011;
         3: seg_1 <= 'b0100_1111;
         4: seg_1 <= 'b0110_0110;
         5: seg_1 <= 'b0110_1101;
         6: seg_1 <= 'b0111_1101;
         7: seg_1 <= 'b0000_0111;
         8: seg_1 <= 'b0111_1111;
         9: seg_1 <= 'b0110_0111;
         10: seg_1 <= 'b0111_1000;
         11: seg_1 <= 'b0111_0011;
         12: seg_1 <= 'b0111_0111;
         13: seg_1 <= 'b0111_1100;
         14: seg_1 <= 'b0011_1001;
         15: seg_1 <= 'b0101_1110;
         16: seg_1 <= 'b0111_1001;
         17: seg_1 <= 'b0101_0000;
         18: seg_1 <= 'b0100_0000;
         19: seg_1 <= 'b0101_0100;
         20: seg_1 <= 'b0110_1101; //S
         21: seg_1 <= 'b0001_1100; //u
         default: seg_1 <= 'b0000_0000;
      endcase
   end
   
// fnd_clk. output.
   always @(posedge fnd_clk) begin
      fnd_cnt <= fnd_cnt + 1;
      case (fnd_cnt)
         5: begin
            fnd_d <= seg_100000;
            fnd_s <= 'b0001_1111;
         end
         4: begin
            fnd_d <= seg_10000;
            fnd_s <= 'b0010_1111;
         end
         3: begin
            fnd_d <= seg_1000;
            fnd_s <= 'b0011_0111;
         end
         2: begin
            fnd_d <= seg_100;
            fnd_s <= 'b0011_1011;
         end
         1: begin
            fnd_d <= seg_10;
            fnd_s <= 'b0011_1101;
         end
         0: begin
            fnd_d <= seg_1;
            fnd_s <= 'b0011_1110;
         end
      endcase
   end
   
endmodule