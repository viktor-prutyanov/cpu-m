module rnd_cell(
    input   [10:0]LFSR,
    output  [5:0]X,
    output  [4:0]Y
);

assign X = (LFSR[10:5] > 39) ? (LFSR[10:5] - 39) : LFSR[10:5];
assign Y = (LFSR[4:0]  > 29) ? (LFSR[4:0]  - 29) : LFSR[4:0];

endmodule