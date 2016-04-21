module regfile
(
    input CLK,

    input [2:0]RA0,
    input [2:0]RA1,
    input [2:0]WA,
    output [31:0]OUT0,
    output [31:0]OUT1,
    input [31:0]IN,
    input WE_L,
    input WE_H
);

reg [31:0]registers[7:0]; 

assign OUT0 = registers[RA0];
assign OUT1 = registers[RA1];

always @(negedge CLK) begin
    if (WE_L) begin
        registers[WA][15:0] <= IN[15:0];
    end 
    if (WE_H) begin
        registers[WA][31:16] <= IN[31:16];
    end 
end

endmodule