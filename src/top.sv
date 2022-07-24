module top #(
    parameter int WIDTH = 32
) (
    input logic clk, rst
);

controller #(.WIDTH(WIDTH)) _controller (.*);

datapath #(.WIDTH(WIDTH)) _datapath (.*);

endmodule
