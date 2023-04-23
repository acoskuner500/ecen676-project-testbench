// 1 bit shift register with length N
module history_fifo
    // history length
    #(parameter N=64)
    (
        input wire clk,
        input wire s_in,
        output wire [N-1:0] r_out // output of the 64 registers where r_out[0] is the oldest bit
    );

    // s_in -> [N, N-1, ..., 1, 0] -> s_out

    // registers
    reg [N-1:0] r_reg;
    // next value
    wire [N-1:0] r_next;

    initial
        r_reg = 0;

    // update fifo with new value
    always @(negedge clk)
        r_reg <= r_next;


    assign r_next = {s_in, r_reg[N-1:1]}; // shift
    assign r_out = r_reg; // output
 
endmodule