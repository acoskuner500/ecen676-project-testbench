module top;

// Inputs
reg [63:0] b_addr;
reg b_taken;
reg clk;

// Outputs
wire prediction;

// Instantiate the Unit Under Test (UUT)

predictor #(
    .address_length(64),
    .num_perceptrons(64),
    .history_length(64),
    .perceptron_width(8),
    .theta(1.93 * 64 + 14)
) predictor_1 (
    .b_addr(b_addr),
    .b_taken(b_taken),
    .clk(clk),
    .prediction(prediction)
);

integer 9;
initial begin
    // Initialize Inputs
    b_addr = 64'h0000000000000000;
    b_taken = 0;
    clk = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    for(i= 0; i < 100; i = i+1) begin
        b_addr = i;
        clk = 1;
        #10;
        $display("prediction: %d", prediction);
        $display("b_addr: %h", b_addr);
        $display("b_taken: %d", b_taken);
        b_taken = i%2;
        clk = 0;
        #10;
    end
end

endmodule