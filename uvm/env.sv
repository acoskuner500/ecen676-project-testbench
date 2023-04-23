//include the monitor
`include "bp_monitor_c.sv"
//include the virtual sequencer
`include "virtual_sequencer_c.sv"
//include the virtual sequences
`include "virtual_seqs.sv"
//include the scoreboard
`include "bp_scoreboard_c.sv"

class env extends uvm_env;

//component macro
    `uvm_component_utils(env)

//Declare handles of components within the tb, that we have created till now
    bp_agent_c          bp_agent;
    virtual_sequencer_c vsequencer;
    bp_monitor_c        bp_monitor;
    bp_scoreboard_c     bp_sb;

//Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//UVM build phase method
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bp_agent = bp_agent_c::type_id::create("bp_agent", this);
        vsequencer = virtual_sequencer_c::type_id::create("vsequencer", this);
        bp_monitor = bp_monitor_c::type_id::create("bp_monitor", this);
        bp_sb = bp_scoreboard_c::type_id::create("bp_sb", this);
    endfunction : build_phase

//UVM connect phase method
    function void connect_phase(uvm_phase phase);
        vsequencer.bp_seqr = bp_agent.sequencer;
        bp_agent.monitor.mon_out.connect(sb.sb_bp);
    endfunction : connect_phase

endclass: env
