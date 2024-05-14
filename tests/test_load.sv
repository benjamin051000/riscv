`timescale 1ns/10ps

import common::*;

module test_load;

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
        #5 clk = ~clk;
    end 
end

task automatic flash(logic [$bits(flash_addr)-1:0] addr, logic [$bits(flash_data)-1:0] data);
	flash_addr <= addr;
	flash_data <= data;
	pulse(clk, flash_en, 1);
endtask

task automatic flash_mem();
	// Let's load various values into registers to make sure it all works
	// nicely. Align them to words, because I think it's UB to lw at
	// a non-word-aligned address. TODO verify this.
	flash(11'd16,  32'hbeef0016);
	flash(11'd20,  32'hbeef0020);
	flash(11'd24,  32'hbeef0024);
	flash(11'd28,  32'hbeef0028);

	// Here's the code to load each one (thanks, compiler explorer).
	flash(11'd0, 32'h01002083); // lw ra, 16(zero) ; ra == x1
	flash(11'd4, 32'h01402103); // lw sp, 20(zero) ; sp == x2
	flash(11'd8, 32'h01802183); // lw gp, 24(zero) ; gp == x3
	flash(11'd12,32'h01c02203); // lw tp, 28(zero) ; tp == x4

	// Just a marker so I know where the flashing ends.
	flash(11'd32, 32'hdeaddead); // One word after last instruction
endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    rst <= 1'b0;

    repeat(30) @(posedge clk);

    disable generate_clk;
    $display("Done.");
end

endmodule
