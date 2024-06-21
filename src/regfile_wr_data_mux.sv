import rv32i_opcodes::*;

module regfile_wr_data_mux #(
	parameter int WIDTH
) (
	input logic [WIDTH-1:0] alu_out, mem_rd_data, pc_d, 
	input regfile_load_t regfile_load_from_alu_mem_pcp4, // TODO is clog2 correct here?
	output logic [WIDTH-1:0] regfile_wr_data
);

always_comb begin 
	unique case (regfile_load_from_alu_mem_pcp4)
	FROM_ALU: begin
		regfile_wr_data = alu_out;
	end
	FROM_MEM: begin
		regfile_wr_data = mem_rd_data;
	end
	FROM_PC_PLUS_4: begin
		regfile_wr_data = pc_d;
	end
	endcase
end

endmodule
