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
wire [15:0]ram_data;
wire ram1_wren;
wire [15:0]ram1_q;
ram ram_inst(
    .address(ram_addr),
    .clock(~CLK),
    .data(ram_data),
    .wren(ram1_wren),
    .q(ram1_q)
);

wire [31:0]in = {28'b0, KEYS[3:0]};
core core_inst(
    .CLK(CLK),
    .OUT(LED),
    .IN(in),

    .RAM_ADDR(ram_addr),
    .RAM_WREN(ram_wren),
    .RAM_Q(ram_q),
    .RAM_DATA(ram_data),

    .MEM_SELECT(mem_select)
);

wire ram_wren;
wire [15:0]ram_q;
wire mem_select;
mem_selector mem_selector_inst(
    .WREN(ram_wren), .Q(ram_q),
    .WREN1(ram1_wren), .Q1(ram1_q),
    .WREN2(ram2_wren), .Q2(ram2_q),
    .SELECT(mem_select)
);

//wire [15:0]num_l;
//segment_led segment_led0(
//    .CLK(CLK),
//    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
//    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
//    .NUM(num_l)
//);

//wire [15:0]lfsr16_q;
//lfsr16 lfsr16_inst(
//    .CLK(CLK),
//    .Q(lfsr16_q)
//);

//wire [5:0]rnd_x;
//wire [4:0]rnd_y;
//rnd_cell rnd_cell_inst(
//    .LFSR(lfsr16_q[10:0]),
//    .X(rnd_x),
//    .Y(rnd_y)
//);

wire ram2_wren;
wire [15:0]ram2_q;
matrix_driver matrix_driver_inst(
    .CLK(CLK),
    .L_GREEN(L_GREEN[7:0]),
    .L_RED(L_RED[7:0]),
    .L_VCC(L_VCC[7:0]),
    .DATA(ram_data),
    .WREN(ram2_wren),
    .ADDR(ram_addr[2:0]),
    .Q(ram2_q)
);

endmodule
