import ALU_FNS::*;

module datapath #(
    parameter int WIDTH = 32
) (
    input logic clk, rst, sel
);

logic [WIDTH-1:0] addr_a, addr_b, wr_addr;
logic wr_en;
logic [WIDTH-1:0] a, b, wr_data;
alu_fn_t fn;
funct7_t funct7;
logic [WIDTH-1:0] out;

assign wr_data = out;

logic [WIDTH-1:0] d, q;
logic  en;

register #(.WIDTH(WIDTH)) _ir (.*);

regfile #(.WIDTH(WIDTH)) _regfile (.*);

assign alu_inb = sel ? b : q;

alu #(.WIDTH(WIDTH)) _alu (.b(alu_inb), .*);

endmodule
