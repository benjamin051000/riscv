
module controller #(
    parameter int WIDTH
) (
    input logic clk, rst
);

typedef enum logic[2:0] {
    FETCH,
    DECODE,
    R_TYPE
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= FETCH;
    end
    else begin
        state <= next_state;
    end
end


always_comb begin
    case(state)
    FETCH: begin
        next_state = DECODE;
    end
    
    DECODE: begin
        next_state = R_TYPE; // TODO actually check
    end

    R_TYPE: begin
        next_state = FETCH;
    end
    endcase
end

endmodule
