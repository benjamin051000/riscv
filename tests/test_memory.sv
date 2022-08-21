`timescale 1ns/10ps

import LOAD_STORE_FNS::*;

module test_memory;

localparam WIDTH = 32;

logic clk = 1'b0, rst;
logic [WIDTH-1:0] addr; // TODO replace if not useful
logic wren = 1'b0;  // 0 -> rd, 1 -> wr
logic [WIDTH-1:0] wr_data;
funct3_t funct3 = WORD; // Determine size (word, halfword, byte)
logic [WIDTH-1:0] rd_data, outport;

// Flash the memory
logic flash_en;
logic [$bits(addr)-1:0] flash_addr;
logic [WIDTH-1:0] flash_data;

memory #(.WIDTH(WIDTH)) DUT (.*);

//////////////////////////////////

initial begin : generate_clk
    while(1) begin
        #5;
        clk = ~clk;
    end 
end

task automatic flash_mem();
    flash_addr <= 0;
    flash_data <= 12345;
    flash_en <= 1'b1;
    @(posedge clk);
    flash_en <= 1'b0;
    @(posedge clk);


    flash_addr <= 4;
    flash_data <= 678910;
    flash_en <= 1'b1;
    @(posedge clk);
    flash_en <= 1'b0;
    @(posedge clk);

    flash_addr <= 12;
    flash_data <= 8'hdeadbeef;
    flash_en <= 1'b1;
    @(posedge clk);
    flash_en <= 1'b0;
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
    wr_data <= 101010; // Decimal
    wren <= 1'b1;
    delay(3);
    wren <= 1'b0;
    delay(5);

    
    

    // delay(20);

    disable generate_clk;
    $display("Done.");
end



endmodule