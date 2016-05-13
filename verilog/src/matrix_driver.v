module matrix_driver(
    input CLK,

    input [15:0]RAM_Q,
    output [11:0]RAM_ADDR,

    output [7:0]L_GREEN,
    output [7:0]L_RED,
    output [7:0]L_VCC
);

assign RAM_ADDR = {9'b111100000, line_num};

assign L_GREEN = ~RAM_Q[7:0];
assign L_RED = ~RAM_Q[15:8];
assign L_VCC = 8'b1 << line_num;

reg [11:0]cnt = 12'b0;
wire sync = cnt[11];
always @(posedge CLK) begin
    cnt = cnt + 12'b1;
end

reg [2:0]line_num = 3'b0;

always @(posedge sync) begin
    line_num = line_num + 3'b1;
end

endmodule
