class bp_scoreboard_c extends uvm_scoreboard;
    parameter ADDR_WID = `ADDR_WID;

    // Analysis implementation port
    uvm_analysis_imp #(bp_mon_packet_c, bp_scoreboard_c) sb_bp;

    //component macro
    `uvm_component_utils(bp_scoreboard_c)
 
    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        sb_bp = new("sb_bp", this);
    endfunction : new

    function void write(bp_mon_packet_c packet);
        // generate expected, check data, check system packet, update cache
        `uvm_info(get_type_name(), $sformatf("Received packet\n%s", packet.sprint()), UVM_LOW);
        if (packet.b_taken !== packet.prediction)
            `uvm_info(get_type_name(), $sformatf("Mispredicted branch instruction %0h. Predicted: %0b, Actual: %0b", packet.ip, packet.prediction, packet.b_taken), UVM_LOW);
        else
            `uvm_info(get_type_name(), $sformatf("Correctly predicted branch instruction %0h. Predicted: %0b, Actual: %0b", packet.ip, packet.prediction, packet.b_taken), UVM_LOW);
    endfunction : write

endclass : bp_scoreboard
