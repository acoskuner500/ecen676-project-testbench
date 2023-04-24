typedef enum bit {UPDATE=0, PREDICT=1} function_t;

class bp_transaction_c extends uvm_sequence_item;

    parameter ADDR_WID_LV1      = `ADDR_WID_LV1;

    bit [ADDR_WID - 1:0]    ip;
    bit [ADDR_WID - 1:0]    predicted_target;
    bit         prediction;
    bit         outcome;
    function_t  mode;

    // UVM macros for built-in automation
    `uvm_object_utils_begin(bp_transaction_c)
        `uvm_field_int(ip, UVM_ALL_ON)
        `uvm_field_int(predicted_target, UVM_ALL_ON)
        `uvm_field_int(prediction, UVM_ALL_ON)
        `uvm_field_int(outcome, UVM_ALL_ON)
        `uvm_field_enum(function_t, mode, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor
    function new (string name = "bp_transaction_c");
        super.new(name);
    endfunction : new

// //Constraint 4: soft constraint for wait cycles within 0 and 20
//     constraint ct_wait_time{
//         soft wait_cycles >= 0;
//         soft wait_cycles <= 20;
//     }

endclass : bp_transaction_c

