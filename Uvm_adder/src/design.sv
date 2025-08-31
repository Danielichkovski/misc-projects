`timescale 1ns / 1ps
//============================================================
// Simple Adder DUT
// Adds two 8-bit inputs and produces a 9-bit result.
// Interfaces with UVM testbench via `dut_if`.
//
// Inputs (via dut_if):
//    clock      : Clock signal
//    reset      : Active-high synchronous reset
//    first_num  : First 8-bit operand
//    second_num : Second 8-bit operand
//
// Output (via dut_if):
//    result     : 9-bit sum of first_num and second_num
//
// Notes:
//    - Produces UVM_INFO messages on reset and on every addition.
//============================================================

interface dut_if;
    logic       clock;
    logic       reset;
    logic [7:0] first_num;
    logic [7:0] second_num;
    logic [8:0] result;
endinterface

`include "uvm_macros.svh"

module dut (
    dut_if dif
);
    import uvm_pkg::*;

    //============================================================
    // Main sequential logic
    //============================================================
    always @(posedge dif.clock) begin
        if (dif.reset) begin
            // Synchronous reset
            dif.result <= 9'b0;
            `uvm_info("DUT", $sformatf(
                        "RESET asserted, result=%0d",
                        dif.result),
                        UVM_MEDIUM)
        end else begin
            // Perform addition
            dif.result <= dif.first_num + dif.second_num;
            `uvm_info("DUT", $sformatf(
                        "first=%0d, second=%0d, result=%0d",
                        dif.first_num,
                        dif.second_num,
                        dif.result),
                        UVM_MEDIUM)
        end
    end

endmodule
