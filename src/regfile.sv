
/**
* Async Read
*/
module regfile_async #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic wr_en,
    input logic [$clog2(WIDTH)-1:0] addr_a, addr_b, wr_addr, // Addresses
    input logic [WIDTH-1:0] wr_data,
    output logic [WIDTH-1:0] a, b // Data

);

logic [WIDTH-1:0][WIDTH-1:0] registers;

assign a = registers[addr_a];
assign b = registers[addr_b];


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        registers <= '0;
    end
    else begin
        if (wr_en)
            registers[wr_addr] <= wr_data;
    end
end
endmodule


module regfile #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic wr_en,
    input logic [$clog2(WIDTH)-1:0] addr_a, addr_b, wr_addr, // Addresses
    input logic [WIDTH-1:0] wr_data,
    output logic [WIDTH-1:0] a, b // Data
);

regfile_async #(.WIDTH(WIDTH)) regf (.*);

endmodule
