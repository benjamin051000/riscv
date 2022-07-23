
/**
* Async Read
*/
module regfile_async #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr_a, addr_b, wr_addr, wr_data,
    input logic wr_en,
    output logic [WIDTH-1:0] a, b 
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
    input logic [WIDTH-1:0] addr_a, addr_b, wr_addr, wr_data,
    input logic wr_en,
    output logic [WIDTH-1:0] a, b 
);

regfile_async #(.WIDTH(WIDTH)) regf (.*);

endmodule
