`timescale 1ns/10ps

module test_register;

localparam NUM_TESTS = 1000;
localparam WIDTH = 32;

logic clk = 1'b0, rst, en;
logic[WIDTH-1:0] d, q;

register #(.WIDTH(WIDTH)) DUT (.*);

always begin : generate_clk
    #5 clk = ~clk;
end

initial begin : drive_inputs
    $timeformat(-9, 0, "ns");

    for(int i = 0; i < NUM_TESTS; i++) begin
        rst <= $random;
        d <= $random;
        en <= $random;
        @(posedge clk);
    end
    $display("Done.");

    disable generate_clk;
end

assert property (@(posedge clk) disable iff (rst) en |=> q == $past(d, 1));
assert property (@(posedge clk) disable iff (rst) !en |=> $stable(q));

endmodule
