import LOAD_STORE_FNS::*;

module memory #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr, // TODO replace if not useful
    input logic wren,  // 0 -> rd, 1 -> wr
    input logic [WIDTH-1:0] wr_data,
    input funct3_t funct3, // Determine size (word, halfword, byte)
    output logic [WIDTH-1:0] rd_data
);

logic [1:0] byte_num; // lowest 2 bits
logic [WIDTH-1-2:0] word_addr;
logic [WIDTH-1:0] q;

// Extract actual address and byte address
assign {word_addr, byte_num} = addr;

// TODO Handle byte addressing
// TODO ram addr is 12 bits wide... not sure how SV handles this by default
ram	ram_inst (
	.address(word_addr),
	.clock(clk),
	.data(wr_data),
	.wren(wren),
	.q(q)
);

// Handle byte-addressing
always_comb begin
    case (funct3)
    WORD: rd_data = q; // Nothing to do here

    HALF: begin
        if(byte_num == 2'b00) rd_data = q & 4'hffff;
        else rd_data = q & (4'hffff << 16) >> 16;
    end

    BYTE: begin
        // TODO make this simpler
        if(byte_num == 2'b00) rd_data = q & 2'hff;
        else if(byte_num == 2'b01) rd_data = q & (2'hff << 8) >> 8;
        else if(byte_num == 2'b10) rd_data = q & (2'hff << 16) >> 16;
        else rd_data = q & (2'hff << 24) >> 24;
    end

    default: rd_data = q; // TODO remove
    endcase
end


endmodule
