module cipherComp #( parameter Nr = 10)  (clk ,  In , RoundKeys, Out, LeD);
input clk;
input [127:0] In;
input [128*(Nr+1)-1:0] RoundKeys ;
output reg [127:0] Out; 
output LeD;
reg flag;

reg [127:0] reg_state ;
reg [127:0] theout;
wire [127:0] state1,state2,state3;
wire [127:0] OutSUB ;
wire [127:0] OutSHIFT ;
wire [127:0] OutMix ;
reg [7:0]count;



addRoundKey K2(In , RoundKeys[(128*(Nr+1)-1) -: 128] , state1);
encryptRound K3(reg_state,RoundKeys[(((128*(Nr+1))-1)-128*(count)) -:128], state2);

subBytes sub (reg_state,OutSUB);
Shiftrows row (OutSUB,OutSHIFT);
addRoundKey addkey (OutSHIFT,RoundKeys[127:0],state3);


initial
begin
count = 8'd0;
end

always @ ( state1 , state2 , state3 ) 
begin
if (count < 1 ) begin
theout<= state1;
flag=0;
end
else if (count < Nr)
begin
theout<= state2;
flag=0;
end
else if (count == Nr)
begin
theout <= state3;
flag = 1;
end
end 
always@(posedge clk)
begin


if (count<1)
begin
reg_state <= state1;
count = count+1;
end
else if (count < Nr)
begin
reg_state <= state2; 
count = count +1;
end
else if (count == Nr)
begin
reg_state <= state3;
count = count +1;
end
end





assign LeD = flag;
assign Out = theout;
endmodule