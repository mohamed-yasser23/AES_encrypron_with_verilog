
module Main_tb_modelsim;
reg clk;
reg [1:0] N;
reg [127:0] In;
reg [127:0] Key1;
reg [191:0] Key2;
reg [255:0] Key3;
wire [127:0] Out;
wire [6:0] Seg1;
wire [6:0] Seg2;
wire [6:0] Seg3;
wire LED;


//AES_128 uut1 (clk , In , Key1 , Out , Seg1 , Seg2 , Seg3 , LED);
//AES_192 uut2 (clk , In , Key2 , Out , Seg1 , Seg2 , Seg3 , LED);
AES_256 uut3 (clk , In , Key3 , Out , Seg1 , Seg2 , Seg3 , LED); 


initial
begin
clk=0;
N=2'b01;
In=128'h00112233445566778899aabbccddeeff;
Key1=128'h000102030405060708090a0b0c0d0e0f;
Key2=192'h000102030405060708090a0b0c0d0e0f1011121314151617;
Key3=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
$monitor("out = %h\nSEG1 = %b\nSEG2 = %b\nSEG3 = %b\nLED = %b\n\n",Out , Seg1 , Seg2 , Seg3 , LED);
end 

always 
begin
#50  clk= !clk ; 
end

endmodule

module Main_tb( clk,Seg1 ,Seg2 , Seg3 ,LED);     //for simualtion
input clk;
reg [127:0] In;
reg [127:0] Key; 
//reg [191:0] Key2;
//reg [255:0] Key3;
wire [127:0] Out;
output [6:0] Seg1;
output [6:0] Seg2;
output [6:0] Seg3;
output LED;

AES_128 uut (clk, In, Key ,Out ,Seg1,Seg2,Seg3,LED);
initial
begin
//clk=0;
In=128'h00112233445566778899aabbccddeeff;
Key=128'h000102030405060708090a0b0c0d0e0f;
//Key2=192'h000102030405060708090a0b0c0d0e0f1011121314151617;
//Key3=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
//$monitor("out = %h\nSEG1 = %b\nSEG2 = %b\nSEG3 = %b\nLED = %b\n\n",Out , Seg1 , Seg2 , Seg3 , LED);
end 



endmodule
