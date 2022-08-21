import rv32i_opcodes::*;

module controller #(
    parameter int WIDTH
) (
    input logic clk, rst,
    input rv32i_opcode_t opcode,
    output logic regfile_wren, ir_wren, pc_inc, mem_wren
);

// State machine types
typedef enum logic[2:0] {
    FETCH,
    DECODE,
    R_TYPE, // ALU op instructions (not immediate)
    I_TYPE, // ALU op instructions (immediates)
    UJ_TYPE, // Unconditional jump
    BRANCH_TYPE, // Conditional jump
    MEM_TYPE // Load and store instructions
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
        LOAD|STORE: next_state = MEM_TYPE;
        JAL|JALR: next_state = UJ_TYPE;
        BRANCH: next_state = BRANCH_TYPE;
        default: next_state = R_TYPE; // TODO remove
        endcase
    end

    R_TYPE: begin
        // The datapath handles most of what needs to go down
        // TODO when we start muxing regfile/alu inputs, this
        // block will do more.
        // For now, just enable regfile writeback
        regfile_wren = '1;
        next_state = FETCH;
    end

    I_TYPE: begin
        next_state = FETCH;
    end

    MEM_TYPE: begin
        // TODO this is very wrong lol but fix it later 
        mem_wren = '1;
        next_state = FETCH;
    end

    default: next_state = FETCH;

    endcase
end

endmodule
