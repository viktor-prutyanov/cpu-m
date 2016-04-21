module matrix_driver(
    input CLK,

    input [2:0]ADDR,
    input [15:0]DATA,
    input WREN,
    output [15:0]Q,

    output [7:0]L_GREEN,
    output [7:0]L_RED,
    output [7:0]L_VCC
);

assign L_GREEN = ~ram_q[7:0];
assign L_RED = ~ram_q[15:8];
assign L_VCC = 8'b1 << line_num;

reg [15:0]cnt = 16'b0;
wire sync = cnt[15];
always @(posedge CLK) begin
    cnt = cnt + 16'b1;
end

wire [15:0]ram_q;
wire [2:0]ram_addr = line_num;
wire wren_b_sig = 1'b0;
wire [15:0]data_b_sig = 16'b0;
m_ram m_ram_inst(
    .address_a(ADDR),
    .address_b(ram_addr),
    .clock(CLK),
    .data_a(DATA),
    .data_b(data_b_sig),
    .wren_a(WREN),
    .wren_b(wren_b_sig),
    .q_a(Q),
    .q_b(ram_q)
);

reg [2:0]line_num = 3'b0;

always @(posedge sync) begin
    line_num = line_num + 3'b1;
end

endmodule
