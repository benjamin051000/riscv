/*
Various packages
Some are not used and will be removed eventually
*/

package rv32i_opcodes;
/* 
From RV32/64G Instruction Set Listings:
Table 24.1 RISC-V base opcode map, pg. 129 
of riscv-spec-20191213.pdf 
*/
// TODO inst[1:0] == 11b. Is there an optimization here?
typedef enum logic [6:0] {
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    BRANCH = 7'b1100011,
    MISC_MEM = 7'b0001111, // FENCE, FENCE.I instructions
    JALR = 7'b1100111,
    JAL = 7'b1101111,
    OP_IMM = 7'b0010011, // Immediate ALU instructions (ADDI, ANDI, etc.)
    OP = 7'b0110011, // Register ALU instructions (ADD, AND, etc.)
    SYSTEM = 7'b1110011, // ECALL, EBREAK, Zicsr instructions
    AUIPC = 7'b0010111,
    LUI = 7'b0110111
} rv32i_opcode_t;

// This is to aid in the clarity of the mux that feeds into the
// regfile_wr_data.
typedef enum logic [1:0] {
	FROM_ALU,
	FROM_MEM,
	FROM_PC_PLUS_4
} regfile_sel_t;

endpackage


package R_I;

localparam logic ADDI = 3'b000;

localparam logic SLTI = 3'b010;
localparam logic SLTIU = 3'b011;

localparam logic XORI = 3'b100;
localparam logic ORI = 3'b110;
localparam logic ANDI = 3'b111;

// localparam SLLI = ;
// localparam SRLI = ;
// localparam SRAI = ;

// load upper immediate
localparam logic LUI   = 7'b0110111;
// Add upper immediate to pc
localparam logic AUIPC = 7'b0010111;

endpackage


package U_J;

// jump and link
localparam logic JAL   = 7'b1101111;
// jump and link register
localparam logic JALR  = 7'b1100111;

endpackage



package LOAD_STORE;

localparam logic LOAD  = 7'b0000011; 
localparam logic STORE = 7'b0100011;

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

	localparam logic OUTPORT_ADDR = 16'hfffc;

endpackage
