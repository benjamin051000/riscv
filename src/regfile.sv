
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
    output logic [WIDTH-1:0] a, b // Data (rs1, rs2, respectively)

);

logic [WIDTH-1:0][WIDTH-1:0] registers;

assign a = registers[addr_a];
assign b = registers[addr_b];


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < WIDTH; i++)
            registers[i] <= '0;
    end
    else begin
        // Can't overwrite x0, it's a constant 0 always.
        if (wr_en && wr_addr != 0)
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
