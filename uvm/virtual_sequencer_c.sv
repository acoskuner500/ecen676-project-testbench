class virtual_sequencer_c extends uvm_sequencer;
    //component macro
    `uvm_component_utils(virtual_sequencer_c)

    bp_sequencer_c bp_seqr;

    //constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : virtual_sequencer_c
