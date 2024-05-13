module decipherDE # (parameter Nk = 4 , parameter Nr = 10)(clk,Mode1,Mode2,Mode3,reset,in,out,key);
input reset;
input clk;
input Mode1;
  input Mode2;
 input Mode3;
input [127:0] in;
input [(32*Nk)-1:0] key;
output [127:0] out;
reg [3:0] count = 4'd0;
reg [127:0] reg_in,temp;
wire [127:0] ST4,ST5,ST6,invOutSHIFT,invOutSUB;
wire [128*(Nr+1)-1:0] RoundKeys;

Key_Generator_AES   #(Nk,Nr)  k (key,RoundKeys);
addRoundKey K12(in , RoundKeys[127:0] , ST4);

decryptRound DE(reg_in,RoundKeys[(((128*(Nr+1))-1)-128*(Nr-count)) -:128],ST5);

Invshiftrows invrow (reg_in,invOutSHIFT);
inverseSubBytes invsub (invOutSHIFT,invOutSUB);
addRoundKey invaddkey (invOutSUB,RoundKeys[(128*(Nr+1)-1) -: 128],ST6);

always @ (posedge clk,posedge reset) begin
$display ("ST4 = %h,ST5 = %h,ST6 = %h", ST4,ST5,ST6);
$display ("invRound = %d", count);

if(reset)  begin

    count <= 4'd0;
	 temp<=128'h0;
end
else begin
if(count==4'd0) begin
                if( Mode1 ||  Mode2 ||  Mode3) begin
    reg_in<=ST4;
    temp<=ST4;
    count<=count + 4'd1;
                end 
                else begin

 //reg_in<=ST4;
   // temp<=ST4;
    count<=count ;

                end
end
else if(count<Nr) begin
                    if( Mode1 ||  Mode2 ||  Mode3) begin

    reg_in<=ST5;
    temp<=ST5;
    count<=count + 4'd1;
                    end
                    else begin
// reg_in<=ST5;
  //  temp<=ST5;
    count<=count ;

                    end
end
else if(count==Nr) begin
     if( Mode1 ||  Mode2 ||  Mode3) begin

    reg_in<=ST5;
    temp<=ST6;
    count <= 4'd0;
     end
     else begin
       // reg_in<=ST5;
   // temp<=ST6;
    count <= count;
     end
end
end
end
assign out=temp;

endmodule