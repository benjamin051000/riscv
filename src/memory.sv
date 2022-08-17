import LOAD_STORE_FNS::*;

module memory #(
    parameter int WIDTH
) (
    input logic clk, rst,
    input logic [WIDTH-1:0] addr, // TODO replace if not useful
    input logic wren,  // 0 -> rd, 1 -> wr
    input logic [WIDTH-1:0] wr_data,
    input funct3_t funct3, // Determine size (word, halfword, byte)
    output logic [WIDTH-1:0] rd_data,

    // Flash the memory
    input logic flash_en,
    input logic [10:0] flash_addr,
    input logic [WIDTH-1:0] flash_data,

    // Outport
    output logic [WIDTH-1:0] outport
);

// logic [1:0] byte_num; // lowest 2 bits
// logic [WIDTH-1:2] word_addr; // All but lowest 2
logic [WIDTH-1:0] q;

logic [10:0] ram_addr;
logic [WIDTH-1:0] ram_wr_data;
logic ram_wren;

// Extract actual address and byte address
// assign {word_addr, byte_num} = addr;

// TODO Handle byte addressing
// TODO ram addr is 12 bits wide... not sure how SV handles this by default
ram	ram_inst (
	// .address(word_addr[12:2]),
    .address(ram_addr),
	.clock(clk),
	.data(ram_wr_data),
	.wren(ram_wren),
	.q(q)
);

assign ram_addr = flash_en ? flash_addr : addr[12:2];
assign ram_wr_data = flash_en ? flash_data : wr_data;
assign ram_wren = flash_en | wren;

logic outport_en;
register  #(.WIDTH(WIDTH)) _outport (
    .clk(clk),
    .rst(rst),
    .en(outport_en),
    .d(q),
    .q(outport)
);
assign outport_en = wren && addr == 16'hFFFC;

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
