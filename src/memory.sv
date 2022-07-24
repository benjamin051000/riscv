module memory #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr, // TODO replace if not useful
    input logic wren,  // 0 -> rd, 1 -> wr
    input logic [WIDTH-1:0] wr_data,
    output logic [WIDTH-1:0] rd_data
);

// TODO Handle byte addressing
// TODO ram addr is 12 bits wide... not sure how SV handles this by default
ram	ram_inst (
	.address (addr),
	.clock (clk),
	.data (wr_data),
	.wren (wren),
	.q (rd_data)
	);

endmodule
