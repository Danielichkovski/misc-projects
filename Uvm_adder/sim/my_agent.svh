`timescale 1ns / 1ps
//============================================================
// UVM Agent
// Combines driver, sequencer, and monitor for a single interface.
// Responsible for generating and driving transactions and observing DUT.
//============================================================

class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)

    //============================================================
    // Agent components
    //============================================================
    my_driver                      driver;      // Driver: sends transactions to DUT
    uvm_sequencer #(my_transaction) sequencer;  // Sequencer: generates transaction sequence
    my_monitor                      monitor;    // Monitor: observes DUT signals

 //============================================================
    // Constructor
    //============================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //============================================================
    // Build phase
    //============================================================
    function void build_phase(uvm_phase phase);
        // Create driver, sequencer, and monitor
        driver    = my_driver::type_id::create("driver", this);
        sequencer = uvm_sequencer#(my_transaction)::type_id::create("sequencer", this);
        monitor   = my_monitor::type_id::create("monitor", this);
    endfunction

  //============================================================
    // Connect phase
    //============================================================
    function void connect_phase(uvm_phase phase);
        // Connect driver to sequencer
        driver.seq_item_port.connect(sequencer.seq_item_export);

        // Pass virtual interface to monitor
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", monitor.dut_vif)) begin
            `uvm_error("MY_AGENT", "Failed to get dut_vif for monitor")
        end
    endfunction

  //============================================================
    // Run phase
    //============================================================
    task run_phase(uvm_phase phase);
    // We raise objection to keep the test from completing
        phase.raise_objection(this);
        begin
             my_sequence seq;
             seq = my_sequence::type_id::create("seq");
             seq.start(sequencer);
        end
    // We drop objection to allow the test to complete
         phase.drop_objection(this);
  endtask

endclass
