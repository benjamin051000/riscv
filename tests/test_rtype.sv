`timescale 1ns/10ps

module test_rtype;

localparam WIDTH = 32;

logic clk = 1'b0, rst;
logic flash_en = 1'b0;
logic [10:0] flash_addr = '0;
logic [WIDTH-1:0] flash_data = '0;


top #(.WIDTH(WIDTH)) DUT (.*);

//////////////////////////////////

initial begin : generate_clk
    while(1) begin
        #5;
        clk = ~clk;
    end 
end

task automatic flash_mem();
    flash_addr = 0;
    flash_data = 12345;
    flash_en = 1'b1;
    @(posedge clk);
    flash_en = 1'b0;

    flash_addr = 4;
    flash_data = 678910;
    flash_en = 1'b1;
    @(posedge clk);
    flash_en = 1'b0;
endtask //flash_mem

initial begin : drive_inputs
    rst <= 1'b1;
    flash_mem();
    for(int i = 0; i < 3; i++) @(posedge clk);
    rst <= 1'b0;


    for(int i = 0; i < 20; i++) @(posedge clk);

    disable generate_clk;
    $display("Done.");
end

endmodule