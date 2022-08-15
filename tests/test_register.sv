`timescale 1ns/10ps

module test_register;

localparam NUM_TESTS = 1000;
localparam WIDTH = 32;

logic clk, rst = 1'b1, en = 1'b0;
logic[WIDTH-1:0] d, q;

register #(.WIDTH(WIDTH)) DUT (.*);

initial begin : generate_clk
    clk = 1'b0;
    while(1) #5 clk = ~clk;
end

initial begin : drive_inputs
    $timeformat(-9, 0, "ns");

    rst <= 1'b1;
    for(int i = 0; i < 5; i++) @(posedge clk);
    rst <= 1'b0;

    for(int i = 0; i < NUM_TESTS; i++) begin
        d <= $random;
        en <= $random;
        @(posedge clk);
    end

    disable generate_clk;
    $display("Done.");
end

assert property (@(posedge clk) disable iff (rst) en |=> q == $past(d, 1))
    else $error("d not saved when enabled.");

assert property (@(posedge clk) disable iff (rst) !en |=> $stable(q))
    else $error("q not stable when not enabled.");

always @(rst) assert (q == '0)
    else $error("q not 0 when reset.");

endmodule
