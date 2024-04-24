import LOAD_STORE_FNS::*;

module memory #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr, // TODO replace if not useful
    input logic wren,  // 0 -> rd, 1 -> wr
    input logic [WIDTH-1:0] wr_data,
    input funct3_t funct3, // Determine size (word, halfword, byte)
    output logic [WIDTH-1:0] rd_data,

	// When the memory is in rst (rst = 1), assert flash_en 
	// to write to the memory. 
	// TODO What's an actual good way to load the memory? Bootloader? Research.
    input logic flash_en,

    // Outport
    output logic [WIDTH-1:0] outport
);

// logic [1:0] byte_num; // lowest 2 bits
// logic [WIDTH-1:2] word_addr; // All but lowest 2
logic [WIDTH-1:0] q;

logic ram_wren;

// Extract actual address and byte address
// assign {word_addr, byte_num} = addr;

// TODO Handle byte addressing
// TODO ram addr is 12 bits wide... not sure how SV handles this by default
ram	ram_inst (
	// .address(word_addr[12:2]),
    .address(addr[10:0]), // TODO Implement byte-addressing. It currently doesn't exist.
	.clock(clk),
	.data(wr_data),
	.wren(ram_wren),
	.q(q)
);

/* assign ram_addr = flash_en ? flash_addr[12:2] : addr[12:2]; // NOTE: Be sure to bit shift by 2 to accomodate for this. At least until we have byte-addressing */
assign ram_wren = ((rst & flash_en) | wren) & addr != OUTPORT_ADDR;

logic outport_wren;
register #(.WIDTH(WIDTH)) _outport (
    .clk(clk),
    .rst(rst),
    .en(outport_wren),
    .d(wr_data),
    .q(outport)
);
assign outport_wren = wren & addr == OUTPORT_ADDR;

// Handle byte-addressing
// always_comb begin
//     case (funct3)
//     WORD: rd_data = q; // Nothing to do here

//     HALF: begin
//         if(byte_num == 2'b00) 
//             rd_data = q & 'hffff;
//         else 
//             rd_data = q & ('hffff << 16) >> 16;
//     end

//     BYTE: begin
//         // TODO make this simpler
//         if(byte_num == 2'b00) 
//             rd_data = q & 'hff;
//         else if(byte_num == 2'b01)
//             rd_data = q & ('hff << 8) >> 8;
//         else if(byte_num == 2'b10)
//             rd_data = q & ('hff << 16) >> 16;
//         else
//             rd_data = q & ('hff << 24) >> 24;
//     end

//     default: rd_data = q; // TODO remove
//     endcase
// end

//     default: rd_data = q; // TODO remove
//     endcase
// end
assign rd_data = q; // TODO replace with byte-addressing

endmodule
