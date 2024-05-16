import rv32i_opcodes::*;

module controller #(
    parameter int WIDTH
) (
    input logic clk, rst,
    input rv32i_opcode_t opcode,

    // Register enables
    output logic regfile_wren, ir_wren, pc_inc, mem_wren,

    // Mux selectors
    output logic regfile_load_from_mem, ram_raddr_31_20 //alu_b_31_20
);

// State machine types
typedef enum logic[3:0] {
    FETCH,
    DECODE,
    R_TYPE, // ALU op instructions (not immediate)
    I_TYPE, // ALU op instructions (immediates)
    UJ_TYPE, // Unconditional jump
    BRANCH_TYPE, // Conditional jump

    MEM_TYPE, // Load and store instructions
    MEM_TYPE_2,

    ILLEGAL_INST
} state_t;

state_t state, next_state;


/*
    Sequential process for state register
*/
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= FETCH;
    end
    else begin
        state <= next_state;
    end
end


/*
    Combinational process to determine next_state 
    and get state machine outputs
*/
always_comb begin
    regfile_wren = '0;
    ir_wren = '0;
    pc_inc = '0;
    mem_wren = '0;

    // Mux selectors
    ram_raddr_31_20 = '0;
	// In R_TYPE and I_TYPE instructions, this should be 0.
	// In LOAD, STORE, and perhaps BRANCH_TYPE (TODO) this should be 1.
    regfile_load_from_mem = '0;
    /* alu_b_31_20 = '0; */

    case(state)
    FETCH: begin
        // Get the next instruction from memory.
        // Tell IR to save the output of mem.
        ir_wren = '1;
        // Also, tell PC to incrememnt (to next instruction)
        pc_inc = '1;

        next_state = DECODE;
    end
    
    DECODE: begin
        case(opcode)
            OP: next_state = R_TYPE;

            OP_IMM: next_state = I_TYPE;

            LOAD, STORE: next_state = MEM_TYPE;

            JAL, JALR: next_state = UJ_TYPE;

            BRANCH: next_state = BRANCH_TYPE;

            default: next_state = ILLEGAL_INST; // TODO remove
        endcase
    end

    R_TYPE | I_TYPE: begin
        // The datapath handles most of what needs to go down
        // TODO when we start muxing regfile/alu inputs, this
        // block will do more.
        // For now, just enable regfile writeback
        regfile_wren = '1;
        next_state = FETCH;
    end

    MEM_TYPE: begin
        // Start by calculating the offset.
        // TODO for now, skip calculation. For testing purposes, always set rs
        // to x0. This way we can just use the offset as an absolute address.

        if (opcode == LOAD) begin
            ram_raddr_31_20 = '1;
            // alu_b_31_20 = '1;

            // regfile_wren = '1;
            regfile_load_from_mem = '1;
        end 
        else if (opcode == STORE) begin
            mem_wren = '1;
        end
        next_state = MEM_TYPE_2;
    end

    MEM_TYPE_2: begin
        // Now the data should be ready on the ram bus.
        // Store in a reg.
        if (opcode == LOAD) begin
            regfile_load_from_mem = '1; 
            regfile_wren = '1;
        end 
        else if (opcode == STORE) begin

        end

        next_state = FETCH;
    end

    ILLEGAL_INST: next_state = ILLEGAL_INST;

    default: next_state = FETCH;

    endcase
end

endmodule
