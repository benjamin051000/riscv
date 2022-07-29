`timescale 1ns/10ps

import LOAD_STORE_FNS::*;

module test_ram;

logic clk = 1'b0, rst;
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

task automatic flash_mem();
    addr <= 0;
    wr_data <= 1;
    wren <= 1'b1;
    @(posedge clk);
    wren <= 1'b0;
    @(posedge clk);


    addr <= 4;
    wr_data <= 6;
    wren <= 1'b1;
    @(posedge clk);
    wren <= 1'b0;
    @(posedge clk);

    addr <= 12;
    wr_data <= 8'ha;
    wren <= 1'b1;
    @(posedge clk);
    wren <= 1'b0;
    @(posedge clk);
endtask //flash_mem

task automatic delay(input int n);
    for(int i = 0; i < n; i++) @(posedge clk);
endtask

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    rst <= 1'b0;

    // Attempt to read from the addresses
    addr <= 0;
    delay(3);

    addr <= 4;
    delay(3);

    addr <= 12;
    delay(3);

    // Test writes
    addr <= 8;
    wr_data <= 100;
    wren <= 1'b1;
    delay(3);
    wren <= 1'b0;
    delay(5);

    disable generate_clk;
    $display("Done.");
end

endmodule