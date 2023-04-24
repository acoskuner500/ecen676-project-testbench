parameter ADDR_WID              64
parameter NUM_PERCEPTRONS       64
parameter PERCEPTRON_HISTORY    64
parameter PERCEPTRON_BITS       8
parameter HASH_LENGTH           $clog2((`NUM_PERCEPTRONS))
parameter THETA                 (1.93 * (`PERCEPTRON_HISTORY) + 14)
