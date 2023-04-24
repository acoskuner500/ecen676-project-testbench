class bp_monitor_c extends uvm_monitor;
//component macro
    `uvm_component_utils(bp_monitor_c)
//handle of packet
    bp_mon_packet_c packet;
//Analysis port
    uvm_analysis_port #(bp_mon_packet_c) mon_out;
// Virtual interface used to drive and observe branch predictor interface signals
    virtual interface bp_interface vi_bp_if;

//constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        mon_out = new ("mon_out", this);
    endfunction : new

//UVM build phase ()
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // throw error if virtual interface is not set
        if (!uvm_config_db#(virtual bp_interface)::get(this, "","vif", vi_bp_if))
            `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction: build_phase

//UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "RUN Phase", UVM_LOW)
        forever begin
            @(posedge vi_bp_if.cpu_rd or posedge vi_bp_if.cpu_wr)
            packet = bp_mon_packet_c::type_id::create("packet", this);
            if(vi_bp_if.cpu_rd === 1'b1) begin
                packet.request_type = READ_REQ;
            end
            packet.address = vi_bp_if.addr_bus_cpu_lv1;
            @(posedge vi_bp_if.data_in_bus_cpu_lv1 or posedge vi_bp_if.cpu_wr_done)
            packet.dat = vi_bp_if.data_bus_cpu_lv1;
            @(negedge vi_bp_if.cpu_rd or negedge vi_bp_if.cpu_wr)
            mon_out.write(packet);
        end
    endtask : run_phase

endclass : bp_monitor_c
