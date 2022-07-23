import ALU_FNS::*;

module datapath #(
    parameter int WIDTH = 32
) (
    input logic clk, rst
);

logic [WIDTH-1:0] addr_a, addr_b, wr_addr;
logic wr_en;
logic [WIDTH-1:0] a, b, wr_data;
alu_fn_t fn;
funct7_t funct7;
logic [WIDTH-1:0] out;

assign wr_data = out;

regfile #(.WIDTH(WIDTH)) _regfile (.*);

alu #(.WIDTH(WIDTH)) _alu (.*);

endmodule
