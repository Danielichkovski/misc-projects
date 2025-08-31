`timescale 1ns / 1ps
//============================================================
// Driver: my_driver
// Drives transactions (my_transaction) onto the DUT interface
//============================================================

class my_driver extends uvm_driver #(my_transaction);

    `uvm_component_utils(my_driver)

    //============================================================
    // Virtual Interface
    //============================================================
    virtual dut_if dut_vif;

    //============================================================
    // Constructor
    //============================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //============================================================
    // Build Phase
    // Get interface from config DB
    //============================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("NO_VIF", "Failed to get dut_vif from config DB")
        end
    endfunction 

    //============================================================
    // Run Phase
    // Apply reset, then drive transactions from sequence
    //============================================================
    task run_phase(uvm_phase phase);
        // Apply reset
        dut_vif.reset = 1;
        @(posedge dut_vif.clock);
        #1;
        dut_vif.reset = 0;

        // Drive transactions forever
        forever begin
            seq_item_port.get_next_item(req);

            // Drive DUT pins with transaction fields
            dut_vif.first_num  = req.first_num;
            dut_vif.second_num = req.second_num;
            dut_vif.result     = req.result;

            @(posedge dut_vif.clock);

            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : my_driver
