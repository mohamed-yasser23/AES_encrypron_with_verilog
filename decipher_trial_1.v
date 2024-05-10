module deciphrtComp (clk ,  In , Key , Out, LED);
input clk;
input [127:0] In;
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

addRoundKey K12(reg_state , RoundKeys[127:0] , state1);
decryptRound K13(reg_state,RoundKeys[(((128*(10+1))-1)-128*(21-(count-1))) -:128], state2);


Invshiftrows invrow (reg_state,invOutSHIFT);
inverseSubBytes invsub (invOutSHIFT,invOutSUB);
addRoundKey invaddkey (invOutSUB,RoundKeys[(128*(10+1)-1) -: 128],state3);



initial
begin
count = 8'd0;
end

always@(posedge clk)
begin
if (count == 0)
begin 
theout <= In;
count = count+1;
flag = 0;
end
//$display("round = %d ,reg_state =%h , state =%h ,",count,Out,state1);
if (count==1)
begin
reg_state <= state1;
theout <= state1;
count = count+1;
flag = 0;
end
else if (count <=10)
begin
reg_state <= state2; 
theout <= state2;
flag=0;
count = count +1;
end
else if (count == 11)
begin
reg_state <= state3;
theout <= state3;
flag = 1;
count = count +1;
end
end

// always@ (posedge clk)
// begin
	
// if (count == 1 )
// begin
// theout <= state1;
// count = count+1;
// flag = 0;
// end
// else if (count <= 10) 
// begin 
// theout <= state2;
// flag=0;
// count = count +1;
// end
// else if (count == 11)
// begin
// theout <= state3;
// flag = 1;
// count = count +1;
// end
// end



assign LED = flag;
assign Out = theout;
endmodule