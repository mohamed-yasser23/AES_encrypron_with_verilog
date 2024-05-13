
module decryptRound (statePrev , RoundKey , stateNext);
input [127:0] RoundKey;
input[127:0] statePrev;
output [127:0] stateNext;

wire [127:0] OutINVSUB ;
wire [127:0] OutINVSHIFT;
//wire [127:0] OutINVMix ;
wire [127:0] OutADK;

Invshiftrows S2 ( statePrev , OutINVSHIFT);
inverseSubBytes S1 ( OutINVSHIFT, OutINVSUB );
addRoundKey S3(OutINVSUB , RoundKey  , OutADK);
INVMixCol s4(OutADK,stateNext);
///assign stateNext =OutINVMix;
endmodule