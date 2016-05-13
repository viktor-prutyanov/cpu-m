module top
(
    input CLK,
    
    input [3:0]KEYS,
        
    output [7:0]LED,
    
    output [7:0]L_GREEN,
    output [7:0]L_RED,
    output [7:0]L_VCC
);

wire [11:0]ram_addr;
wire [11:0]m_ram_addr;
wire [15:0]ram_data;
wire ram_wren;
wire [15:0]ram_q;
wire [15:0]m_ram_q;
ram ram_inst(
    .address_a(ram_addr),
    .address_b(m_ram_addr),
    .clock(~CLK),
    .data_a(ram_data),
    .data_b(16'b0),
    .wren_a(ram_wren),
    .wren_b(1'b0),
    .q_a(ram_q),
    .q_b(m_ram_q)
);

wire [31:0]in = {5'b0, lfsr16_q[10:8], 5'b0, lfsr16_q[2:0], 12'b0, KEYS[3:0]};
core core_inst(
    .CLK(CLK),
    .OUT(LED),
    .IN(in),

    .RAM_ADDR(ram_addr),
    .RAM_WREN(ram_wren),
    .RAM_Q(ram_q),
    .RAM_DATA(ram_data),

);

//wire [15:0]num_l;
//segment_led segment_led0(
//    .CLK(CLK),
//    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
//    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
//    .NUM(num_l)
//);

wire [15:0]lfsr16_q;
lfsr16 lfsr16_inst(
    .CLK(CLK),
    .Q(lfsr16_q)
);

matrix_driver matrix_driver_inst(
    .CLK(CLK),
    .L_GREEN(L_GREEN[7:0]),
    .L_RED(L_RED[7:0]),
    .L_VCC(L_VCC[7:0]),
    .RAM_Q(m_ram_q),
    .RAM_ADDR(m_ram_addr)
);

endmodule
