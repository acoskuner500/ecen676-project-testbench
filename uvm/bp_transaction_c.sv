class bp_transaction_c extends uvm_sequence_item;

    parameter ADDR_WID = `ADDR_WID;

    bit [ADDR_WID - 1:0]    ip          ;
    bit                     b_taken     ;

    // UVM macros for built-in automation
    `uvm_object_utils_begin(bp_transaction_c)
        `uvm_field_int(ip, UVM_ALL_ON)
        `uvm_field_int(b_taken, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor
    function new (string name = "bp_transaction_c");
        super.new(name);
    endfunction : new

endclass : bp_transaction_c
