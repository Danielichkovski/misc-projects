//============================================================
// UVM Monitor: Observes DUT inputs and outputs
//============================================================
// This monitor samples the inputs of the DUT (first_num, second_num)
// and the DUT output (result). It publishes a transaction on an
// analysis port for scoreboards or other components to consume.
//============================================================

class my_monitor extends uvm_monitor;
  `uvm_component_utils(my_monitor)

  // Virtual interface to access DUT signals
  virtual dut_if dut_vif;

  // Analysis port to send transactions to scoreboard or subscribers
  uvm_analysis_port #(my_transaction) ap;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // Run phase: continuously sample DUT signals
  task run_phase(uvm_phase phase);
    // Objection raising is not needed for monitors
    // phase.raise_objection(this);

    my_transaction trans; 

    forever begin
      @(posedge dut_vif.clock);
      // Create a new transaction to hold sampled values
      trans = my_transaction::type_id::create("trans");

      // Sample the DUT inputs
      trans.first_num  = dut_vif.first_num;
      trans.second_num = dut_vif.second_num;

      // Wait until the DUT updates the result
      @(dut_vif.result);
      trans.result = dut_vif.result;

      // Publish the transaction via the analysis port
      ap.write(trans);

      `uvm_info("MONITOR", $sformatf(
          "first=%0d, second=%0d, result=%0d",
          trans.first_num, trans.second_num, trans.result
      ), UVM_LOW)
    end
  endtask

endclass
