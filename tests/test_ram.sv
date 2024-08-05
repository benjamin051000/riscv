/*
* This file is mainly to test the Quartus-generated RAM.
* We know this should work fine, so this is mostly a sanity check.
*/
`timescale 1ns/10ps

import common::*;
import LOAD_STORE_FNS::*;

module test_ram;

logic clk = 1'b0;
logic wren = 1'b0;

logic [10:0] addr;
logic [31:0] wr_data, rd_data;

ram	ram_inst (
	// .address(word_addr[12:2]),
    .address(addr),
	.clock(clk),
	.data(wr_data),
	.wren(wren),
	.q(rd_data)
);

//////////////////////////////////

initial begin : generate_clk
    while(1) begin
        #5;
        clk = ~clk;
    end 
end

/*
* Writes the following data:
* 0: 1 
* 1: 6
* 2: a
*/
task automatic flash_mem();
    addr <= 0;
    wr_data <= 1;
	pulse(clk, wren, 1);

    addr <= 4; // Gets >> 2, so real addr is 1
    wr_data <= 6;
	pulse(clk, wren, 1);

    addr <= 12;
    wr_data <= 8'ha; // TODO why did I write it like this?
	pulse(clk, wren, 1);
	$display("Flashed.");
endtask //flash_mem

initial begin : drive_inputs
	$display("Any errors will be printed.");
    flash_mem();

    // Attempt to read from the addresses
    addr <= 0;
    delay(clk, 3);
	if (rd_data != 1) $display("Error");

    addr <= 4;
    delay(clk, 3);
	if (rd_data != 6) $display("Error");

    addr <= 12;
    delay(clk, 3);
	if (rd_data != 8'ha) $display("Error");

    // Test writes
    addr <= 8;
    wr_data <= 100;
	pulse(clk, wren, 1);
	delay(clk, 2);

	if (rd_data != 100) $display("Error");

    disable generate_clk;
    $display("Done.");
end

// assert property (@(posedge clk) )

endmodule
