

module A_AES_128 #(parameter Nk =4 , parameter Nr = 10)( clk ,In , Key ,  Out , Seg1 , Seg2 , Seg3 , LED);
input clk;
input [127:0] In;
input [127:0] Key ;

output [127:0] Out; 
output [6:0] Seg1;
output [6:0] Seg2;
output [6:0] Seg3;
output LED;


wire led1, led2;
reg flag;
wire[127:0] Outcipher;
wire [127:0] Outdecipher;
reg [7:0]count;
reg [127:0] theoutput;

wire [128*(Nr+1)-1:0] RoundKeys;

Key_Generator  #(Nk,Nr) K1 (Key , RoundKeys);

Showing_LS_Byte BCD (Out[7:0], Seg1 , Seg2 , Seg3 );

cipherComp #(Nr) K2(clk ,  In , RoundKeys , Outcipher, led1);
deciphertComp #(Nr) K3 (clk , Outcipher, RoundKeys , Outdecipher, led2);



initial 
begin
count=8'd0;
end


always @ (posedge clk)
begin 
if (count == 0)
begin
theoutput <= In;
count = count+1;
flag = led1;
end
else if (count <=Nr )
begin
theoutput<=Outcipher;
count = count+1;
flag = led1;
end
else if (count == Nr+1)
begin
theoutput<=Outcipher;
count = count+1;
flag = led1;
end
else if (count == Nr+2)
begin 
theoutput <= Outdecipher;
count = count +1 ;
flag = led2;
end 
else if (count <= (2*Nr+1))
begin
theoutput<=Outdecipher;
count = count +1;
flag = led2;
end
else if (count == (2*Nr+2))
begin
theoutput<=Outdecipher;
count = count +1;
flag = led2;
end
$display("round = %d , Out =%h ,theoutput=%h",count,Out,theoutput);
end
assign Out = theoutput;
assign LED =flag;

endmodule

