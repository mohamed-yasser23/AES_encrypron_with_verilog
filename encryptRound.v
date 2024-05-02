module encryptRound (statePrev , RoundKey , stateNext);
input [127:0] RoundKey;
input[127:0] statePrev;
output [127:0] stateNext;

wire [127:0] OutSUB ;
wire [127:0] OutSHIFT;
wire [127:0] OutMix ;

subBytes S1 (statePrev , OutSUB );
Shiftrows S2 ( OutSUB , OutSHIFT);
mixColumns S4(OutSHIFT,OutMix);
addRoundKey S3(OutMix , RoundKey  , stateNext);


endmodule