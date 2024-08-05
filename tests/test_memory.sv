`timescale 1ns/10ps

import common::*;
import LOAD_STORE_FNS::*;

module test_memory;

localparam int WIDTH = 32;

logic clk = 1'b0, rst;
logic [WIDTH-1:0] addr, flash_addr; // TODO replace if not useful (<- what did I mean by that?)
logic wren = 1'b0;  // 0 -> rd, 1 -> wr
logic [WIDTH-1:0] wr_data, flash_data;
funct3_t funct3 = WORD; // Determine size (word, halfword, byte) TODO can I do LOAD_STORE_FNS.WORD ?
logic [WIDTH-1:0] rd_data, outport;
logic flash_en;

memory #(.WIDTH(WIDTH)) DUT (.*);

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

// This only works when in reset.
task automatic flash_mem;
	flash(11'd0, 32'h12345);
	flash(11'd4, 32'h6789a);
	flash(11'd12, 32'hffffffff);
endtask //flash_mem

initial begin : drive_inputs
	$timeformat(-9, 0, " ns");
	// the flash logic relies on these to be defined
	addr <= '0;
	wr_data <= '0;
	
    rst <= 1'b1;
    flash_mem();
	repeat(3) @(posedge clk);
    rst <= 1'b0;

    // Attempt to read from the addresses
    addr <= 0;
    delay(clk, 2);
	if (rd_data != 32'h12345) $display("[%t] Read: Error: Correct=0x12345, Actual=%h", $realtime, rd_data);

    addr <= 4;
    delay(clk, 2);
	if (rd_data != 32'h6789a) $display("[%t] Read: Error: Correct=0x6789a, Actual=%h", $realtime, rd_data);

    addr <= 12;
    delay(clk, 2);
	if (rd_data != 32'hffffffff) $display("[%t] Read: Error: Correct=0xffffffff, Actual=%h", $realtime, rd_data);

    // Test writes
    addr <= 8;
    wr_data <= 101010; // Decimal
	pulse(clk, wren, 1);
	if (rd_data != 101010) $display("[%t] Write: Error: Correct=101010, Actual=%h", $realtime, rd_data);

	// Test outport
	addr <= OUTPORT_ADDR;
	wr_data <= 32'hdeadbeef;
	pulse(clk, wren, 1);
	if (outport != 32'hdeadbeef) $display("Error: Outport");

	if (rd_data == 32'hdeadbeef) $display("Error: Writing to outport overwrote ram too.");

    disable generate_clk;
    $display("Done.");
end

endmodule
