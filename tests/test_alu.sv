`timescale 1ns/10ps

import ALU_FN::*;

module test_alu;

localparam WIDTH = 32;

logic [2:0] fn;
logic [31:25] funct7; // For Integer Register-Register Operations
logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [WIDTH-1:0] out;

alu #(.WIDTH(WIDTH)) DUT (.*);

initial begin
    fn = AND;
    funct7 = '0;
    a = 23;
    b = 11;
    #10;
    $display("Done.");
end

endmodule
