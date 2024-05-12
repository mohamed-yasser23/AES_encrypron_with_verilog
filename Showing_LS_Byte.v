module add3(in,out);
input [3:0] in;
output [3:0] out;
reg [3:0] out;
always @(in)
case(in)
4'b0000:out<=4'b0000;
4'b0001:out<=4'b0001;
4'b0010:out<=4'b0010;
4'b0011:out<=4'b0011;
4'b0100:out<=4'b0100;
4'b0101:out<=4'b1000;
4'b0110:out<=4'b1001;
4'b0111:out<=4'b1010;
4'b1000:out<=4'b1011;
4'b1001:out<=4'b1100;
default:out<=4'b0000;
endcase
endmodule

module binary_to_BCD(A,ONES,TENS,HUNDREDS);
input [7:0] A;
output [3:0] ONES, TENS;
output [1:0] HUNDREDS;
wire [3:0] c1,c2,c3,c4,c5,c6,c7;
wire [3:0] d1,d2,d3,d4,d5,d6,d7;
assign d1 = {1'b0,A[7:5]};
assign d2 = {c1[2:0],A[4]};
assign d3 = {c2[2:0],A[3]};
assign d4 = {c3[2:0],A[2]};
assign d5 = {c4[2:0],A[1]};
assign d6 = {1'b0,c1[3],c2[3],c3[3]};
assign d7 = {c6[2:0],c4[3]};
add3 m1(d1,c1);
add3 m2(d2,c2);
add3 m3(d3,c3);
add3 m4(d4,c4);
add3 m5(d5,c5);
add3 m6(d6,c6);
add3 m7(d7,c7);
assign ONES = {c5[2:0],A[0]};
assign TENS = {c7[2:0],c5[3]};
assign HUNDREDS = {c6[3],c7[3]};
endmodule


module SSD	(
  input      [3:0] bcd,
  output reg [6:0] seg
);

always @(*) begin
  case(bcd)
    4'h0   : seg = 7'b1000000;
    4'h1   : seg = 7'b1111001;
    4'h2   : seg = 7'b0100100;
    4'h3   : seg = 7'b0110000;
    4'h4   : seg = 7'b0011001;
    4'h5   : seg = 7'b0010010;
    4'h6   : seg = 7'b0000010;
    4'h7   : seg = 7'b1111000;
    4'h8   : seg = 7'b0000000;
    4'h9   : seg = 7'b0011000;
    default: seg = 7'bXXXXXXX;
  endcase
end
endmodule

module Showing_LS_Byte(input clk,
input  [7:0] _byte,
output [6:0] Seg1,
output [6:0] Seg2,
output [6:0] Seg3
);
wire [1:0] H;
wire [3:0] T;
wire [3:0] O;
binary_to_BCD encoder(_byte,O,T,H);
SSD S1(O,Seg1);
SSD S2(T,Seg2);
SSD S3({1'b0,1'b0,H},Seg3);
always @(posedge clk) begin 
  $display ("Units= %d tens=%d Hunds= %d",O,T,H);
end

endmodule