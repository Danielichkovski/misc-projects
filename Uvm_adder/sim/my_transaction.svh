`timescale 1ns / 1ps
//============================================================
// Transaction Item: my_transaction
// Represents a single operation with inputs and expected result.
// Used by sequencer and driver in the UVM testbench.
//============================================================

class my_transaction extends uvm_sequence_item;

    `uvm_object_utils(my_transaction)

    //============================================================
    // Transaction fields
    //============================================================
    rand int first_num;   // First operand
    rand int second_num;  // Second operand
    rand int result;      // Result (optional for checking)

    //============================================================
    // Constraints for randomization
    //============================================================
    constraint c_first_num { first_num  >= 0; first_num  < 255; }
    constraint c_second_num { second_num >= 0; second_num < 255; }

    //============================================================
    // Constructor
    //============================================================
    function new(string name = "");
        super.new(name);
    endfunction

endclass : my_transaction
