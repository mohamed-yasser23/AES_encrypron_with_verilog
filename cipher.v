module cipherEN # (parameter Nk = 4 , parameter Nr = 10)(clk,Mode1,Mode2,Mode3,reset,in,out,key);
////
input clk;
input reset;
input Mode1;
  input Mode2;
 input Mode3;
input [127:0] in;
input [(32*Nk)-1:0] key;
output [127:0] out;
reg [3:0] count = 0;
reg [127:0] reg_in,temp;
wire [127:0] ST1,ST2,ST3,OutSUB,OutSHIFT;
wire [128*(Nr+1)-1:0] RoundKeys;

Key_Generator_AES #(Nk , Nr) k (key,RoundKeys);

addRoundKey ad(in,key[(32*Nk-1)-:128] ,ST1);

encryptRound En(reg_in,RoundKeys[(((128*(Nr+1))-1)-128*count) -:128],ST2);

subBytes sub (reg_in,OutSUB);
Shiftrows row (OutSUB,OutSHIFT);
addRoundKey addkey (OutSHIFT,RoundKeys[127:0],ST3);

always @ (posedge clk,posedge reset) begin
$display ("ST1 = %h,ST2 = %h,ST3 = %h", ST1,ST2,ST3);

if(reset)  begin
    count<= 4'd0;

	temp<=128'h0;

end 
else begin
  if(count==4'd0) begin
    if( Mode1 ||  Mode2 ||  Mode3) begin
         reg_in<=ST1;
    temp<=ST1;
    count<=count +  4'd1;

     end
     else begin
        //reg_in<=ST1;
    //temp<=ST1;
    count<=count ;

     end
   end
else if(count< Nr &&count > 4'd0 ) begin
    if( Mode1 ||  Mode2 ||  Mode3) begin
    reg_in<=ST2;
    temp<=ST2;
    count<=count + 4'd1;
    end
         else begin
    //reg_in<=ST2;
    //temp<=ST2;
    count<=count ;
    end
end
else if(count== Nr) begin
            if( Mode1 ||  Mode2 ||  Mode3) begin
    reg_in<=ST2;
    temp<=ST3;
    count<= 4'd0;
            end
   else begin
    // reg_in<=ST2;
    //temp<=ST3;
    count<= count;
 
end
end
end
end
assign out=temp;

endmodule