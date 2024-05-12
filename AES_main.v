 module AES_main #(parameter Nk =4, parameter Nr = 10) (clk,reset ,Seg1 ,Seg2 , Seg3 ,LED);
 input clk;
 input reset;
   output[6:0] Seg1;
   output[6:0] Seg2;
   output[6:0] Seg3;
   output reg LED;
   wire clks=clk;
   wire resets=reset;

   wire [127:0] pl =128'h00112233445566778899aabbccddeeff;

   wire [127:0] ky1 =128'h000102030405060708090a0b0c0d0e0f;
   wire [191:0] ky2= 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
   wire [255:0] ky3= 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; 

   wire [127:0] cOut;
   wire [127:0] DecOut;
   reg [127:0]  seg_DE ;
   reg [127:0] inpD;
   reg [4:0] Count = 5'd0;


	  Showing_LS_Byte  S (clks , seg_DE[7:0] , Seg1 , Seg2 , Seg3);

   cipherEN #(Nk ,Nr)E (clks,resets,pl,cOut,ky1);
   decipherDE #(Nk,Nr)D (clks,resets,cOut,DecOut,ky1);
              
   


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
        
		  LED=1'b1;;
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


module AES (
    input clk,
    input reset,
    input Mode1,
    input Mode2,
    input Mode3,
    output reg [6:0] Seg1,
    output reg [6:0] Seg2,
    output reg [6:0] Seg3,
    output reg  LED
);

wire [6:0] Seg1_temp, Seg2_temp, Seg3_temp; // Temporary variables for AES_N outputs
wire L;
// Instantiate AES_N modules outside always block
AES_N #(.Nk(4), .Nr(10)) e1(clk, reset, Seg1_temp, Seg2_temp, Seg3_temp, L);
AES_N #(.Nk(6), .Nr(12)) e2(clk, reset, Seg1_temp, Seg2_temp, Seg3_temp, L);
AES_N #(.Nk(8), .Nr(14)) e3(clk, reset, Seg1_temp, Seg2_temp, Seg3_temp, L);


// Assign outputs based on mode selection
always @(posedge clk) begin
    if (reset) begin
        Seg1 <= 7'b0;
        Seg2 <= 7'b0;
        Seg3 <= 7'b0;
        LED <= 1'b0;
    end else begin
        if (Mode1) begin
            Seg1 <= Seg1_temp;
            Seg2 <= Seg2_temp;
            Seg3 <= Seg3_temp;
        end else if (Mode2) begin
            Seg1 <= Seg1_temp;
            Seg2 <= Seg2_temp;
            Seg3 <= Seg3_temp;
        end else if (Mode3) begin
            Seg1 <= Seg1_temp;
            Seg2 <= Seg2_temp;
            Seg3 <= Seg3_temp;
        end
        // You may want to add an else condition for undefined behavior
    end
end

endmodule
