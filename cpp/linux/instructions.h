#ifdef INSTR

#define END                  0x0000                                             /*ZZZ*/ //(0b00000ffffff00000)
#define RET                  0x0001                                             /*ZZZ*/ //(0b00000ffffff00001)
#define IRET                 0x0002                                             /*ZZZ*/ //(0b00000ffffff00010)
#define NOP                  0x0003                                             /*ZZZ*/ //(0b00000ffffff00011)
/*                           0x0004                                           *//*ZZZ*/ //(0b00000ffffff00100)
/*                           0x0005                                           *//*ZZZ*/ //(0b00000ffffff00101)
/*                           0x0006                                           *//*ZZZ*/ //(0b00000ffffff00110)
/*                           0x0007                                           *//*ZZZ*/ //(0b00000ffffff00111)
/*                           0x0008                                           *//*   */ //(0b00000rrrfff01000)
/*                           0x0009                                           *//*   */ //(0b00000rrrfff01001)
/*                           0x000A                                           *//*   */ //(0b00000rrrfff01010)
/*                           0x000B                                           *//*   */ //(0b00000rrrfff01011)
#define OUT(reg1)           (0x000C               + (reg1 << 5))                /*ZRZ*/ //(0b00000fffrrr01100)
#define PUSHL(reg1)         (0x000D               + (reg1 << 5))                /*ZRZ*/ //(0b00000fffrrr01101)
#define PUSHH(reg1)         (0x000E               + (reg1 << 5))                /*ZRZ*/ //(0b00000fffrrr01110)
/*                          (0x000F               + (reg1 << 5))              *//*ZRZ*/ //(0b00000fffrrr01111)
#define MOV(reg1,reg2)	    (0x0010 + (reg1 << 8) + (reg2 << 5))                /*WRZ*/ //(0b00000rrrrrr10000)
#define NOT(reg1,reg2)      (0x0011 + (reg1 << 8) + (reg2 << 5))                /*WRZ*/ //(0b00000rrrrrr10001)
#define NEG(reg1,reg2)      (0x0012 + (reg1 << 8) + (reg2 << 5))                /*WRZ*/ //(0b00000rrrrrr10010)
#define IN(reg1)            (0x0013 + (reg1 << 8))                              /*WRZ*/ //(0b00000rrrfff10011)
/*                           0x0014                                           *//*WRZ*/ //(0b00000rrrrrr10100)
/*                           0x0015                                           *//*WRZ*/ //(0b00000rrrrrr10101)
/*                           0x0016                                           *//*WRZ*/ //(0b00000rrrrrr10110)
/*                           0x0017                                           *//*WRZ*/ //(0b00000rrrrrr10111)
#define LDL(reg1,reg2)   (0x0018 + (reg1 << 8) + (reg2 << 5))                /*MRZ*/ //(0b00000rrrrrr11000)
#define LDH(reg1,reg2)   (0x0019 + (reg1 << 8) + (reg2 << 5))                /*MRZ*/ //(0b00000rrrrrr11001)  
#define POPL(reg1)          (0x001A + (reg1 << 8))                              /*MZZ*/ //(0b00000rrrfff11010)
#define POPH(reg1)          (0x001B + (reg1 << 8))                              /*MZZ*/ //(0b00000rrrfff11011)
//#define POPD(reg1)        (0x001C + (reg1 << 8))                              /*MZZ*/ //(0b00000ffffff11100)
#define MOVL(reg1)          (0x001D + (reg1 << 8))                              /*MZZ*/ //(0b00000rrrfff11101)
#define MOVH(reg1)          (0x001E + (reg1 << 8))                              /*MZZ*/ //(0b00000rrrfff11110)
#define MOVD(reg1)          (0x001F + (reg1 << 8))                              /*MZZ*/ //(0b00000rrrfff11111)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define ADD(reg1,reg2,reg3) (0x0800 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00001rrrrrrrrr00)
#define SUB(reg1,reg2,reg3) (0x0801 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00001rrrrrrrrr01)
#define MUL(reg1,reg2,reg3) (0x0802 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00001rrrrrrrrr10)
#define SH(reg1,reg2,reg3)  (0x0803 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00001rrrrrrrrr11)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define AND(reg1,reg2,reg3) (0x1000 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00010rrrrrrrrr00)
#define OR(reg1,reg2,reg3)  (0x1001 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00010rrrrrrrrr01)
#define XOR(reg1,reg2,reg3) (0x1002 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00010rrrrrrrrr10)
#define ROT(reg1,reg2,reg3) (0x1003 + (reg1 << 8) + (reg2 << 5) + (reg3 << 2))  /*WRR*/ //(0b00010rrrrrrrrr11)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define STL(reg1,reg2)   (0x1800               + (reg1 << 5) + (reg2 << 2))  /*ZRR*/ //(0b00011fffrrrrrr00)
#define STH(reg1,reg2)   (0x1801               + (reg1 << 5) + (reg2 << 2))  /*ZRR*/ //(0b00011fffrrrrrr01)
#define STSPRD(reg1,sreg)   (0x1802               + (sreg << 5) + (reg1 << 2))  /*ZZR*/ //(0b00011ssssssrrr10)
#define LDSPRD(reg1,sreg)   (0x1803 + (reg1 << 8)               + (sreg << 2))  /*WZZ*/ //(0b00011rrrssssss11)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define MOVLL(reg1,num)	    (0x2000 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b00100rrriiiiiiii)
#define MOVLH(reg1,num)	    (0x2800 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b00101rrriiiiiiii)
#define MOVHL(reg1,num)	    (0x3000 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b00110rrriiiiiiii)
#define MOVHH(reg1,num)	    (0x3800 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b00111rrriiiiiiii)
#define ADDB(reg1,num)	    (0x4000 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b01000rrriiiiiiii)
#define SUBB(reg1,num)      (0x4800 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b01001rrriiiiiiii)
#define MULB(reg1,num)      (0x5000 + (reg1 << 8) + (uint8_t)num)               /*XZZ*/ //(0b01010rrriiiiiiii)
#define SHL(reg1,num)       (0x5800 + (reg1 << 8) + (((uint8_t)num & 31) << 3)) /*XZZ*/ //(0b01011rrriiiiif00) 
#define SHR(reg1,num)	    (0x5801 + (reg1 << 8) + (((uint8_t)num & 31) << 3)) /*XZZ*/ //(0b01011rrriiiiif01)
#define ROL(reg1,num)	    (0x5802 + (reg1 << 8) + (((uint8_t)num & 31) << 3)) /*XZZ*/ //(0b01011rrriiiiif10)
#define ROR(reg1,num)	    (0x5803 + (reg1 << 8) + (((uint8_t)num & 31) << 3)) /*XZZ*/ //(0b01011rrriiiiif11)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define CALL(addr)		    (0x8000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1000aaaaaaaaaaaa)
#define JMP(addr)		    (0x9000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1001aaaaaaaaaaaa)	
#define JEZ(addr)		    (0xA000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1010aaaaaaaaaaaa) 
#define	JNZ(addr)		    (0xB000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1011aaaaaaaaaaaa)
#define	JAZ(addr)		    (0xC000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1100aaaaaaaaaaaa)
#define JBZ(addr)		    (0xD000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1101aaaaaaaaaaaa)
#define JAEZ(addr)		    (0xE000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1110aaaaaaaaaaaa)
#define JBEZ(addr)		    (0xF000 + (uint16_t)addr)                           /*ZZZ*/ //(0b1111aaaaaaaaaaaa)

