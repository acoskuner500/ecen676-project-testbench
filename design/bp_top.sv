module bp_top # (
                parameter ADDR_WID           = `ADDR_WID          ,
                parameter NUM_PERCEPTRONS    = `NUM_PERCEPTRONS   ,
                parameter PERCEPTRON_HISTORY = `PERCEPTRON_HISTORY,
                parameter PERCEPTRON_BITS    = `PERCEPTRON_BITS   ,
                parameter HASH_LENGTH        = `HASH_LENGTH       ,
                parameter THETA              = `THETA             ,
                )(
                    input                   clk     ,
                    input [ADDR_WID - 1:0]  b_addr  ,
                    input                   b_taken ,
                    output                  prediction
                );
    
    predictor #(
        .address_length(    ADDR_WID           ),
        .num_perceptrons(   NUM_PERCEPTRONS    ),
        .history_length(    PERCEPTRON_HISTORY ),
        .perceptron_width(  PERCEPTRON_BITS    ),
        .hash_length(       HASH_LENGTH        ),
        .theta(             THETA              )
    ) inst_predictor (
        .b_addr(b_addr),
        .b_taken(b_taken),
        .clk(clk),
        .prediction(prediction)
    );

endmodule
