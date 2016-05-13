enum class TokenType
{
    NoType      = 0,
    Instr       = 1,
    Reg         = 2,
    ToLabel     = 3,
    FromLabel   = 4,
    Num         = 5,
    SpecReg     = 6,
    Directive   = 7
};

enum class Instruction
{
    NoInstruction,
#define DEF_INSTR(name, str) \
    name,
#include "def_instr.h"
#undef DEF_INSTR
    NotUsed
};

class Token
{
    public:
    Token(const char *str, size_t len, TokenType type, Instruction instr, uint32_t num);
    ~Token();

    const char *Str;
    size_t Len;
    TokenType Type;
	Instruction Instr;
    uint32_t Num;
};

Token::Token(const char *str, size_t len, TokenType type, Instruction instr, uint32_t num)
    :Str (str), Len (len), Type (type), Instr (instr),  Num (num) {}

Token::~Token() {}