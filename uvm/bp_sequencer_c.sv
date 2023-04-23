class bp_sequencer_c extends uvm_sequencer #(bp_transaction_c);
//Component Utility Macto
    `uvm_component_utils(bp_sequencer_c)

//Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : bp_sequencer_c
