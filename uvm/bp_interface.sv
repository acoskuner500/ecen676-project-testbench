interface bp_interface(input clk);
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter ADDR_WID              = `ADDR_WID             ;

    logic [ADDR_WID - 1:0]  ip;         // branch address
    logic                   b_taken;    // input for update
    logic                   prediction; // output of predictor

endinterface
