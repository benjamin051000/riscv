import rv32i_opcodes::rv32i_opcode_t;

module top #(
    parameter int WIDTH = 32
) (
    input logic clk, rst
);

logic regfile_wren;
rv32i_opcode_t opcode;

controller #(.WIDTH(WIDTH)) _controller (.*);

datapath #(.WIDTH(WIDTH)) _datapath (.*);

endmodule
