//include directories
    -incdir ../design
    -incdir ../gold
    -incdir ../uvm
    -incdir ../test

//compile design files
    ../design/def.sv
    ../design/history_fifo.sv
    ../design/predictor.sv
    ../design/bp_top.sv

//compile golden ___ files
    // ../gold/

//compile testbench files
    ../uvm/bp_interface.sv
    ../uvm/bp_pkg.sv
    ../uvm/top.sv
