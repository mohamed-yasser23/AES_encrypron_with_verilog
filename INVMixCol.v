module INVMixCol(input [127:0] in,output  [127:0] out);


  function [7:0] mixbittwo;
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
      mixbittwo = input_val;
    end
  endfunction

  function [7:0] mixbitthree;
    input [7:0] input_val;
    begin
      if (input_val[7] == 1'b1 && input_val[6] == 1'b1) begin
        input_val[7:2] = input_val[5:0];
        input_val[1:0] = 2'b00;
        input_val = (8'b00011011) ^ input_val ^ (8'b00110110);
      end
      else if (input_val[7] == 1'b1) begin
        input_val[7:2] = input_val[5:0];
        input_val[1:0] = 2'b00;
        input_val = input_val ^ (8'b00110110);
      end
      else if (input_val[6] == 1'b1) begin
        input_val[7:2] = input_val[5:0];
        input_val[1:0] = 2'b00;
        input_val = input_val ^ (8'b00011011);
      end
      else begin
        input_val[7:2] = input_val[5:0];
        input_val[1:0] = 2'b00;
      end
      mixbitthree = input_val;
    end
  endfunction

  function [7:0] mixbitfour;
    input [7:0] input_val;
    begin
      
      if (input_val[7] == 1'b1&&input_val[6] == 1'b1&&input_val[5] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b01101100)^ (8'b00110110)^ (8'b00011011);
      end
      else if (input_val[7] == 1'b1&&input_val[6] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b01101100) ^ (8'b00110110);
      end
      else if (input_val[5] == 1'b1&&input_val[6] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b00011011)^ (8'b00110110);
      end
      else if (input_val[5] == 1'b1&&input_val[7] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b00011011)^ (8'b01101100);
      end
      else if (input_val[7] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^  (8'b01101100);
      end
      else if (input_val[6] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b00110110);
      end
      else if (input_val[5] == 1'b1) begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
        input_val = input_val ^ (8'b00011011);
      end
       else  begin
        input_val[7:3] = input_val[4:0];
      input_val[2:0] = 3'b000;
      end
      mixbitfour = input_val;
    end
  endfunction

  function [7:0] func_09;
    input [7:0] input_val;
    begin
      func_09 = mixbitfour(input_val) ^ input_val;
    end
  endfunction

  function [7:0] func_0B;
    input [7:0] input_val;
    begin
      func_0B = mixbitfour(input_val) ^ mixbittwo(input_val) ^ input_val;
    end
  endfunction

  function [7:0] func_0D;
    input [7:0] input_val;
    begin
      func_0D = mixbitfour(input_val) ^ mixbitthree(input_val) ^ input_val;
    end
  endfunction

  function [7:0] func_0E;
    input [7:0] input_val;
    begin
      func_0E = mixbitfour(input_val) ^ mixbitthree(input_val) ^ mixbittwo(input_val);
    end
  endfunction

  genvar i;

  generate
    for (i = 0; i < 4; i = i + 1) begin : m_col
      assign out[(i*32 + 24) +: 8] = func_0E(in[(i*32 + 24) +: 8]) ^ func_0B(in[(i*32 + 16) +: 8]) ^ func_0D(in[(i*32 + 8) +: 8]) ^ func_09(in[i*32 +: 8]);
      assign out[(i*32 + 16) +: 8] = func_09(in[(i*32 + 24) +: 8]) ^ func_0E(in[(i*32 + 16) +: 8]) ^ func_0B(in[(i*32 + 8) +: 8]) ^ func_0D(in[i*32 +: 8]);
      assign out[(i*32 + 8) +: 8] = func_0D(in[(i*32 + 24) +: 8]) ^ func_09(in[(i*32 + 16) +: 8]) ^ func_0E(in[(i*32 + 8) +: 8]) ^ func_0B(in[i*32 +: 8]);
      assign out[i*32 +: 8] = func_0B(in[(i*32 + 24) +: 8]) ^ func_0D(in[(i*32 + 16) +: 8]) ^ func_09(in[(i*32 + 8) +: 8]) ^ func_0E(in[i*32 +: 8]);
    end
  endgenerate

endmodule


 