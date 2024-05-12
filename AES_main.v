 module AES_N #(parameter Nk =4, parameter Nr = 10) (clk,reset,key ,LED , seg_DE);
 input clk;
 input reset;
 input [32*Nk-1:0]key;
   output reg LED;
   output reg [127:0]  seg_DE ;
   wire clks=clk;
   wire resets=reset;

   wire [127:0] pl =128'h00112233445566778899aabbccddeeff;

   wire [127:0] cOut;
   wire [127:0] DecOut;
   reg [127:0] inpD;
   reg [4:0] Count = 5'd0;



   cipherEN #(Nk ,Nr)E (clks,resets,pl,cOut,key);
   decipherDE #(Nk,Nr)D (clks,resets,cOut,DecOut,key);
              
   


   always @(*) begin 

    if(reset) begin

    seg_DE[7:0]=8'b0000_0000;
    end
    else begin
    if(Count <= Nr+1) begin 
        seg_DE = cOut;
        LED = (cOut==pl) ? 1'b1:1'b0 ;

    end 
    else if(Count >Nr+1 && Count <= 2*(Nr+1)) begin 
        seg_DE = DecOut;
        LED = (DecOut==pl) ? 1'b1:1'b0 ;
		  end
		  else if(Count>=(2*(Nr+1)+1)) begin 
		    seg_DE[7:0]=pl[7:0];
        
		  LED=1'b1;
		end

    end
    end

   always@(posedge clk,posedge reset) begin
	//if(Count!=(2*(Nr+1)+1)) begin 

      $display ("count %d", Count);
      $display ("Cipher_out=%h",cOut);
      $display ("Decipher_out=%h",DecOut);

     
      if(reset)  begin
        Count <= 5'd0;

      end
      else begin


      if(Count == Nr+1 ) begin 
        
        Count<= Count + 5'd1;
      end
      else if(Count ==2*(Nr+1)) 
      begin 
       // LED <= (DecOut==pl) ? 1'b1:1'b0 ;
        Count <= Count + 5'd1;
      end
		

      else if(Count!=(2*(Nr+1)+1))begin 
        Count <= Count + 5'd1;
      end
      end 
      end
		//end
   endmodule


module AES_main (
    input clk,
    input reset,
    input Mode1,
    input Mode2,
    input Mode3,
    output  [6:0] Seg1,
    output  [6:0] Seg2,
    output  [6:0] Seg3,
    output reg  LED
);

wire [127:0]  OutPut1 , OutPut2 , OutPut3;
reg[127:0] TheOut;

reg L;
wire L1, L2 , L3;

wire [127:0] ky1 =128'h000102030405060708090a0b0c0d0e0f;
wire [191:0] ky2= 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
wire [255:0] ky3= 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; 

AES_N #(.Nk(4), .Nr(10)) e1(clk, reset, ky1,L1 , OutPut1);
AES_N #(.Nk(6), .Nr(12)) e2(clk, reset,ky2 ,L2 , OutPut2);
AES_N #(.Nk(8), .Nr(14)) e3(clk, reset,  ky3,L3 , OutPut3);

	  Showing_LS_Byte  S (clks , TheOut , Seg1 , Seg2 , Seg3);

// Assign outputs based on mode selection
always @(*) begin
    if (reset) begin
        TheOut=128'h0;
		  L=1'b0;
    end else begin
        if (Mode1) begin
            TheOut=OutPut1;
				L=L1;
        end else if (Mode2) begin
                        TheOut=OutPut2;
L=L2;
        end else if (Mode3) begin
                        TheOut=OutPut3;
L=L3;
        end
        // You may want to add an else condition for undefined behavior
    end
end

endmodule
