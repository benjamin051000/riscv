import rv32i_opcodes::*;

module top #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,

    input logic flash_en,
    input logic [WIDTH-1:0] flash_addr,
    input logic [WIDTH-1:0] flash_data,
    output logic[WIDTH-1:0] outport
);

logic regfile_wren, ir_wren, pc_inc, mem_wren;
logic ram_raddr_31_20, jumping;
regfile_sel_t regfile_sel_from_alu_mem_pcp4;
rv32i_opcode_t opcode;

controller #(.WIDTH(WIDTH)) _controller (.*);

datapath #(.WIDTH(WIDTH)) _datapath (.*);

endmodule
