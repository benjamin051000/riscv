`timescale 1ns/10ps
import common::*;

module test_jumps;

localparam WIDTH = 32;

logic clk = 1'b0, rst;
logic [WIDTH-1:0] flash_addr;
logic [WIDTH-1:0] flash_data;
logic flash_en;
logic [WIDTH-1:0] outport;

top #(.WIDTH(WIDTH)) DUT (.*);

//////////////////////////////////

initial begin : generate_clk
    while(1) begin
        #5;
        clk = ~clk;
    end 
end

task automatic flash(logic [$bits(flash_addr)-1:0] addr, logic [$bits(flash_data)-1:0] data);
	flash_addr <= addr;
	flash_data <= data;
	pulse(clk, flash_en, 1);
endtask

task automatic flash_mem();

	flash(11'd0, 32'h00c64633); // xor  a2, a2, a2; set it to 0
	// loop:
	flash(11'd4, 32'h00160613); // addi a2, a2, 1 ; increment
	// flash(11'd8, 32'hffdff06f); // j loop -> jal zero, -4 ; from riscv assembler
	flash(11'd8, 32'hffc00067); // jalr zero, -4 ; back to the loop

endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    for(int i = 0; i < 3; i++) @(posedge clk);
    rst <= 1'b0;

    repeat(20) @(posedge clk);

    disable generate_clk;
    $display("Done.");
end

endmodule
