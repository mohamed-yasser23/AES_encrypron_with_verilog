 module AES_main(clk,Seg1 ,Seg2 , Seg3 ,LED);
 input clk;
   output[6:0] Seg1;
   output[6:0] Seg2;
   output[6:0] Seg3;
   output reg LED;
   wire clks=clk;
   wire [127:0] pl =128'h00112233445566778899aabbccddeeff;
   wire [127:0] ky=128'h000102030405060708090a0b0c0d0e0f;
   wire [127:0] cOut;
   wire [127:0] DecOut;
   reg [127:0]  seg_DE ;
   reg [127:0] inpD;
   reg [4:0] Count = 5'd0;

   cipherEN  E(clks,pl,cOut,ky);
   decipherDE  D(clks,cOut,DecOut,ky);

   Showing_LS_Byte  S (clks , seg_DE[7:0] , Seg1 , Seg2 , Seg3);

   always @(*) begin 
    if(Count <= 5'd11) begin 
        seg_DE = cOut;
    end 
    else if(Count >5'd11 && Count <= 5'd22) begin 
        seg_DE = DecOut;
    end

   end 

   always@(posedge clk) begin
      $display ("count %d", Count);
      $display ("Cipher_out=%h",cOut);
      $display ("Decipher_out=%h",DecOut);


     
      //if( Count<5'd11) begin
      //  seg_DE <= cOut;
      //end else if(Count >5'd11 && Count<5'd22) begin
       // seg_DE <= DecOut;
      //end


      if(Count == 5'd11 ) begin 
        LED <= (cOut==pl) ? 1'b1:1'b0 ;
       // seg_DE <= cOut;
        Count<= Count + 5'd1;
      end
      else if(Count ==5'd22) begin 
        LED <= (DecOut==pl) ? 1'b1:1'b0 ;
       // seg_DE <= DecOut;
        Count <= 5'd0;
      end
      else begin 
        Count<= Count + 5'd1;
      end
        
      end
   endmodule
