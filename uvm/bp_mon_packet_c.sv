class bp_mon_packet_c extends uvm_sequence_item;

    parameter ADDR_WID              = `ADDR_WID             ;
    parameter PERCEPTRON_HISTORY    = `PERCEPTRON_HISTORY   ;
    parameter PERCEPTRON_BITS       = `PERCEPTRON_BITS      ;
    parameter NUM_PERCEPTRONS       = `NUM_PERCEPTRONS      ;

    logic [ADDR_WID - 1:0]  ip;
    logic                   b_taken;
    logic                   prediction;

// UVM macros for built-in automation    
    `uvm_object_utils_begin(bp_mon_packet_c)
        `uvm_field_int(ip, UVM_ALL_ON)
        `uvm_field_int(b_taken, UVM_ALL_ON)
        `uvm_field_int(prediction, UVM_ALL_ON)
    `uvm_object_utils_end

// Constructor
    function new (string name = "bp_mon_packet_c");
        super.new(name);
        this.ip         = {ADDR_WID{1'bz}}  ;
        this.b_taken    = 1'b0              ;
        this.prediction = 1'b0              ;
    endfunction : new
endclass : bp_mon_packet_c
