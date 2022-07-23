import ALU_FNS::*;

module datapath #(
    parameter int WIDTH = 32
) (
    input logic clk, rst, sel
);

logic [WIDTH-1:0] addr_a, addr_b, wr_addr, alu_inb;
logic wr_en;
logic [WIDTH-1:0] a, b, wr_data;
alu_fn_t fn;
funct7_t funct7;
logic [WIDTH-1:0] out;

assign wr_data = out;

logic [WIDTH-1:0] d, q;
logic  en;

logic [WIDTH-1:0] mem_addr, mem_data;

logic [WIDTH-1:0] d_pc, q_pc;
register #(.WIDTH(WIDTH)) _pc (.d(d_pc), .q(q_pc));
assign mem_addr = q_pc;

memory #(.WIDTH(WIDTH)) _memory (.addr(mem_addr), .data(mem_data));

logic [WIDTH-1:0] instruction;
assign instruction = mem_data;
register #(.WIDTH(WIDTH)) _ir (.d(instruction), .*);

regfile #(.WIDTH(WIDTH)) _regfile (.*);

// assign alu_inb = sel ? b : q;
assign alu_inb = b;

alu #(.WIDTH(WIDTH)) _alu (.b(alu_inb), .*);

endmodule
