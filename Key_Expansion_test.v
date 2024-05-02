
module keyExpansion_tb;
reg [0:127] k1;
wire[1407:0] out1;


Key_Generator ks(k1,out1);


initial begin
$monitor("k= %h , out= %h",k1,out1);
k1=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
end
endmodule