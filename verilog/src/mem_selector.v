module mem_selector(
    input WREN,
    output [15:0]Q,

    output WREN1,
    input [15:0]Q1,

    output WREN2,
    input [15:0]Q2,

    input SELECT
);

assign Q = SELECT ? Q2 : Q1;
assign WREN1 = SELECT ? 1'b0 : WREN;
assign WREN2 = SELECT ? WREN : 1'b0;

endmodule