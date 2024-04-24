`timescale 1ns/10ps

import common::*;
import LOAD_STORE_FNS::*;

module test_memory;

localparam WIDTH = 32;

logic clk = 1'b0, rst;
logic [WIDTH-1:0] addr; // TODO replace if not useful
logic wren = 1'b0;  // 0 -> rd, 1 -> wr
logic [WIDTH-1:0] wr_data;
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

task automatic flash_mem();
    addr <= 0;
    wr_data <= 12345;
	pulse(clk, flash_en, 1);


    addr <= 4;
    wr_data <= 678910;
	pulse(clk, flash_en, 1);

    addr <= 12;
    wr_data <= 32'hdeadbeef; // WARNING: Redundant digits in numeric literal
	pulse(clk, flash_en, 1);

endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    rst <= 1'b0;

    // Attempt to read from the addresses
    addr <= 0;
    delay(clk, 3);

    addr <= 4;
    delay(clk, 3);

    addr <= 12;
    delay(clk, 3);

    // Test writes
    addr <= 8;
    wr_data <= 101010; // Decimal
    wren <= 1'b1;
    delay(clk, 3);
    wren <= 1'b0;
    delay(clk, 5);

    disable generate_clk;
    $display("Done.");
end

endmodule
