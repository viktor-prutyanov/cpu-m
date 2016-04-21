module alu
(
    output [31:0]ANS,
    input [31:0]ARG0,
    input [31:0]ARG1,
    input [6:0]MODE
);

wire add_en = ( MODE == 7'b00001_00) || (MODE[6:2] == 5'b01000);
wire sub_en = ( MODE == 7'b00001_01) || (MODE[6:2] == 5'b01001);
wire mul_en = ( MODE == 7'b00001_10) || (MODE[6:2] == 5'b01010);
wire and_en = ( MODE == 7'b00010_00);
wire or_en  = ( MODE == 7'b00010_01);
wire xor_en = ( MODE == 7'b00010_10);
wire sal_en = ((MODE == 7'b00001_11) &&  ARG1[31]) || (MODE == 7'b01011_00);
wire sar_en = ((MODE == 7'b00001_11) && ~ARG1[31]) || (MODE == 7'b01011_01);
wire rol_en = ((MODE == 7'b00010_11) &&  ARG1[31]) || (MODE == 7'b01011_10);
wire ror_en = ((MODE == 7'b00010_11) && ~ARG1[31]) || (MODE == 7'b01011_11);
wire not_en = ( MODE == 7'b00000_01);
wire neg_en = ( MODE == 7'b00000_10);

wire [4:0]reduced_abs_arg1 = ARG1[31] ? (reduced_neg_arg1) : ARG1[4:0];  
wire [4:0]reduced_neg_arg1 = ~ARG1[4:0] + 5'b1;
wire [4:0]reduced_neg_abs_arg1 = ARG1[31] ? ARG1[4:0] : reduced_neg_arg1; 

assign ANS[31:0] =   mul_en ? mul_ans : 
                    (add_en ? add_ans : 
                    (sub_en ? sub_ans :
                    (sal_en ? sal_ans :
                    (sar_en ? sar_ans :
                    (and_en ? and_ans :
                    (or_en  ? or_ans  :
                    (xor_en ? xor_ans :
                    (rol_en ? rol_ans :
                    (ror_en ? ror_ans : 
                    (not_en ? not_ans :
                    (neg_en ? neg_ans : ARG0)))))))))));

wire [31:0]mul_ans;
mult mult_inst(
    .dataa(ARG0),
    .datab(ARG1),
    .result(mul_ans)
);

wire [31:0]add_ans = ARG0 + ARG1;
wire [31:0]sub_ans = ARG0 - ARG1;
wire [31:0]sal_ans = ARG0 << reduced_abs_arg1;
wire [31:0]sar_ans = ARG0 >> reduced_abs_arg1;
wire [31:0]rol_ans = (ARG0 << reduced_abs_arg1) | (ARG0 >> reduced_neg_abs_arg1);
wire [31:0]ror_ans = (ARG0 >> reduced_abs_arg1) | (ARG0 << reduced_neg_abs_arg1);
wire [31:0]and_ans = ARG0 & ARG1;
wire [31:0]or_ans  = ARG0 | ARG1;
wire [31:0]xor_ans = ARG0 ^ ARG1;
wire [31:0]not_ans = ~ARG0;
wire [31:0]neg_ans = not_ans + 32'b1;

endmodule
