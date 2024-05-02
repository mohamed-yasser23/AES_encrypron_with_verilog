
module decryptRound (statePrev , RoundKey , stateNext);
input [127:0] RoundKey;
input[127:0] statePrev;
output [127:0] stateNext;

wire [127:0] OutINVSUB ;
wire [127:0] OutINVSHIFT;
wire [127:0] OutINVMix ;

Invshiftrows S2 ( statePrev , OutINVSHIFT);
inverseSubBytes S1 ( OutINVSHIFT, OutINVSUB );
addRoundKey S3(OutINVMix , RoundKey  , stateNext);
// inv mix columns

endmodule