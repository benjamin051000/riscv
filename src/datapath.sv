import ALU_FNS::*;
import LOAD_STORE_FNS::*;
import rv32i_opcodes::rv32i_opcode_t;

module datapath #(
    parameter int WIDTH 
) (
    input logic clk, rst,
    input logic regfile_wren, ir_wren, pc_inc,
    output rv32i_opcode_t opcode,
    output logic[WIDTH-1:0] outport,

    input logic flash_en,
    input logic [10:0] flash_addr,
    input logic [WIDTH-1:0] flash_data
);

// Type alias for convenience
typedef logic [WIDTH-1:0] word; // TODO move to a common pkg


// Program counter
word pc_d, pc_q, pc_en;
register #(.WIDTH(WIDTH)) _pc (.d(pc_d), .q(pc_q), .en(pc_inc), .*);
// Something cool happens here: In RTL viewer, this synthesizes to 
// an add between 1'h1 and pc_q[31:2]. Then, it concats the result with pc_q[1:0].
// Since +4 doesn't affect lower two bits, it doesn't include them in the addition, just adds them back after the add.
// Perhaps this saves resources or something. TODO look into why Quartus does this optimization.
assign pc_d = pc_q + 4;


// Memory
word mem_addr, mem_wr_data, mem_rd_data;
logic mem_wren;
funct3_t mem_funct3;
memory #(.WIDTH(WIDTH)) _mem (
    .clk(clk),
    .rst(rst),
    .addr(mem_addr),
    .wren(mem_wren),
    .wr_data(mem_wr_data),
    .funct3(mem_funct3),
    .rd_data(mem_rd_data),
    .*  // TODO figure out what this is for
    .outport(outport)
);
assign mem_addr = pc_q;
assign mem_wren = '0; // TODO remove
assign mem_wr_data = '1; // TODO remove
assign mem_funct3 = WORD;


// Instruction register
word ir_d, instruction;
register #(.WIDTH(WIDTH)) _ir (.d(ir_d), .q(instruction), .en(ir_wren), .*);
assign ir_d = mem_rd_data;
assign opcode = rv32i_opcode_t'(instruction[6:0]);

// TODO put someplace nicer, modelsim needs this declaration above all uses unlike Quartus
word alu_out;

// Register file
logic [$clog2(WIDTH)-1:0] regfile_addr_a, regfile_addr_b, regfile_wr_addr;
word regfile_wr_data;
word regfile_a, regfile_b, wr_data;
regfile #(.WIDTH(WIDTH)) _regfile (
    clk, rst,
    regfile_wren,
    regfile_addr_a,
    regfile_addr_b,
    regfile_wr_addr,
    regfile_wr_data,
    regfile_a,
    regfile_b
);
assign regfile_addr_a = instruction[19:15];
assign regfile_addr_b = instruction[24:20];
assign regfile_wr_addr = instruction[11:7];
word alu_out;
assign regfile_wr_data = alu_out;

// ALU
alu_fn_t fn;
funct7_t funct7;
word alu_a, alu_b;
alu #(.WIDTH(WIDTH)) _alu (.a(alu_a), .b(alu_b), .out(alu_out), .*);
assign alu_a = regfile_a;
assign alu_b = regfile_b;
assign fn = alu_fn_t'(instruction[14:12]);
assign funct7 = funct7_t'(instruction[31:25]);

endmodule
