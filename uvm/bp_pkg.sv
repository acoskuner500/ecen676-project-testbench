//=====================================================================
// Project: 4 core MESI cache design
// File Name: cpu_package_c.sv
// Description: cpu package
// Designers: Venky & Suru
//=====================================================================

package bp_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "bp_transaction_c.sv"
    `include "bp_mon_packet_c.sv"
    `include "bp_monitor_c.sv"
    `include "bp_sequencer_c.sv"
    `include "bp_seqs.sv"
    `include "bp_driver_c.sv"
    `include "bp_agent_c.sv"
endpackage
