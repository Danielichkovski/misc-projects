`timescale 1ns / 1ps

module tb_top_axi_lite;

    // Testbench signals
    logic clk;
    logic rstn;
    logic start;
    logic mode;           // 1 = write, 0 = read
    logic [31:0] addr;
    logic [31:0] wdata_in;
    logic [31:0] rdata_out;
    logic done;
    integer i;

    // DUT instantiation
    top_axi_lite dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .mode(mode),
        .addr(addr),
        .wdata_in(wdata_in),
        .rdata_out(rdata_out),
        .done(done)
    );

    // Clock generation: 10ns period = 100MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        rstn     = 0;
        start    = 0;
        mode     = 0;
        addr     = 0;
        wdata_in = 0;

        // Apply reset
        #20;
        rstn = 1;
        #20;

        //-----------------------------------------------------
        // 1) WRITE transaction
        //-----------------------------------------------------
        addr     = 32'h00000014;      
        wdata_in = 32'hDDDDDDDD;      // data to write
        mode     = 1;                 // write mode
        start    = 1;
        #10 start = 0;

        wait(done);
        $display("WRITE complete: addr=0x%0h data=0x%0h", addr, wdata_in);
        #20;

        //-----------------------------------------------------
        // 2) READ transaction
        //-----------------------------------------------------
        mode     = 0;                 // read mode
        start    = 1;
        #10 start = 0;

        wait(done);
        $display("READ complete: addr=0x%0h data=0x%0h", addr, rdata_out);

        //-----------------------------------------------------
        // 3) Check result
        //-----------------------------------------------------
        if (rdata_out == wdata_in)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        //-----------------------------------------------------
        // End simulation
        //-----------------------------------------------------
        #50;
        $display("----- MEMORY DUMP -----");
             for (i = 0; i < 16; i++) begin
                $display("mem[%0d] = %08h", i, dut.slave_inst.mem[i]);
             end
        $stop;
    end

endmodule