//CLR $x is alias to XOR $x $x $x
#define CLR(reg1) (0x1002 + (reg1 << 8) + (reg1 << 5) + (reg1 << 2))

#define REG(n) (tokens.at(tokensPos + n)->Str[1] - 'a')

#define REG3(instr)                                                                                 \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::Reg ||                                             \
    tokens.at(tokensPos + 3)->Type != TokenType::Reg) return false;                                 \
    *binDataPos = instr(REG(1), REG(2), REG(3));                                                    \
    tokensPos += 3;      

#define REG2(instr)                                                                                 \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::Reg) return false;                                 \
    *binDataPos = instr(REG(1), REG(2));                                                            \
    tokensPos += 2;    

#define REG1(instr)                                                                                 \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg) return false;                             \
    *binDataPos = instr(REG(1));                                                                    \
    tokensPos += 1;    

#define REG_NUM(instr)                                                                              \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::Num) return false;                                 \
    *binDataPos = instr(REG(1), tokens.at(tokensPos + 2)->Num);                                     \
    tokensPos += 2;

#define ADDR(instr)                                                                                 \
    if (tokens.at(tokensPos + 1)->Type != TokenType::FromLabel) return false;                       \
    *binDataPos = instr((uint16_t)(tokens.at(tokensPos + 1)->Num & 0x0000FFFF));                    \
    tokensPos++;                                                                                    \

#define REG1_MEM1(instr)                                                                            \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::Num) return false;                                 \
    *binDataPos = instr(REG(1));                                                                    \
    *++binDataPos = (uint16_t)(tokens.at(tokensPos + 2)->Num);                                      \
    tokensPos += 2;

#define REG1_MEM2(instr)                                                                            \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::Num) return false;                                 \
    *binDataPos = instr(REG(1));                                                                    \
    *++binDataPos = (uint16_t)((tokens.at(tokensPos + 2)->Num & 0xFFFF0000) >> 16);                 \
    *++binDataPos = (uint16_t)(tokens.at(tokensPos + 2)->Num & 0x0000FFFF);                         \
    tokensPos += 2;

#define REG_SREG(instr)                                                                             \
    if (tokens.at(tokensPos + 1)->Type != TokenType::Reg ||                                         \
    tokens.at(tokensPos + 2)->Type != TokenType::SpecReg) return false;                             \
    *binDataPos = instr(REG(1), tokens.at(tokensPos + 2)->Num);                                     \
    tokensPos += 2;

#endif


