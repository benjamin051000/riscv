import ALU_FNS::*;
import LOAD_STORE_FNS::*;
import rv32i_opcodes::*;
import U_J::*;

module datapath #(
    parameter int WIDTH = 32
) (
	input logic clk, rst,
	// Register enables
	input logic regfile_wren, ir_wren, pc_inc, mem_wren,
	output rv32i_opcode_t opcode,
	output logic [WIDTH-1:0] outport,

	// Mux selectors
	input logic ram_raddr_31_20,
	input regfile_sel_t regfile_sel_from_alu_mem_pcp4,
	input jump_type_t jumping,

	input logic flash_en,
	input logic [WIDTH-1:0] flash_addr,
	input logic [WIDTH-1:0] flash_data
);

// Type alias for convenience
typedef logic [WIDTH-1:0] word; // TODO move to a common pkg

// modelsim needs this declaration above all uses unlike Quartus
word alu_out;

// Program counter
word pc_d, pc_q;
register #(.WIDTH(WIDTH)) _pc (.d(pc_d), .q(pc_q), .en(pc_inc), .*);
// Something cool happens here: In RTL viewer, this synthesizes to 
// an add between 1'h1 and pc_q[31:2]. Then, it concats the result with pc_q[1:0].
// Since +4 doesn't affect lower two bits, it doesn't include them in the addition, just adds them back after the add.
// Perhaps this saves resources or something. TODO look into why Quartus does this optimization. Is +1 more efficient than +4?
// Update: It probably is more efficient because instead of requiring a 32-bit
// adder, we get a 30-bit adder.
word jump_pc_d, next_inst_pc_d;

// For J-type jumps (e.g., JAL)
word jump_j_type_pc_d;

// Instruction register (IR) output.
word instruction;

// NOTE: - 4 because we've already set up + 4 for next instruction. 
// TODO is there a nicer way to handle this?
assign jump_pc_d = pc_q - 4 + alu_out; 
assign next_inst_pc_d = pc_q + 4;
// J-type has a weird immediate value encoding. See RISC-V unprivileged spec
// for details.
// TODO figure out how to sign-extend this instruction thing
word ir_j_arrangement;
assign ir_j_arrangement = WIDTH'(signed'({instruction[31], instruction[19:12], instruction[20], instruction[30:21]}));
assign jump_j_type_pc_d = pc_q - 4 + ir_j_arrangement;

always_comb begin: next_pc
	unique case (jumping)
	NOT_JUMPING: begin
		pc_d = next_inst_pc_d;
	end

	JUMP_I_TYPE: begin
		pc_d = jump_pc_d;
	end

	JUMP_J_TYPE: begin
		pc_d = jump_j_type_pc_d;
	end
		
	endcase
end


// Memory
word mem_addr, mem_wr_data, mem_rd_data, regfile_b;
funct3_t mem_funct3;
memory #(.WIDTH(WIDTH)) _mem (
    .clk(clk),
	 .rst(rst),
    .addr(mem_addr),
	.flash_addr(flash_addr),
    .wren(mem_wren),
    .wr_data(mem_wr_data),
	.flash_data(flash_data),
    .funct3(mem_funct3),
    .rd_data(mem_rd_data),
    .outport(outport),
    .*  // TODO figure out what this is for
);
assign mem_addr = ram_raddr_31_20 ? instruction[31:20] : pc_q;
assign mem_wr_data = regfile_b;
assign mem_funct3 = WORD;


// Instruction register
word ir_d;
register #(.WIDTH(WIDTH)) _ir (.d(ir_d), .q(instruction), .en(ir_wren), .*);
assign ir_d = mem_rd_data;
assign opcode = rv32i_opcode_t'(instruction[6:0]);

// Register file
logic [$clog2(WIDTH)-1:0] regfile_addr_a, regfile_addr_b, regfile_wr_addr;
word regfile_wr_data;
word regfile_a, wr_data;
regfile #(.WIDTH(WIDTH)) _regfile (
	.clk(clk),
	.rst(rst),
	.wr_en(regfile_wren),
	.addr_a(regfile_addr_a),
	.addr_b(regfile_addr_b),
	.wr_addr(regfile_wr_addr),
	.wr_data(regfile_wr_data),
	.a(regfile_a),
	.b(regfile_b)
);
assign regfile_addr_a = instruction[19:15];
assign regfile_addr_b = instruction[24:20];
assign regfile_wr_addr = instruction[11:7];
// Moved this to its own module because it doesn't map nicely in RTL viewer...
// and for modularity of course!
regfile_wr_data_mux #($bits(regfile_wr_data)) _mux (.*);

// ALU
alu_fn_t fn;
funct7_t funct7;
word alu_a, alu_b;
alu #(.WIDTH(WIDTH)) _alu (.a(alu_a), .b(alu_b), .out(alu_out), .*);

assign alu_a = regfile_a;
// If i-type, use the sign-extended 12-bit immediate value. That's pretty
// much the only difference between i-type and r-type.
// TODO what should the default value be?
assign alu_b = opcode == OP_IMM | opcode == JALR ? 32'(signed'(instruction[31:20])) : regfile_b;
assign fn = alu_fn_t'(instruction[14:12]);
assign funct7 = funct7_t'(instruction[31:25]);

endmodule
