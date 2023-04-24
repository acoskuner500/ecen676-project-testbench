//Extend bp_driver_c from uvm_driver, and paramterize the class with bp_transaction_c 
class bp_driver_c extends uvm_driver #(bp_transaction_c);
    parameter ADDR_WID = `ADDR_WID;

//Declare the utility macro, driver is a component, so component utility macro
    `uvm_component_utils(bp_driver_c)

//Virtual interface of used to drive and observe bp interface signals
    virtual interface bp_interface vi_bp_if;

//constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//declare tasks & functions
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(bp_transaction_c transaction);
endclass : bp_driver_c

function void bp_driver_c::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Get Virtual Interface in build_phase method of driver, and throw error if virtual interface is not set
    if (!uvm_config_db#(virtual bp_interface)::get(this, "","vif", vi_bp_if))
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task bp_driver_c::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "RUN Phase", UVM_LOW);
    forever begin 
	    // Get new item from the sequencer
        seq_item_port.get_next_item(req);
	    // Drive the item
    	send_to_dut(req);    
	    // Communicate item done to the sequencer
    	seq_item_port.item_done();
     end
endtask: run_phase

task bp_driver_c::send_to_dut(bp_transaction_c transaction);
    `uvm_info(get_type_name(), $sformatf("Input Data to Send:\n%s", transaction.sprint()),UVM_LOW);

    @(posedge vi_bp_if.clk);
    vi_bp_if.ip  <= transaction.ip;

    @(negedge vi_bp_if.clk);
    vi_bp_if.b_taken <= transaction.b_taken;

    @(posedge vi_bp_if.clk);
    vi_bp_if.ip                 <= {ADDR_WID{1'bz}};
    vi_bp_if.b_taken            <= 1'bz;
    
    @(posedge vi_bp_if.clk);
    `uvm_info(get_type_name(), $sformatf("Ended Driving transaction"), UVM_LOW)

endtask : send_to_dut
