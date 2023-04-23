// 1. select perceptron
// 2. read weight
// 3. compute prediction
// WAIT FOR CLOCK/BRANCH
// 4. update weight
// 5. update history
module predictor (
    b_addr,
    b_taken,
    clk,
    prediction
);
    // Parameters
    parameter address_length = 64;
    parameter num_perceptrons = 64;
    parameter history_length = 64;
    parameter perceptron_width = 8;
    parameter hash_length = 6; // needs to be log2(num_perceptrons) but I don't know how to do that in verilog
    parameter theta = 2 * history_length + 14;

    // Inputs/Outputs
    input [address_length-1:0] b_addr;
    input b_taken;
    input clk;
    output prediction;

    // Basic wires
    wire [address_length-1:0] b_addr;
    wire b_taken;
    wire clk;
    wire prediction;
    integer y;

    integer i;
    integer j;

    // Perceptron select
    wire [hash_length-1:0] p_select;
    // use 8 least significant bits of address to select perceptron
    assign p_select = b_addr[7:0];

    // Perceptron weights
    // 8 bit weights for each perceptron
    // 64 perceptrons
    // 64 weights
    //reg [perceptron_width-1:0] weights [num_perceptrons-1:0][history_length-1:0];
    integer weights [num_perceptrons-1:0][history_length-1:0];

    // History
    wire [history_length-1:0] history;

    // History FIFO
    // 1 bit shift register with length N
    // updates on falling edge of update clock
    reg hist_update;
    history_fifo #(.N(num_perceptrons)) history_fifo_1 (
        .clk(~clk),
        .s_in(b_taken),
        .r_out(history)
    );

    // Initialize weights
    initial begin
        for (i = 0; i < num_perceptrons; i= i+1) begin
            for (j = 0; j < history_length; j= j+1) begin
                weights[i][j] = 0;
            end
        end
    end

    // initialize history
    initial begin
        hist_update = 1;
    end


    // Compute prediction at each positive edge of clock
    assign prediction = y > 0;
    always @(posedge clk) begin
        // compute prediction
        y = 0;
        // for each weight along history length, add to y
        for (i = 0; i < history_length; i= i+1) begin
            // if not taken, weight is inverted before adding
            y = y + (history[i] ? weights[p_select][i] : -weights[p_select][i]);
        end
        // display y
        $display("y: %d", y);
        // display weights
        for (i = 0; i < history_length; i= i+1) begin
            $display("weights[%d][%d]: %d", p_select, i, weights[p_select][i]);
        end
        hist_update = 1;
    end

    // After prediction, update weights
    always @(negedge clk) begin
        // update weights
        if( (b_taken != prediction) || (y>(-1*theta) && y<theta)) begin
            for (i = 0; i < history_length; i= i+1) begin
                // increments the weight when the prediiction agrees with history, and decrements the weight when it disagrees
                weights[p_select][i] = weights[p_select][i] + ((history[i] ? 1 : -1) * (b_taken ? 1 : -1));
            end
        end
        // history is updated on falling edge of clock too
        hist_update = 0;
    end




endmodule