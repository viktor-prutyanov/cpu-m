module lfsr16(
    input CLK,

    output reg [15:0]Q
);

initial Q = 16'hBEEF;

wire feedback = Q[15]^Q[12]^Q[10]^Q[9]^Q[8]^Q[7]^Q[6]^Q[5]^Q[4]^Q[3]^Q[2]^Q[1]^Q[0];

always @(posedge CLK) begin
    Q = Q >> 1;
    Q[15] = feedback;
end

endmodule