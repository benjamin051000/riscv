package types;

localparam IMM   = 7'b0010011;
localparam R   = 7'b0110011;
localparam S =  7'b0100011;
localparam B = 7'b1100011;
localparam J = 7'b1101111;
localparam I = 7'b1100111;

localparam ECALL = 7'b1110011;
localparam EBREAK = 7'b1110011;

endpackage


package R_I;

localparam ADDI = 3'b000;

localparam SLTI = 3'b010;
localparam SLTIU = 3'b011;

localparam XORI = 3'b100;
localparam ORI = 3'b110;
localparam ANDI = 3'b111;

// localparam SLLI = ;
// localparam SRLI = ;
// localparam SRAI = ;

// load upper immediate
localparam LUI   = 7'b0110111;
// Add upper immediate to pc
localparam AUIPC = 7'b0010111;

endpackage


package U_J;

// jump and link
localparam JAL   = 7'b1101111;
// jump and link register
localparam JALR  = 7'b1100111;

endpackage



package LOAD_STORE;

localparam LOAD  = 7'b0000011; 
localparam STORE = 7'b0100011;

endpackage


package ALU_FNS;

typedef enum logic [2:0]  {
    ADD_SUB = 3'h0,

    SLT = 3'h2,
    SLTU = 3'h3,

    AND = 3'h7,
    OR = 3'h6,
    XOR = 3'h4,

    SLL = 3'h1,
    SRL_SRA = 3'h5
} alu_fn_t;

// funct7 is the top 7 bits in Integer Reg-Reg Operations (pg. 19)
typedef enum logic [31:25] {
    ADD_SRL = '0,
    SUB_SRA = 7'b0100000//(1'b1 << 5)
} funct7_t;

endpackage

package LOAD_STORE_FNS;
    typedef enum logic [2:0] {
        BYTE = 3'b000,
        HALF = 3'b001,
        WORD = 3'b010,
        // Load unsigned (don't zero-extend)
        BYTE_U = 3'b100,
        HALF_U = 3'b101 
    } funct3_t;
endpackage
