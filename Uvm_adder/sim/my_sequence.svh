`timescale 1ns / 1ps
//============================================================
// Sequence: my_sequence
// Generates a series of my_transaction items to drive the DUT.
// Each item is randomized according to constraints in my_transaction.
//============================================================

class my_sequence extends uvm_sequence#(my_transaction);

    `uvm_object_utils(my_sequence)

    //============================================================
    // Constructor
    //============================================================
    function new(string name = "");
        super.new(name);
    endfunction

    //============================================================
    // Body task
    // Generates multiple transactions and sends them to the sequencer.
    //============================================================
    task body;
        my_transaction req;
        repeat (8) begin
            // Create a new transaction
            req = my_transaction::type_id::create("req");
            // Randomize transaction fields
            if (!req.randomize()) begin
                `uvm_error("MY_SEQUENCE", "Randomization of transaction failed.");
            end
            // Start and finish item to send it to the driver
            start_item(req);
            finish_item(req);
        end
    endtask : body

endclass : my_sequence
