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


package ALU_FN;

localparam ADD = 3'h0;
localparam SUB = 3'h0;

localparam SLT = 3'h2;
localparam SLTU = 3'h3;

localparam AND = 3'h7;
localparam OR = 3'h6;
localparam XOR = 3'h4;

localparam SLL = 3'h1;
localparam SRL = 3'h5;
localparam SRA = 3'h5;

endpackage
