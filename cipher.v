module cipherEN(clk,in,out,key);

input clk;
input [127:0] in;
input [127:0] key;
output [127:0] out;
reg [3:0] count = 0;
reg [127:0] reg_in,temp;
wire [127:0] ST1,ST2,ST3,OutSUB,OutSHIFT;
wire [128*(10+1)-1:0] RoundKeys;

Key_Generator k(key,RoundKeys);
addRoundKey ad(in,key ,ST1);

encryptRound En(reg_in,RoundKeys[(((128*(10+1))-1)-128*count) -:128],ST2);

subBytes sub (reg_in,OutSUB);
Shiftrows row (OutSUB,OutSHIFT);
addRoundKey addkey (OutSHIFT,RoundKeys[127:0],ST3);

always @ (posedge clk) begin
$display ("ST1 = %h,ST2 = %h,ST3 = %h", ST1,ST2,ST3);
if(count==4'd0) begin
    reg_in<=ST1;
    temp<=ST1;
    count<=count +  4'd1;
end
else if(count<4'd10 &&count > 4'd0 ) begin
    reg_in<=ST2;
    temp<=ST2;
    count<=count + 4'd1;
end
else if(count==4'd10) begin
    reg_in<=ST2;
    temp<=ST3;
    count<= 4'd0;
end
end
assign out=temp;

endmodule