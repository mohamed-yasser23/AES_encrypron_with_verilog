
module ciphermain ( clk ,In , Key , Out );
input clk;
input [127:0] In;
input [127:0] Key ;
output [127:0] Out; 

reg [127:0] reg_state [9:0];
wire [127:0] state[10:0];
//reg[127:0] nextIn;
//wire [127:0] RoundOut;

wire [127:0] OutSUB ;
wire [127:0] OutSHIFT ;
wire [127:0] OutMix ;
wire [128*(10+1)-1:0] RoundKeys;
integer i;
initial 
i=1;


Key_Generator K1 (Key , RoundKeys);

addRoundKey K2(In , RoundKeys[(128*(10+1)-1) -: 128] , state[0]);
encryptRound K3(reg_state[0],RoundKeys[(((128*(10+1))-1)-128*1) -:128], state[1]);
encryptRound K4(reg_state[1],RoundKeys[(((128*(10+1))-1)-128*2) -:128], state[2]);
encryptRound K5(reg_state[2],RoundKeys[(((128*(10+1))-1)-128*3) -:128], state[3]);
encryptRound K6(reg_state[3],RoundKeys[(((128*(10+1))-1)-128*4) -:128], state[4]);
encryptRound K7(reg_state[4],RoundKeys[(((128*(10+1))-1)-128*5) -:128], state[5]);
encryptRound K8(reg_state[5],RoundKeys[(((128*(10+1))-1)-128*6) -:128], state[6]);
encryptRound K9(reg_state[6],RoundKeys[(((128*(10+1))-1)-128*7) -:128], state[7]);
encryptRound K10(reg_state[7],RoundKeys[(((128*(10+1))-1)-128*8) -:128], state[8]);
encryptRound K11(reg_state[8],RoundKeys[(((128*(10+1))-1)-128*9) -:128], state[9]);


subBytes sub (reg_state[9],OutSUB);
Shiftrows row (OutSUB,OutSHIFT);
addRoundKey addkey (OutSHIFT,RoundKeys[127:0],state[10]);

assign Out = state[i-1];
always @ (posedge clk )
begin 
if ( i <=10 ) 
begin

reg_state[i-1] = state[i-1];

i=i+1;
end

 
end
endmodule

module cipher_tb;
reg clk;
reg [127:0] In;
reg [127:0] Key;
wire [127:0] Out;


ciphermain uut (clk, In, Key, Out);
initial
begin
clk=0;
In=128'h3243f6a8_885a308d_313198a2_e0370734;
Key=128'h2b7e1516_28aed2a6_abf71588_09cf4f3c;
$monitor("out = %h\n",Out);
end 

always 
begin
#50  clk= !clk ; 
end

endmodule

