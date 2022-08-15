`timescale 1ns/10ps

import ALU_FNS::*;

module test_alu;

localparam NUM_TESTS = 1000;
localparam WIDTH = 32;
localparam longint MAX_INT = 2 ** WIDTH - 1; // For edge cases

alu_fn_t fn;
funct7_t funct7; // For Integer Register-Register Operations
logic [WIDTH-1:0] a, b;
logic [WIDTH-1:0] out, correct;

alu #(.WIDTH(WIDTH)) DUT (.*);


task verify();
    case (fn)
        ADD_SUB: begin
            if (funct7)
                correct = a - b; 
            else
                correct = a + b;  // This appears to be signed
        end 

        AND: correct = a & b;
        OR: correct = a | b;
        XOR: correct = a ^ b;
        SLL: correct = a << b;
        SLT: correct = a != 0;
        SLTU: correct = a != 0;
        SRL_SRA: begin
            if (funct7)
                correct = a >>> b;
            else
                correct = a >> b;
        end 
        // default: correct = '0; 
    endcase

    #10;

    if (out != correct) 
        $display("Error (time %0t): for function %s, out = %h instead of %h.", $realtime, fn.name(), out, correct);
endtask


initial begin
    $timeformat(-9, 0, "ns");

    repeat(NUM_TESTS) begin
        a = $random;
        b = $random;
        funct7 = ADD_SRL;
        std::randomize(fn);

        verify();

    end

    // Test some edge cases
    a = MAX_INT;
    b = 1;
    fn = ADD_SUB;
    funct7 = ADD_SRL;

    verify();

    // Test 2s complement
    a = -5;
    b = 6;
    verify();

    a = 5;
    b = -6;
    verify();

    funct7 = SUB_SRA;
    verify(); // subtract

    a = -5;
    b = 6;
    verify(); // sub


    $display("Done.");
end

endmodule
