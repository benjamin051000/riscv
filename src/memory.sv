import LOAD_STORE_FNS::*;

module memory #(
    parameter int WIDTH = 32
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr, flash_addr, 
    input logic wren,  // 0 -> rd, 1 -> wr
    input logic [WIDTH-1:0] wr_data, flash_data,
    input funct3_t funct3, // Determine size (word, halfword, byte)
    output logic [WIDTH-1:0] rd_data,

	// When the memory is in reset (rst = 1), assert flash_en 
	// to write to the memory. 
    input logic flash_en, 

    // Outport
    output logic [WIDTH-1:0] outport
);

// logic [1:0] byte_num; // lowest 2 bits
// logic [WIDTH-1:2] word_addr; // All but lowest 2
logic [WIDTH-1:0] q;
logic [10:0] addr_or_flash_addr;
logic ram_wren;

// Are we flashing the memory during reset?
logic flashing;
assign flashing = rst & flash_en;

// Extract actual address and byte address
// assign {word_addr, byte_num} = addr;

logic [$bits(wr_data)-1:0] ram_wr_data;
assign ram_wr_data = flashing ? flash_data : wr_data;

ram	ram_inst (
	// .address(word_addr[12:2]),
    .address(addr_or_flash_addr), 
	.clock(clk),
	.data(ram_wr_data),
	.wren(ram_wren),
	.q(q)
);

// TODO Implement byte-addressing. It currently doesn't exist.
// TODO ram addr is 12 bits wide... not sure how SV handles this by default
assign addr_or_flash_addr = flashing ? flash_addr[12:2] : addr[12:2];

assign ram_wren = (flashing | wren) & addr != OUTPORT_ADDR;

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
