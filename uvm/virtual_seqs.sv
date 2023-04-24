class base_vseq extends uvm_sequence;

    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(virtual_sequencer_c)


    function new (string name = "base_vseq");
        super.new(name);
    endfunction

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : base_vseq
