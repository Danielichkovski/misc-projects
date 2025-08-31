`timescale 1ns / 1ps
//============================================================
// Test: my_test
// Top-level UVM test class. Creates the environment (my_env)
// Produces UVM_INFO messages "start test"
//============================================================

class my_test extends uvm_test;

    `uvm_component_utils(my_test)

    //============================================================
    // Environment handle
    //============================================================
    my_env env;

    //============================================================
    // Constructor
    //============================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //============================================================
    // Build phase
    // Instantiate the environment
    //============================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction

    //============================================================
    // Run phase
    // Simple test flow: print "Hello World!"
    //============================================================
    task run_phase(uvm_phase phase);
        // Prevent test from ending prematurely
        phase.raise_objection(this);

        #10;
        `uvm_warning("MY_TEST", "Start test!")

        // Allow test to end
        phase.drop_objection(this);
    endtask : run_phase

endclass : my_test
