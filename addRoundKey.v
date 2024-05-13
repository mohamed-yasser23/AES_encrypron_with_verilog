module addRoundKey(data, key ,out);

input [127:0] data;
input [127:0] key;
output [127:0] out;

assign out = key ^ data;

//always@(*)
//$display("input=%h \t key=%h \t Output = %h \n\n" , data , key , out);

endmodule
