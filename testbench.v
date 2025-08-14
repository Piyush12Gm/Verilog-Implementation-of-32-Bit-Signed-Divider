module testsdiv;
  parameter N = 12;
  reg[31:0] dividendarr[1:N];
  reg[15:0] divisorarr[1:N];
  //inputs to sdiv module should be reg types
  reg CLK;
  reg St;
  reg[15:0] Dbus;
  //outputs from sdiv module should be wire types
  wire[15:0] Quotient;
  wire[15:0] Remainder;
  wire V;
  wire Rdy;
  reg[15:0] Divisor;
    reg[31:0] Dividend;
    reg[3:0] Count;
    reg[31:0] dividendarr_tmp;
    reg [15:0] quotientarr[1:N];
    reg [15:0] remainderarr[1:N];
    integer i;
    always
    begin
     #10 CLK <= ~CLK;
    end
    initial
    begin
      //initialization of dividend array
      dividendarr[1] = 32'h0000006F;
      dividendarr[2] = 32'h07FF00BB;
      dividendarr[3] = 32'hFFFFFE08;
      dividendarr[4] = 32'hFF80030A;
      dividendarr[5] = 32'h3FFF8000;
      dividendarr[6] = 32'h3FFF7FFF;
      dividendarr[7] = 32'hC0008000;
      dividendarr[8] = 32'hC0008000;
      dividendarr[9] = 32'hC0008001;
      dividendarr[10] = 32'h00000000;
      dividendarr[11] = 32'hFFFFFFFF;
      dividendarr[12] = 32'hFFFFFFFF;
      //initialization of divisor array
      divisorarr[1] = 16'h0007;   
      divisorarr[2] = 16'hE005;
      divisorarr[3] = 16'h001E;
      divisorarr[4] = 16'hEFFA;
      divisorarr[5] = 16'h7FFF;
      divisorarr[6] = 16'h7FFF;
      divisorarr[7] = 16'h7FFF;
      divisorarr[8] = 16'h8000;
      divisorarr[9] = 16'h7FFF;
      divisorarr[10] = 16'h0001;
      divisorarr[11] = 16'h7FFF;
      divisorarr[12] = 16'h0000;
      //initialization of quotient array
      quotientarr[1] = 16'h000F;   
      quotientarr[2] = 16'hBFFE;
      quotientarr[3] = 16'hFFF0;
      quotientarr[4] = 16'h07FC;
      quotientarr[5] = 16'h0000;
      quotientarr[6] = 16'h7FFF;
      quotientarr[7] = 16'h0000;
      quotientarr[8] = 16'h7FFF;
      quotientarr[9] = 16'h8001;
      quotientarr[10] = 16'h0000;
      quotientarr[11] = 16'h0000;
      quotientarr[12] = 16'h0002;
      //initialization of remainder array
      remainderarr[1] = 16'h0006;   
      remainderarr[2] = 16'h00C5;
      remainderarr[3] = 16'hFFE8;
      remainderarr[4] = 16'hF2F2;
      remainderarr[5] = 16'h7FFF;
      remainderarr[6] = 16'h7FFE;
      remainderarr[7] = 16'h7FFF;
      remainderarr[8] = 16'h0000;
      remainderarr[9] = 16'h8002;
      remainderarr[10] = 16'h0000;
      remainderarr[11] = 16'hFFFF;
      remainderarr[12] = 16'h0000; 
      CLK = 0;
      Count = 0;
    @(posedge CLK);
    @(negedge CLK);
    for(i = 1 ; i <= N ; i = i + 1)
    begin
      St = 1'b1;
      dividendarr_tmp = dividendarr[i];
      Dbus = dividendarr_tmp[31:16];
      @(posedge CLK);
      Dbus = dividendarr_tmp[15:0];
      @(posedge CLK);
      Dbus = divisorarr[i];
      St = 1'b0;
      Dividend = dividendarr_tmp[31:0];
      Divisor = divisorarr[i];
      @(posedge Rdy);
      Count = i;
       if(quotientarr[i] == Quotient)
        begin
        $display("quotient[%0d] is correct",i);
        end
       else
        begin
        $display("quotient[%0d] is wrong",i);
        end
       if(remainderarr[i] == Remainder)
        begin
        $display("remainder[%0d] is correct",i);
        end
       else
        begin
        $display("remainder[%0d] is wrong",i);
        end
      end
      $display("TESTS DONE");
    end
       sdiv sdiv1(CLK, St, Dbus, Quotient, Remainder, V, Rdy);
endmodule
