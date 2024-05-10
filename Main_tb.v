
module Main_tb( input  clk ,output[6:0] Seg1 ,output[6:0] Seg2 ,output[6:0] Seg3 ,output LED);
//reg clk;
reg clks;

reg [127:0] In;
reg [127:0] Key1;
//reg [191:0] Key2;
//reg [255:0] Key3;
wire [127:0] Out;
wire [6:0] SEG1;
wire [6:0] SEG2;
wire [6:0] SEG3;
wire Led;

always @(*) begin
clks=clk;
end 


initial
begin
//clk=0;
In=128'h00112233445566778899aabbccddeeff;
Key1=128'h000102030405060708090a0b0c0d0e0f;
//Key2=192'h000102030405060708090a0b0c0d0e0f1011121314151617;
//Key3=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
$monitor("out = %h\nSEG1 = %b\nSEG2 = %b\nSEG3 = %b\nLED = %b\n\n",Out , Seg1 , Seg2 , Seg3 , LED);
end 

A_AES_128 unit (clks , In , Key1 , Out , SEG1 , SEG2 , SEG3 , Led);
//AES_192 uut2 (clk , In , Key2 , Out , Seg1 , Seg2 , Seg3 , LED);
//AES_256 uut3 (clk , In , Key3 , Out , Seg1 , Seg2 , Seg3 , LED); 

assign Seg1=SEG1,Seg2=SEG2,Seg3=SEG3,LED=Led;
// always 
// begin
//  #50  clk= !clk ; 
//   end

endmodule

module Main_tb_modelsim( clk,LED);     //for simualtion
input clk;
wire [127:0] In=128'h00112233445566778899aabbccddeeff;
wire [127:0] Key=128'h000102030405060708090a0b0c0d0e0f; 
//reg [191:0] Key2;
//reg [255:0] Key3;
wire [127:0] Out;
//output [6:0] Seg1;
//output [6:0] Seg2;
//output [6:0] Seg3;
output LED;

cipherComp uut (clk, In, Key ,Out , LED);
initial
begin
//clk=0;
//In=128'h00112233445566778899aabbccddeeff;
//Key=128'h000102030405060708090a0b0c0d0e0f;
//Key2=192'h000102030405060708090a0b0c0d0e0f1011121314151617;
//Key3=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
$monitor("out = %h \nLED = %b\n\n",Out , LED);
end 



endmodule
