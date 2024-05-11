

module A_AES_128 ( clk ,In , Key ,  Out , Seg1 , Seg2 , Seg3 , LED);
input clk;
input [127:0] In;
input [127:0] Key ;

output [127:0] Out; 
output [6:0] Seg1;
output [6:0] Seg2;
output [6:0] Seg3;
output LED;


wire led;
wire[127:0] Outcipher;
wire [127:0] Outdecipher;
reg [7:0]count;
reg [127:0] theoutput;

reg flag;

wire [128*(10+1)-1:0] RoundKeys;



Showing_LS_Byte BCD (Out[7:0], Seg1 , Seg2 , Seg3 );

cipherComp K1(clk ,  In , Key , Outcipher, led);
deciphertComp K2 (clk , Outcipher, Key , Outdecipher, led);



initial begin
count=8'd0;
end
always @ (posedge clk )
begin 
if (count == 0)
begin
theoutput <= In;
count = count+1;
end
else if (count <=10 )
begin
theoutput<=Outcipher;
count = count+1;
end
else if (count == 11)
begin
theoutput<=Outcipher;
count = count+1;
end
else if (count == 12)
begin 
theoutput <= Outdecipher;
count = count +1 ;
end 
else if (count <= 21)
begin
theoutput<=Outdecipher;
count = count +1;
end
else if (count == 22)
begin
theoutput<=Outdecipher;
count = count +1;
end
$display("round = %d , Out =%h ,theoutput=%h",count,Out,theoutput);
end
assign Out = theoutput;
assign LED =led;

endmodule

