`timescale 1ns/10ps
import common::*;

module test_itype;

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
	// Starting values
	flash(11'd40,  32'h1);

	// Load starting values
	flash(11'd0, 32'h02802783); // lw a5, 36(zero) # a5 == x15
	flash(11'd4, 32'h02802803); // lw a6, 40(zero) # a6 == x16
	
	// Do some math
	flash(11'd8, 32'h07b00593); // addi a1, zero, 123 # a<n> == x<10+n> (for 1-7)
	flash(11'd12, 32'h00f5f613); // andi a2, a1, 0xF
	flash(11'd16, 32'h00466693); // ori a3, a2, 4
	// Test shifting because it might be weird (?)
	flash(11'd20, 32'h00159693); // slli a3, a1, 1
	flash(11'd24, 32'h4016d693); // srli a3, a3, 1

	// Test that arithmetic right shift
	flash(11'd28, 32'h00100713); // addi a4, zero, 1 TODO is this right? If not copy the load word from above.
	flash(11'd32, 32'h01f71713); // slli a4, a4, 31
	flash(11'd36, 32'h41e75713); // srai a4, a4, 30 // should put a bunch of ones

endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    for(int i = 0; i < 3; i++) @(posedge clk);
    rst <= 1'b0;

    repeat(40) @(posedge clk);

    disable generate_clk;
    $display("Done.");
end

endmodule
