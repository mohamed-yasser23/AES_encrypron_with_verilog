
module Shiftrows(input [0:127] in, output [0:127] shiftedin);
    // 1st row: no shifting
    assign shiftedin[0+:8] = in[0+:8];
    assign shiftedin[32+:8] = in[32+:8];
    assign shiftedin[64+:8] = in[64+:8];
    assign shiftedin[96+:8] = in[96+:8];

    // 2nd row: shifting by one byte to the left
    assign shiftedin[8+:8] = in[40+:8];
    assign shiftedin[40+:8] = in[72+:8];
    assign shiftedin[72+:8] = in[104+:8];
    assign shiftedin[104+:8] = in[8+:8];

    // 3rd row: shifting by 2 bytes to the left
    assign shiftedin[16+:8] = in[80+:8];
    assign shiftedin[48+:8] = in[112+:8];
    assign shiftedin[80+:8] = in[16+:8];
    assign shiftedin[112+:8] = in[48+:8];

    // 4th row: shifting by 3 bytes to the left
    assign shiftedin[24+:8] = in[120+:8];
    assign shiftedin[56+:8] = in[24+:8];
    assign shiftedin[88+:8] = in[56+:8];
    assign shiftedin[120+:8] = in[88+:8];
endmodule