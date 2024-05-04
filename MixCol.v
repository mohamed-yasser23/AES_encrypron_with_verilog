module MixCol(input [127:0] in, output  [127:0] out);

  reg [7:0] u; 

  function [7:0] mixtwo;
    input [7:0] input_val;
    begin
      if (input_val[7] == 1'b1) begin
        input_val[7:1] = input_val[6:0];
        input_val[0] = 1'b0;
        input_val = (8'b00011011) ^ input_val;
      end
      else begin
        input_val[7:1] = input_val[6:0];
        input_val[0] = 1'b0;
      end
      mixtwo = input_val;
    end
  endfunction
  
  function [7:0] mixthree;
    input [7:0] input_val;
    begin
      if (input_val[7] == 1'b1) begin
        u[7:1] = input_val[6:0];
        u[0] = 1'b0;
        u = (8'b00011011) ^ u;
        mixthree = u ^ input_val;
      end
		else if (input_val[7] != 1'b1) begin
        u[7:1] = input_val[6:0];
        u[0] = 1'b0;
        mixthree = u ^ input_val;
      end
    end
  endfunction

  // Generate block to perform mix-column operation
  genvar i;
  generate 
    for (i = 0; i < 4; i = i + 1) begin : m_col
      assign out[(i * 32 + 24) +: 8] = mixtwo(in[(i * 32 + 24) +: 8]) ^ mixthree(in[(i * 32 + 16) +: 8]) ^ in[(i * 32 + 8) +: 8] ^ in[i * 32 +: 8];
      assign out[(i * 32 + 16) +: 8] = in[(i * 32 + 24) +: 8] ^ mixtwo(in[(i * 32 + 16) +: 8]) ^ mixthree(in[(i * 32 + 8) +: 8]) ^ in[i * 32 +: 8];
      assign out[(i * 32 + 8) +: 8] = in[(i * 32 + 24) +: 8] ^ in[(i * 32 + 16) +: 8] ^ mixtwo(in[(i * 32 + 8) +: 8]) ^ mixthree(in[i * 32 +: 8]);
      assign out[i * 32 +: 8] = mixthree(in[(i * 32 + 24) +: 8]) ^ in[(i * 32 + 16) +: 8] ^ in[(i * 32 + 8) +: 8] ^ mixtwo(in[i * 32 +: 8]);
    end
  endgenerate

endmodule