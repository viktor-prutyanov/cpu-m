module rnd_cell(
    input   [15:0]LFSR,
    output  [2:0]X,
    output  [2:0]Y
);

assign X = [10:8]LFSR;
assign Y = [2:0]LFSR;

endmodule
