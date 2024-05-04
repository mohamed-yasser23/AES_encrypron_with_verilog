
module AES_128 ( clk ,In , Key ,  Out , Seg1 , Seg2 , Seg3 , LED);
input clk;
input [127:0] In;
input [127:0] Key ;

output [127:0] Out; 
output [6:0] Seg1;
output [6:0] Seg2;
output [6:0] Seg3;
output LED;

reg [127:0] reg_state [20:0];
wire [127:0] state[21:0];
reg flag;

wire [127:0] OutSUB ;
wire [127:0] OutSHIFT ;
wire [127:0] OutMix ;
wire [127:0] invOutSUB ;
wire [127:0] invOutSHIFT ;
wire [127:0] invOutMix ;

wire [128*(10+1)-1:0] RoundKeys;
integer i;
initial 
i=1;

Showing_LS_Byte BCD (state[i-1][7:0] , Seg1 , Seg2 , Seg3 );
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


addRoundKey K12(reg_state[10] , RoundKeys[127:0] , state[11]);
decryptRound K13(reg_state[11],RoundKeys[(((128*(10+1))-1)-128*9) -:128], state[12]);
decryptRound K14(reg_state[12],RoundKeys[(((128*(10+1))-1)-128*8) -:128], state[13]);
decryptRound K15(reg_state[13],RoundKeys[(((128*(10+1))-1)-128*7) -:128], state[14]);
decryptRound K16(reg_state[14],RoundKeys[(((128*(10+1))-1)-128*6) -:128], state[15]);
decryptRound K17(reg_state[15],RoundKeys[(((128*(10+1))-1)-128*5) -:128], state[16]);
decryptRound K18(reg_state[16],RoundKeys[(((128*(10+1))-1)-128*4) -:128], state[17]);
decryptRound K19(reg_state[17],RoundKeys[(((128*(10+1))-1)-128*3) -:128], state[18]);
decryptRound K20(reg_state[18],RoundKeys[(((128*(10+1))-1)-128*2) -:128], state[19]);
decryptRound K21(reg_state[19],RoundKeys[(((128*(10+1))-1)-128*1) -:128], state[20]);


Invshiftrows invrow (reg_state[20],invOutSHIFT);
inverseSubBytes invsub (invOutSHIFT,invOutSUB);
addRoundKey invaddkey (invOutSUB,RoundKeys[(128*(10+1)-1) -: 128],state[21]);

assign Out = state[i-1];
assign LED = flag;
always @ (posedge clk )
begin 



if ( i <10 ) 
begin
reg_state[i-1] = state[i-1];
i=i+1;
end
else if (i == 10)
begin
reg_state[i-1] = state[i-1];
i=i+1;
flag=1;
end  
else if (i<21)
begin 
reg_state[i-1] = state[i-1];
i=i+1;
flag=0;
end
else if (i==21)
begin 
reg_state[i-1] = state[i-1];
i=i+1;
flag=1;
end
//else
//i=1;               during runtime if pipeline is needed
end

endmodule

module Main_tb;
reg clk;

reg [127:0] In;
reg [127:0] Key;
wire [127:0] Out;
wire [6:0] Seg1;
wire [6:0] Seg2;
wire [6:0] Seg3;
wire LED;

AES_128 uut (clk, In, Key ,Out ,Seg1,Seg2,Seg3,LED);
initial
begin
clk=0;
In=128'h00112233445566778899aabbccddeeff;
Key=128'h000102030405060708090a0b0c0d0e0f;
$monitor("out = %h\nSEG1 = %b\nSEG2 = %b\nSEG3 = %b\nLED = %b\n\n",Out , Seg1 , Seg2 , Seg3 , LED);
end 

always 
begin
#50  clk= !clk ; 
end

endmodule

