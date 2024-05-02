module Invshiftrows(input [0:127] in, output [0:127] invshifted);
    // 1st row: No shifting
    assign invshifted[0+:8] = in[0+:8];
    assign invshifted[32+:8] = in[32+:8];
    assign invshifted[64+:8] = in[64+:8];
    assign invshifted[96+:8] = in[96+:8];

    // 2nd row: Shifted one byte to the right
    assign invshifted[8+:8] = in[104+:8];
    assign invshifted[40+:8] = in[8+:8];
    assign invshifted[72+:8] = in[40+:8];
    assign invshifted[104+:8] = in[72+:8];

    // 3rd row: Shifted two bytes to the right
    assign invshifted[16+:8] = in[80+:8];
    assign invshifted[48+:8] = in[112+:8];
    assign invshifted[80+:8] = in[16+:8];
    assign invshifted[112+:8] = in[48+:8];

    // 4th row: Shifted three bytes to the right
    assign invshifted[24+:8] = in[56+:8];
    assign invshifted[56+:8] = in[88+:8];
    assign invshifted[88+:8] = in[120+:8];
    assign invshifted[120+:8] = in[24+:8];
endmodule
