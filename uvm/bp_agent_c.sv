// Extend bp_agent_c class from uvm_agent
class bp_agent_c extends uvm_agent;

// Declare a protected field is_active of type uvm_active_passive_enum
// this field determines whether an agent is active or passive
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;

// Declare handles for monitor, driver and sequencer
    bp_driver_c driver;
    bp_sequencer_c sequencer;
    bp_monitor_c monitor;

// Declare component utility macro for bp_agent_c and set flag as UVM_ALL_ON for the field is_active which is of type uvm_active_passive_enum
    `uvm_component_utils_begin(bp_agent_c)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

// Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

// Define build_phase()
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
// Create a Monitor
	monitor = bp_monitor_c::type_id::create("monitor", this);
	if(is_active == UVM_ACTIVE) begin
            sequencer = bp_sequencer_c::type_id::create("sequencer", this);
            driver = bp_driver_c::type_id::create("driver", this);
        end
    endfunction : build_phase

// Define connect_phase()
    function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

endclass: bp_agent_c
