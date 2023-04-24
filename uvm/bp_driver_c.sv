`define TIME_OUT_VAL 110

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
    extern protected task get_and_drive();
    extern task send_to_dut(bp_transaction_c transaction);
    // extern protected task drv_rd_trans(bit [ADDR_WID-1:0] addr, bit [DATA_WID-1:0] exp_data);
    // extern protected task drv_wr_trans(bit [ADDR_WID-1:0] addr, bit [DATA_WID-1:0] wrt_data);
endclass : bp_driver_c

//Defining functions & tasks outside the class

//Define build_phase()
function void bp_driver_c::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Get Virtual Interface in build_phase method of driver, and throw error if virtual interface is not set
    if (!uvm_config_db#(virtual bp_interface)::get(this, "","vif", vi_bp_if))
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

//Define run_phase()
task bp_driver_c::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "RUN Phase", UVM_LOW);
    get_and_drive();
endtask: run_phase

//Define get_and_drive():gets packets from the sequencer and passes them to the driver.
task bp_driver_c::get_and_drive();
    //In forever begin
    forever begin 
	    // Get new item from the sequencer
        seq_item_port.get_next_item(req);
	    // Drive the item
    	send_to_dut(req);    
	    // Communicate item done to the sequencer
    	seq_item_port.item_done();
     end
endtask: get_and_drive

task bp_driver_c::send_to_dut(bp_transaction_c transaction);
    `uvm_info(get_type_name(), $sformatf("Input Data to Send:\n%s", transaction.sprint()),UVM_LOW);

    // wait time before start of the transaction
    repeat(transaction.wait_cycles) @(posedge vi_bp_if.clk);

    vi_bp_if.ip                 <= {ADDR_WID{1'bz}};
    vi_bp_if.predicted_target   <= {ADDR_WID{1'bz}};
    vi_bp_if.prediction         <= 1'b0;
    vi_bp_if.outcome            <= 1'b0;
    vi_bp_if.always_taken       <= 1'b0;
    vi_bp_if.update       <= 1'b0;
    // vi_bp_if.branch_type        <= {$size(int){1'bz}};

//Define send_to_dut(): Based on request type, call drv_rd_trans or drv_wr_trans
    if(transaction.request_type == READ_REQ) 
	drv_rd_trans(transaction.address, transaction.data);
    else if(transaction.request_type == WRITE_REQ)
	drv_wr_trans(transaction.address, transaction.data);
    else
	 `uvm_error(get_type_name(),$sformatf("Invalid request type"))
    `uvm_info(get_type_name(), $sformatf("Ended Driving transaction"), UVM_LOW)

endtask : send_to_dut

//Define task to drive a read transaction to the DUT
task bp_driver_c::drv_rd_trans(bit [ADDR_WID-1:0] addr, bit [DATA_WID-1:0] exp_data);

    @(posedge vi_bp_if.clk);
//Drive address and bp_rd
    vi_bp_if.bp_rd            <= 1'b1;
    vi_bp_if.addr_bus_bp  <= addr;

//start timer and wait for data_in_bus_bp till TIME_OUT_VAL is hit
    fork: timer_and_wait
        @(posedge vi_bp_if.data_in_bus_bp);
        begin: time_out_check
            repeat(`TIME_OUT_VAL) @(posedge vi_bp_if.clk);
        end
    join_any: timer_and_wait


// Release the address bus and bp_rd,(Other internal signals) 
    @(posedge vi_bp_if.clk);

    vi_bp_if.bp_rd            <= 1'b0;
    vi_bp_if.addr_bus_bp  <= {ADDR_WID{1'bz}};
    disable fork;

//wait till data_in_bus_bp goes low to indicate end of transaction
//or for another clock if the transaction timed out
    @(negedge vi_bp_if.data_in_bus_bp or posedge vi_bp_if.clk);
    @(posedge vi_bp_if.clk);

endtask: drv_rd_trans

//Define task to drive a write transaction to the DUT
task bp_driver_c::drv_wr_trans(bit [ADDR_WID-1:0] addr, bit [DATA_WID-1:0] wrt_data);
    @(posedge vi_bp_if.clk);
    // Drive address, data and bp_wr
    vi_bp_if.bp_wr                <= 1'b1;
    vi_bp_if.addr_bus_bp      <= addr;
    vi_bp_if.data_bus_bp_reg   <= wrt_data;

    // start timer and wait for bp_wr_done
    fork: timer_and_wait
        begin
            @(posedge vi_bp_if.bp_wr_done);
        end
        begin: time_out_check
            repeat(`TIME_OUT_VAL) @(posedge vi_bp_if.clk);
        end
    join_any: timer_and_wait

    // Release the address, data and bp_wr. Other internal signals
    @(posedge vi_bp_if.clk);
    vi_bp_if.bp_wr                <= 1'b0;
    vi_bp_if.addr_bus_bp      <= {ADDR_WID{1'b0}};
    vi_bp_if.data_bus_bp_reg   <= {DATA_WID{1'b0}};
    disable fork;

    // wait till bp_wr_done goes low to indicate end of transaction
    // or for another clock if the transaction timed out
    @(negedge vi_bp_if.bp_wr_done or posedge vi_bp_if.clk);
    @(posedge vi_bp_if.clk);
endtask: drv_wr_trans
