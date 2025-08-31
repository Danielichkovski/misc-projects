`timescale 1ns / 1ps
//============================================================
// Scoreboard: my_scoreboard
// Compares DUT output with expected result
//============================================================

class my_scoreboard extends uvm_component;

    `uvm_component_utils(my_scoreboard)

    //============================================================
    // Analysis Export (connects to monitor)
    //============================================================
    uvm_analysis_imp #(my_transaction, my_scoreboard) analysis_export;

    //============================================================
    // Constructor
    //============================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    //============================================================
    // Write Method (called by analysis export when monitor sends transactions)
    //============================================================
    function void write(my_transaction t);
        int expected;

        // Compute expected result 
        expected = t.first_num + t.second_num;

        if (t.result !== expected) begin
            `uvm_error("SCOREBOARD",
                $sformatf("Mismatch! first=%0d, second=%0d, result=%0d (expected=%0d)",
                          t.first_num, t.second_num, t.result, expected))
        end
        else begin
            `uvm_info("SCOREBOARD",
                $sformatf("Correct! first=%0d, second=%0d, result=%0d",
                          t.first_num, t.second_num, t.result),
                UVM_LOW)
        end
    endfunction : write

endclass : my_scoreboard
