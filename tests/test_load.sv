`default_nettype none
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
        #5;
        clk = ~clk;
    end 
end

task automatic flash_mem();
    flash_addr <= 0;
    flash_data <= 32'h01002083; // lw x1, 8(x0) // BUG: offset of 16 is decoded as r-type
	pulse(clk, flash_en, 1);

    flash_addr <= 4;
    flash_data <= 32'h00008133; // add x2, x1, x0
	pulse(clk, flash_en, 1);

    flash_addr <= 16;
    flash_data <= 32'hdeadbeef; // data to be loaded into x1
	pulse(clk, flash_en, 1);
endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    rst <= 1'b0;

    for(int i = 0; i < 20; i++) @(posedge clk);

    disable generate_clk;
    $display("Done.");
end

endmodule
