module segment_led
(
    input CLK,
    
    input [15:0]NUM,
    output reg DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output reg DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G    
);

reg [1:0] digit_number = 2'b00;

reg [15:0] cnt = 16'b0;

always @(posedge CLK) begin
    if (cnt == 50000) begin
        cnt = 0;
        case (digit_number)
            2'b00: begin
                {DS_EN4, DS_EN3, DS_EN2, DS_EN1} = 4'b0111;
                case (NUM[3:0])
                    4'h0: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111110;
                    4'h1: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110000;
                    4'h2: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101101;
                    4'h3: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111001;
                    4'h4: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110011;
                    4'h5: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011011;
                    4'h6: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011111;
                    4'h7: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110000;
                    4'h8: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111111;
                    4'h9: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111011;
                    4'ha: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110111;
                    4'hb: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0011111;
                    4'hc: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1001110;
                    4'hd: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0111101;
                    4'he: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101111;
                    4'hf: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1000111;
                endcase
            end
            2'b01: begin
                {DS_EN4, DS_EN3, DS_EN2, DS_EN1} = 4'b1011;
                case (NUM[7:4])
                    4'h0: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111110;
                    4'h1: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110000;
                    4'h2: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101101;
                    4'h3: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111001;
                    4'h4: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110011;
                    4'h5: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011011;
                    4'h6: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011111;
                    4'h7: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110000;
                    4'h8: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111111;
                    4'h9: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111011;
                    4'ha: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110111;
                    4'hb: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0011111;
                    4'hc: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1001110;
                    4'hd: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0111101;
                    4'he: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101111;
                    4'hf: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1000111;
                endcase
            end
            2'b10: begin
                {DS_EN4, DS_EN3, DS_EN2, DS_EN1} = 4'b1101;
                case (NUM[11:8])
                    4'h0: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111110;
                    4'h1: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110000;
                    4'h2: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101101;
                    4'h3: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111001;
                    4'h4: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110011;
                    4'h5: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011011;
                    4'h6: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011111;
                    4'h7: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110000;
                    4'h8: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111111;
                    4'h9: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111011;
                    4'ha: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110111;
                    4'hb: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0011111;
                    4'hc: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1001110;
                    4'hd: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0111101;
                    4'he: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101111;
                    4'hf: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1000111;
                endcase
            end
            2'b11: begin
                {DS_EN4, DS_EN3, DS_EN2, DS_EN1} = 4'b1110;
                case (NUM[15:12])
                    4'h0: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111110;
                    4'h1: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110000;
                    4'h2: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101101;
                    4'h3: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111001;
                    4'h4: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0110011;
                    4'h5: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011011;
                    4'h6: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1011111;
                    4'h7: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110000;
                    4'h8: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111111;
                    4'h9: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1111011;
                    4'ha: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1110111;
                    4'hb: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0011111;
                    4'hc: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1001110;
                    4'hd: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b0111101;
                    4'he: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1101111;
                    4'hf: {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = 7'b1000111;
                endcase
            end
        endcase
    digit_number = digit_number + 2'b01;
    end
    else begin
        cnt = cnt + 16'b1;
    end
end

endmodule