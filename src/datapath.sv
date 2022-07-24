import ALU_FNS::*;

module datapath #(
    parameter int WIDTH 
) (
    input logic clk, rst
);

// Type alias for convenience
typedef logic [WIDTH-1:0] word; // TODO move to a common pkg


// Program counter
word pc_d, pc_q, pc_en;
register #(.WIDTH(WIDTH)) _pc (.d(pc_d), .q(pc_q), .en(pc_en), .*);


// Memory
word mem_addr, mem_wren, mem_wr_data, mem_rd_data;
memory #(.WIDTH(WIDTH)) _mem (
    .clk(clk),
    .rst(rst),
    .addr(mem_addr),
    .wren(mem_wren),
    .wr_data(mem_wr_data),
    .rd_data(mem_rd_data)
);
assign mem_addr = pc_q;


// Instruction register
word ir_d, instruction;
logic ir_en;
register #(.WIDTH(WIDTH)) _ir (.d(ir_d), .q(instruction), .en(ir_en), .*);
assign ir_d = mem_rd_data;


// Register file
logic [4:0] regfile_addr_a, regfile_addr_b, regfile_wr_addr;
word regfile_wr_data;
logic regfile_wr_en;
word regfile_a, regfile_b, wr_data;
regfile #(.WIDTH(WIDTH)) _regfile (
    clk, rst,
    regfile_wr_en,
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
assign regfile_wr_data = alu_out;

// ALU
alu_fn_t fn;
funct7_t funct7;
word alu_a, alu_b, alu_out;
alu #(.WIDTH(WIDTH)) _alu (.a(alu_a), .b(alu_b), .out(alu_out), .*);
assign alu_a = regfile_a;
assign alu_b = regfile_b;
assign fn = alu_fn_t'(instruction[14:12]);
assign funct7 = funct7_t'(instruction[31:25]);

endmodule
