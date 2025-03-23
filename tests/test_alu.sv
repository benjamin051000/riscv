`timescale 1ns/10ps

import ALU_FNS::*;

module test_alu;

localparam int NUM_TESTS = 100000;
localparam int WIDTH = 32;
localparam logic [WIDTH-1:0] MAX_INT = 2 ** WIDTH - 1; // For edge cases

alu_fn_t fn;
funct7_t funct7; // For Integer Register-Register Operations
logic [WIDTH-1:0] a, b;
logic [WIDTH-1:0] out, correct;
logic take_branch;

alu #(.WIDTH(WIDTH)) DUT (.*);

// TODO Use a function to model this 
int attempts = 0;
int incorrect = 0;

task automatic verify;
    unique case (fn)
        ADD_SUB: begin
            if (funct7 == SUB_SRA)
                correct = a - b; 
            else
                correct = a + b + 1;  // This appears to be signed
        end 

        AND: correct = a & b;
        OR: correct = a | b;
        XOR: correct = a ^ b;
        SLL: correct = a << b;
        SLT: correct = WIDTH'(a < b);
        SLTU: correct = WIDTH'(a < b);
        SRL_SRA: begin
            if (funct7 == SUB_SRA) 
                correct = a >>> b;
            else
                correct = a >> b;
        end 
        // default: correct = '0; 
    endcase

    #10;

	if (out != correct) begin
        $display("Error (time %0t): for function %s, out = %h instead of %h.", $realtime, fn.name(), out, correct);
		incorrect++;
	end
	attempts++;

endtask

// NOTE: Unfortunately, Questa starter edition and Verilator don't allow covergroups.
// covergroup cg;
// 	cp_a: coverpoint a;
// 	cp_b: coverpoint b;
// 	input_cross: cross cp_a, cp_b;
// endgroup

initial begin
	// cg cg_inst = new();
    // $timeformat(-9, 0, "ns");

    // Test both states of funct7.
    // This is a workaround since
    // ModelSim doesn't have std::randomize()
	fn = ADD_SUB;
    funct7 = ADD_SRL;
    repeat(NUM_TESTS / 2) begin
        a = $random;
        b = $random;
        verify();
    end

    funct7 = SUB_SRA; 
    repeat(NUM_TESTS / 2) begin
        a = $random;
        b = $random;
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


    $display("Done. Total correct: %d/%d", attempts - incorrect, attempts);
	// $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
end

initial begin
  if ($test$plusargs("trace") != 0) begin
	 $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
	 $dumpfile("logs/vlt_dump.vcd");
	 $dumpvars();
  end
end

endmodule
