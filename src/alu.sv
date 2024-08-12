import ALU_FNS::*;

module alu #(
    parameter int WIDTH = 4 
) (
    input alu_fn_t fn,
    input funct7_t funct7, // For Integer Register-Register Operations
    input logic [WIDTH-1:0] a, b, 
    output logic [WIDTH-1:0] out
);
    
always_comb begin
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
endmodule
