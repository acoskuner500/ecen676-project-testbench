class bp_base_seq extends uvm_sequence #(bp_transaction_c);
    `uvm_object_utils(bp_base_seq)
    
    function new (string name = "bp_base_seq");
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

endclass : bp_base_seq

// class simple_seq extends uvm_sequence #(bp_transaction_c);

//     `uvm_object_utils(simple_seq)

//     function new (string name = "simple_seq");
//         super.new(name);
//     endfunction

//     virtual task body();
//         `uvm_info(get_type_name(), "executing 5 bp transaction", UVM_LOW)
//         repeat(5)
//             `uvm_do(req)
//     endtask
// endclass : simple_seq