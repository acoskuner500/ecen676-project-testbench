`define ADDR_WID              64
`define NUM_PERCEPTRONS       64
`define PERCEPTRON_HISTORY    64
`define PERCEPTRON_BITS       8
`define HASH_LENGTH           $clog2((`NUM_PERCEPTRONS))
`define THETA                 (1.93 * (`PERCEPTRON_HISTORY) + 14)
