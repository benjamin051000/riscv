import ALU_FNS::*;

module alu #(
    parameter int WIDTH = 32
) (
    input alu_fn_t fn,
    input funct7_t funct7, // For Integer Register-Register Operations
    input logic [WIDTH-1:0] a, b, 
    output logic [WIDTH-1:0] out,
	output logic take_branch
);
    
always_comb begin: alu_outputs
    unique case (fn)

    ADD_SUB: begin
        if (funct7 == SUB_SRA) // == 0100000b
            out = a - b;
        else
            out = a + b;
    end

    AND: out = a & b;

    OR: out = a | b;

    XOR: out = a ^ b;

    SLL: out = a << b;

    SRL_SRA: begin
        if (funct7 == SUB_SRA)
            out = a >>> b;
        else
            out = a >> b;
    end 

    SLT: out = WIDTH'(a < b); 

    SLTU: out = WIDTH'(a < b); // TODO needs to be unsigned

    // default: out = '0;


    endcase
end

always_comb begin: branch_outputs
	// NOTE: This must be explicitly automatic...
	automatic alu_branches_funct3_t b_fn = alu_branches_funct3_t'(fn);

	// TODO can this just use "out"?
	take_branch = 0;

	unique case (b_fn) 
	BEQ: take_branch = a == b; // NOTE: == instead of === since === is for 4-state equality, which I presume isn't synthesizable.
	BNE: take_branch = a != b;
	BLT: take_branch = a < b;
	BGE: take_branch = a >= b;
	BLTU: take_branch = unsigned'(a) < unsigned'(b); // TODO verify this is correct
	BGEU: take_branch = unsigned'(a) >= unsigned'(b);
	endcase
end

endmodule
