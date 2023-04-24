class benchmark_test extends base_test;

    //component macro
    `uvm_component_utils(benchmark_test)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", benchmark_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing benchmark test" , UVM_LOW)
    endtask: run_phase

endclass : benchmark_test

class benchmark_seq extends base_vseq;
    //object macro
    `uvm_object_utils(benchmark_seq)

    bp_transaction_c trans;

    //constructor
    function new (string name="benchmark_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_do(trans);
    endtask

endclass : benchmark_seq
