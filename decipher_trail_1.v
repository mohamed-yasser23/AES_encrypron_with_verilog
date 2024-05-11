module deciphertComp (clk ,  cipher , Key , Out, LED);
input clk;
input [127:0] cipher;
input [127:0] Key ;
output reg [127:0] Out; 
output  LED;

reg flag;
reg [127:0] reg_state ;
reg [127:0] theout;
wire [127:0] state1,state2,state3;
wire [128*(10+1)-1:0] RoundKeys;
wire [127:0] invOutSUB ;
wire [127:0] invOutSHIFT ;
wire [127:0] invOutMix ;

reg [7:0]count;

Key_Generator K1 (Key , RoundKeys);

addRoundKey K12(cipher, RoundKeys[127:0] , state1);
decryptRound K13(reg_state,RoundKeys[(((128*(10+1))-1)-128*(21-(count))) -:128], state2);


Invshiftrows invrow (reg_state,invOutSHIFT);
inverseSubBytes invsub (invOutSHIFT,invOutSUB);
addRoundKey invaddkey (invOutSUB,RoundKeys[(128*(10+1)-1) -: 128],state3);



initial
begin
count = 8'd0;
end

always @ ( state1 , state2 , state3 ) 
begin
if (count < 12 ) 
theout<= state1;
else if (count <21)
theout<= state2;
else if (count == 21)
theout <= state3;
end 


always@(posedge clk)
begin
$display("round = %d ,reg_state =%h , state =%h ",count,Out,state1);
//$display("state3 =%h\n\n",state3);

if (count < 11)
begin
count = count +1;
end

else if (count==11)
begin
reg_state <= state1;
count = count+1;
flag = 0;
end
else if (count <=20)
begin
reg_state <= state2; 
flag=0;
count = count +1;
end
else if (count == 21)
begin
reg_state <= state3;
flag = 1;
count = count +1;
end
end


assign LED = flag;
assign Out = theout;
endmodule