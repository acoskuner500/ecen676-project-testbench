module top;

    // import the UVM library
    import uvm_pkg::*;
    // include the UVM macros
    `include "uvm_macros.svh"

    // import the CPU package
    import bp_pkg::*;

    //include the environment
    `include "env.sv"

    // include the test library
    `include "test_lib.svh"

    parameter ADDR_WID           = `ADDR_WID       ;

    reg                     clk;

    // Instantiate the interfaces
    bp_interface    inst_bp_if(clk);

    // TODO: Needs some kind of stimulus to b_addr and b_taken
    // wire [ADDR_WID-1:0] b_addr;
    // wire                b_taken;
    // assign b_addr = ???
    // assign b_taken = ???

    // Instantiate DUT
    bp_top inst_bp_top (
                        .clk(clk),
                        .b_addr(inst_bp_if.b_addr),
                        .b_taken(inst_bp_if.b_taken),
                        .prediction(inst_bp_if.prediction)
                       );

//System clock generation
    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

//TB inital setup
    initial begin
        `uvm_info("TOP","Starting UVM test", UVM_LOW)
//Set Virtual Interface,
        uvm_config_db#(virtual interface bp_interface)::set(null,"*.tb.*.*","vif",inst_bp_if);
        run_test();
        `uvm_info("TOP", "DONE", UVM_LOW)
    end

endmodule
