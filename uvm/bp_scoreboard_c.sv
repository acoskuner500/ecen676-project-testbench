class bp_scoreboard_c extends uvm_scoreboard;

    // Analysis implementation port
    uvm_analysis_imp #(bp_mon_packet_c, bp_scoreboard_c) sb_bp;

   // Declare the analysis ports for the predicted and actual outcomes
   uvm_analysis_port#(bit) predicted_outcome_port;
   uvm_analysis_port#(bit) actual_outcome_port;
   
   // Declare variables to store the predicted and actual outcomes
   bit predicted_outcome;
   bit actual_outcome;

   // Declare the expected outcomes
   bit [1:0] expected_outcomes [$];
   
   // Initialize the expected outcomes array
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      expected_outcomes.push_back(0);
      expected_outcomes.push_back(1);
   endfunction

   // The write_input method is called by the driver to send the predicted outcome
   virtual function void write_input(bit prediction);
      predicted_outcome = prediction;
      predicted_outcome_port.write(predicted_outcome);
   endfunction

   // The write_output method is called by the monitor to send the actual outcome
   virtual function void write_output(bit outcome);
      actual_outcome = outcome;
      actual_outcome_port.write(actual_outcome);
   endfunction

   // The compare_phase method is called by the scoreboard to compare the predicted and actual outcomes
   virtual function void compare_phase(uvm_phase phase);
      bit match = 1;
      if (predicted_outcome != actual_outcome) begin
         match = 0;
      end
      uvm_report_info("SCOREBOARD", $sformatf("Predicted outcome: %0d, Actual outcome: %0d, Match: %0d", predicted_outcome, actual_outcome, match), UVM_LOW);
      expected_outcomes.delete(predicted_outcome);
   endfunction

   // The end_of_simulation method is called at the end of the simulation to report any missing expected outcomes
   virtual function void end_of_simulation_phase(uvm_phase phase);
      if (expected_outcomes.size() > 0) begin
         uvm_report_warning("SCOREBOARD", $sformatf("%0d missing expected outcomes", expected_outcomes.size()), UVM_LOW);
         foreach (expected_outcome[i]) begin
            uvm_report_warning("SCOREBOARD", $sformatf("Missing expected outcome: %0d", expected_outcome[i]), UVM_LOW);
         end
      end
   endfunction

endclass : bp_scoreboard
