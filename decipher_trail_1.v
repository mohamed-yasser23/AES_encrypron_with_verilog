module deciphertComp #(parameter Nr = 10) (clk ,  cipher , RoundKeys , Out, LED);
input clk;
input [127:0] cipher;
input [128*(Nr+1)-1:0] RoundKeys ;
output reg [127:0] Out; 
output  LED;

reg flag;
reg [127:0] reg_state ;
reg [127:0] theout;
wire [127:0] state1,state2,state3;
wire [127:0] invOutSUB ;
wire [127:0] invOutSHIFT ;
wire [127:0] invOutMix ;

reg [7:0]count;


addRoundKey K12(cipher, RoundKeys[127:0] , state1);
decryptRound K13(reg_state,RoundKeys[(((128*(Nr+1))-1)-128*((2*Nr+1)-(count))) -:128], state2);


Invshiftrows invrow (reg_state,invOutSHIFT);
inverseSubBytes invsub (invOutSHIFT,invOutSUB);
addRoundKey invaddkey (invOutSUB,RoundKeys[(128*(Nr+1)-1) -: 128],state3);



initial
begin
count = 8'd0;
end

always @ ( state1 , state2 , state3 ) 
begin
if (count < Nr+2 ) begin
theout<= state1;
flag=0;
end
else if (count < (2*Nr +1 )) begin
theout<= state2;
flag=0;
end
else if (count == (2*Nr+1)) begin
theout <= state3;
flag = 1;
end
end 


always@(posedge clk)
begin
$display("round = %d ,reg_state =%h , state =%h ",count,Out,state2);
//$display("state3 =%h\n\n",state3);

if (count < Nr+1)
begin
count = count +1;
end
else if (count == Nr+1)
begin
reg_state <= state1;
count = count+1;
end
else if (count <=2*Nr)
begin
reg_state <= state2; 
count = count +1;
end
else if (count == 2*Nr+1)
begin
reg_state <= state3;
count = count +1;
end
end


assign LED = flag;
assign Out = theout;
endmodule