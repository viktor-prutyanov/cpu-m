module core
(
    input CLK,

    output reg [31:0]OUT,
    input [31:0]IN,

    input [15:0]RAM_Q,
    output reg [11:0]RAM_ADDR,
    output reg RAM_WREN,
    output reg [15:0]RAM_DATA,

    output reg MEM_SELECT,

    output STATE
);

`define Next_instr cpu_state <= 9'b1_00000_010; ip = inc_ip; RAM_ADDR = ip;

initial MEM_SELECT = 1'b0;
initial RAM_WREN = 1'b0;

assign STATE = cpu_state[8];

reg [11:0]ip = 12'b0; //Instruction pointer 
wire [11:0]inc_ip  = ip     + 12'b1;
wire [11:0]inc2_ip = inc_ip + 12'b1;

reg [9:0]sp = 10'b11_1111_1111; //Stack pointer
wire [9:0]inc_sp = sp + 10'b1;
wire [9:0]dec_sp = sp - 10'b1;

reg [8:0]cpu_state = 9'b1_00000_000;
// reg [26:0]cnt = 27'b1; 

wire [7:0]imm = ram_q_dff[7:0];
wire [11:0]addr = ram_q_dff[11:0];

wire [2:0]reg_wa  = (mem_to_reg_l || mem_to_reg_h) ? mem_to_reg_wa : ram_q_dff[10:8];
wire [2:0]reg_ra0 = ram_q_dff[15] ? 3'b101 : (xzz ? ram_q_dff[10:8] : ram_q_dff[7:5]);
wire [2:0]reg_ra1 = ram_q_dff[4:2];
wire reg_we_h = mem_to_reg_h || ((wzz || wrz || wrr || xzz) && (cpu_state == 9'b1_00000_010));
wire reg_we_l = mem_to_reg_l || ((wzz || wrz || wrr || xzz) && (cpu_state == 9'b1_00000_010));
reg [31:0]reg_in;
wire [31:0]reg_in_sig = reg_in;
wire [31:0]reg_out0;
wire [31:0]reg_out1;
regfile regfile_inst(
    .CLK(CLK),
    .RA0(reg_ra0),
    .RA1(reg_ra1),
    .WA(reg_wa),
    .OUT0(reg_out0),
    .OUT1(reg_out1),
    .IN(reg_in_sig),
    .WE_H(reg_we_h),
    .WE_L(reg_we_l)
);

wire wzz = (ram_q_dff[15:11] == 5'b00011) && (&ram_q_dff[1:0]);
wire xzz = (ram_q_dff[15:13] == 3'b010) || (ram_q_dff[15:13] == 3'b001);
wire wrz = (~|ram_q_dff[15:11]) && (ram_q_dff[4:3] == 2'b10);
wire wrr = (ram_q_dff[15:11] == 5'b00001) || (ram_q_dff[15:11] == 5'b00010);
wire zzr = (ram_q_dff[15:11] == 5'b00011) && (ram_q_dff[1:0] == 2'b11);

wire nz = |reg_out0;
wire bz = reg_out0[31];

wire [6:0]alu_mode = {ram_q_dff[15:11], ram_q_dff[1:0]}; 
wire [31:0]alu_ans;
wire [31:0]alu_arg0 = reg_out0;
wire [31:0]alu_arg1 = (wrr || zzr) ? reg_out1 : (ram_q_dff[15:11] == 5'b01011 ? {27'b0, imm[7:3]} : {24'b0, imm[7:0]});
alu alu_inst(
    .ANS(alu_ans),
    .ARG0(alu_arg0),
    .ARG1(alu_arg1),
    .MODE(alu_mode)
);

reg mem_to_reg_l = 1'b0;
reg mem_to_reg_h = 1'b0;
reg [2:0]mem_to_reg_wa = 3'b000;

reg [15:0]ram_q_dff;
always @(negedge CLK) begin
    ram_q_dff <= RAM_Q;
end

reg [0:0]stat = 1'b1;
reg [7:0]ienb = 8'b0;
reg [7:0]iwrk = 8'b0;
reg [31:0]tcnt;
reg [31:0]tcmp;
reg [0:0]tctr = 1'b0;

reg [11:0]iret_ip = 12'b0;

always @(posedge CLK) begin
    if (tctr[0]) begin 
        tcnt = tcnt + 32'b1;
        if (~|tcnt && ienb[1]) begin
            iwrk[1] = 1'b1;
        end
        if ((tcnt == tcmp) && ienb[2]) begin
            iwrk[2] = 1'b1;
        end
    end

    case (cpu_state)
        9'b1_00000_000: begin
            RAM_WREN = 1'b0;

            cpu_state <= 9'b1_00000_010;
            ip = 12'b1000;
            RAM_ADDR = 12'b1000;
        end
        9'b1_00000_010: begin
            cpu_state <= 9'b1_00000_011;
        end
        9'b1_00000_011: begin
            if ((|iwrk) && stat[0]) begin
                stat[0] <= 1'b0;
                iret_ip = ip;
                cpu_state <= 9'b0_00001_010;
                if (iwrk[0]) begin
                    RAM_ADDR = 12'h0;
                    iwrk[0] = 1'b0;
                end
                else if (iwrk[1]) begin
                    RAM_ADDR = 12'h1;
                    iwrk[1] = 1'b0;
                end
                else if (iwrk[2]) begin
                    RAM_ADDR = 12'h2;
                    iwrk[2] = 1'b0;
                end
            end
            else begin
                case (ram_q_dff[15])
                    1'b0: begin
                        case (ram_q_dff[14:11])
                            4'b0000: begin
                                case (ram_q_dff[4:0])
                                    5'b00000: begin //END
                                        cpu_state <= 9'b0_00000_000;
                                    end   
                                    5'b00001: begin //RET
                                        sp <= inc_sp;
    
                                        cpu_state <= 9'b0_00001_010;
                                        RAM_ADDR = {2'b11, inc_sp};
                                    end
                                    5'b00010: begin //IRET
                                        stat[0] <= 1'b1;
                                        
                                        cpu_state <= 9'b1_00000_010; 
                                        ip = iret_ip;
                                        RAM_ADDR = ip;
                                    end
                                    5'b00011: begin //NOP
                                        `Next_instr
                                    end       
                                    5'b01100: begin //OUT
                                        OUT <= alu_ans;
                                        `Next_instr
                                    end        
                                    5'b01101: begin //PUSHL
                                        RAM_DATA <= reg_out0[15:0];
                                        sp <= dec_sp;
                                        RAM_WREN <= 1'b1;
    
                                        cpu_state <= 9'b0_00010_000;
                                        ip = inc_ip;
                                        RAM_ADDR <= {2'b11, sp};
                                    end     
                                    5'b01110: begin //PUSHH
                                        RAM_DATA <= reg_out0[31:16];
                                        sp <= dec_sp;
                                        RAM_WREN <= 1'b1;

                                        cpu_state <= 9'b0_00010_000;
                                        ip = inc_ip;
                                        RAM_ADDR <= {2'b11, sp};
                                    end                                                  
                                    5'b10000: begin //MOV
                                        reg_in <= alu_ans;
                                        `Next_instr
                                    end
                                    5'b10001: begin //NOT
                                        reg_in <= alu_ans;
                                        `Next_instr
                                    end                                                                
                                    5'b10010: begin //NEG
                                        reg_in <= alu_ans;
                                        `Next_instr
                                    end
                                    5'b10011: begin //IN
                                        reg_in <= IN;
                                        `Next_instr
                                    end
                                    5'b11000: begin //LDRAML
                                        mem_to_reg_l <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
                                        MEM_SELECT <= reg_out0[16];
                                        cpu_state <= 9'b0_00001_000;
                                        ip = inc_ip;
                                        RAM_ADDR = reg_out0[11:0];
                                    end
                                    5'b11001: begin //LDRAMH
                                        mem_to_reg_h <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
                                        MEM_SELECT <= reg_out0[16];
                                        cpu_state <= 9'b0_00001_001;
                                        ip = inc_ip;
                                        RAM_ADDR = reg_out0[11:0];
                                    end
                                    5'b11010: begin //POPL
                                        mem_to_reg_l <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
                                        sp <= inc_sp;
    
                                        cpu_state <= 9'b0_00001_000;
                                        ip = inc_ip;
                                        RAM_ADDR = {2'b11, inc_sp};
                                    end
                                    5'b11011: begin //POPH
                                        mem_to_reg_h <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
                                        sp <= inc_sp;
    
                                        cpu_state <= 9'b0_00001_001;
                                        ip = inc_ip;
                                        RAM_ADDR = {2'b11, inc_sp};
                                    end
                                    5'b11101: begin //MOVL
                                        mem_to_reg_l <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
    
                                        cpu_state <= 9'b0_00001_000;
                                        ip = inc2_ip;
                                        RAM_ADDR = inc_ip;
                                    end
                                    5'b11110: begin //MOVH
                                        mem_to_reg_h <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
    
                                        cpu_state <= 9'b0_00001_001;
                                        ip = inc2_ip;
                                        RAM_ADDR = inc_ip;
                                    end
                                    5'b11111: begin //MOVD
                                        mem_to_reg_l <= 1'b1;  
                                        mem_to_reg_h <= 1'b1;
                                        mem_to_reg_wa <= reg_wa;
    
                                        cpu_state <= 9'b0_00001_100;
                                        ip = inc2_ip;
                                        RAM_ADDR = inc_ip;
                                    end
                                endcase
                            end
                            4'b0001: begin //ADD, SUB, MUL, SA
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                            4'b0010: begin // AND, OR, XOR, ROT
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                            4'b0011: begin
                                case (ram_q_dff[1:0])
                                    2'b00: begin //STRAML
                                        RAM_DATA <= reg_out0[15:0];
                                        RAM_WREN <= 1'b1;
                                        MEM_SELECT <= reg_out1[16];
                                        cpu_state <= 9'b0_00010_000;
                                        ip = inc_ip;
                                        RAM_ADDR <= reg_out1[11:0];
                                    end
                                    2'b01: begin //STRAMH
                                        RAM_DATA <= reg_out0[31:16];
                                        RAM_WREN <= 1'b1;
                                        MEM_SELECT <= reg_out1[16];
                                        cpu_state <= 9'b0_00010_000;
                                        ip = inc_ip;
                                        RAM_ADDR <= reg_out1[11:0];
                                    end
                                    2'b10: begin //STSPRD
                                        case (ram_q_dff[7:5])
                                            3'b000: begin
                                                cpu_state <= 9'b1_00000_010;
                                                ip = reg_out1[11:0];
                                                RAM_ADDR = ip;
                                            end
                                            3'b001: begin
                                                sp = reg_out1[9:0];
                                                `Next_instr
                                            end
                                            //stat
                                            3'b011: begin
                                                ienb = reg_out1[7:0];
                                                `Next_instr
                                            end
                                            //iwrk
                                            3'b101: begin
                                                tcnt = reg_out1[31:0];
                                                `Next_instr
                                            end
                                            3'b110: begin
                                                tctr = reg_out1[0];
                                                `Next_instr
                                            end
                                            3'b111: begin
                                                tcmp = reg_out1[31:0];
                                                `Next_instr
                                            end
                                        endcase
                                         
                                    end
                                    2'b11: begin //LDSPRD
                                        case (ram_q_dff[4:2])
                                            3'b000: begin
                                                reg_in <= {20'b0, ip};
                                            end
                                            3'b001: begin
                                                reg_in <= {20'b0, 2'b11, sp};
                                            end
                                            3'b010: begin
                                                reg_in <= {31'b0, stat};
                                            end
                                            3'b011: begin
                                                reg_in <= {24'b0, ienb};
                                            end
                                            3'b100: begin
                                                reg_in <= {24'b0, iwrk};
                                            end
                                            3'b101: begin
                                                reg_in <= tcnt;
                                            end
                                            3'b110: begin
                                                reg_in <= {31'b0, tctr};
                                            end
                                            3'b111: begin
                                                reg_in <= tcmp;
                                            end
                                        endcase
                                        `Next_instr
                                    end
                                endcase
                            end
                            4'b0100: begin //MOVLL
                                reg_in <= {alu_ans[31:8], imm};
                                `Next_instr
                            end
                            4'b0101: begin //MOVLH
                                reg_in <= {alu_ans[31:16], imm, alu_ans[7:0]};
                                `Next_instr
                            end
                            4'b0110: begin //MOVHL
                                reg_in <= {alu_ans[31:24], imm, alu_ans[15:0]};
                                `Next_instr
                            end
                            4'b0111: begin //MOVHH
                                reg_in <= {imm, alu_ans[23:0]};
                                `Next_instr
                            end
                            4'b1000: begin //ADDB
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                            4'b1001: begin //SUBB
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                            4'b1010: begin //MULB
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                            4'b1011: begin //SAL, SAR, ROL, ROR
                                reg_in <= alu_ans;
                                `Next_instr
                            end
                        endcase
                    end
                    1'b1: begin
                        case (ram_q_dff[14:12])
                            3'b000: begin //CALL
                                RAM_DATA <= {4'b0, inc_ip};
                                sp <= dec_sp;
                                RAM_WREN <= 1'b1;
    
                                cpu_state <= 9'b0_00010_000;
                                ip = addr;
                                RAM_ADDR <= {2'b11, sp};
                            end
                            3'b001: begin //JMP
                                cpu_state <= 9'b1_00000_010;
                                ip = addr;
                                RAM_ADDR = ip;
                            end
                            3'b010: begin //JEZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (~nz)       ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                            3'b011: begin //JNZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (nz)        ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                            3'b100: begin //JAZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (~bz && nz) ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                            3'b101: begin //JBZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (bz)        ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                            3'b110: begin //JAEZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (~bz)       ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                            3'b111: begin //JBEZ
                                cpu_state <= 9'b1_00000_010;
                                ip = (bz || ~nz) ? addr : inc_ip;
                                RAM_ADDR = ip;
                            end
                        endcase
                    end
                endcase
            end
        end
/*END*/ 9'b0_00000_000: begin
            
        end
/*MOVD*/9'b0_00001_100: begin
            reg_in[31:16] <= RAM_Q;
            cpu_state <= 9'b0_00001_000;    
            RAM_ADDR = ip;
            ip = inc_ip;
        end
/*LDOL*/9'b0_00001_000: begin
/*POPL*/    reg_in[15:0] <= RAM_Q;
/*MOVL*/    cpu_state <= 9'b0_00001_011;
/*MOVD*/    RAM_ADDR = ip;  
            MEM_SELECT <= 1'b0;
        end
/*LDOH*/9'b0_00001_001: begin
/*POPH*/    reg_in[31:16] <= RAM_Q;
/*MOVH*/    cpu_state <= 9'b0_00001_011;
            RAM_ADDR = ip;
            MEM_SELECT <= 1'b0;
        end
/*RET*/ 9'b0_00001_010: begin
            cpu_state <= 9'b0_00001_011;
            ip <= RAM_Q[11:0];
            RAM_ADDR = RAM_Q[11:0];
        end
/*LDOx*/9'b0_00001_011: begin
/*POPx*/    mem_to_reg_h <= 1'b0;
/*RET*/     mem_to_reg_l <= 1'b0;
/*MOVx*/    cpu_state <= 9'b1_00000_011;
        end
/*LDIx*/9'b0_00010_000: begin
/*PUSHx*/   RAM_WREN <= 1'b0;  
/*CALL*/    MEM_SELECT <= 1'b0;
            cpu_state <= 9'b1_00000_010;
            RAM_ADDR = ip;  
        end
    endcase
end

endmodule
