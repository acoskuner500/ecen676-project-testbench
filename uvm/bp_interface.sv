interface bp_interface(input clk);
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter ADDR_WID              = `ADDR_WID             ;
    // parameter PERCEPTRON_HISTORY    = `PERCEPTRON_HISTORY   ;
    // parameter PERCEPTRON_BITS       = `PERCEPTRON_BITS      ;
    // parameter NUM_PERCEPTRONS       = `NUM_PERCEPTRONS      ;

    logic [ADDR_WID - 1:0]    ip;
    logic [ADDR_WID - 1:0]    predicted_target;
    logic           prediction;
    logic           outcome;
    logic           mode;
    // logic           always_taken;
    // logic [$size(int) - 1:0]     branch_type;

endinterface