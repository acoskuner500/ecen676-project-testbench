// 1 bit shift register with length N
module history_fifo
    // history length
    #(parameter N=`NUM_PERCEPTRONS)
    (
        input wire clk,
        input wire s_in,
        output wire [N-1:0] r_out // output of the 64 registers where r_out[0] is the oldest bit
    );

    // s_in -> [N, N-1, ..., 1, 0] -> s_out

    // registers
    reg [N-1:0] r_reg;

    initial
        r_reg = 0;

    // update fifo with new value
    always @(posedge clk)
        r_reg <= {r_reg[N-2:0], s_in};

    assign r_out = r_reg; // output
 
endmodule
