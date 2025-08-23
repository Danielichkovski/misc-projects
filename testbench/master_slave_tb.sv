`timescale 1ns / 1ps

module tb_axi_lite;
  // Clock and reset
  logic clk = 0;
  logic rstn;

  // Master control
  logic start;
  logic mode;              // 0 = read, 1 = write
  logic [31:0] addr;
  logic [31:0] wdata_in;
  logic [31:0] rdata_outM;
  logic done;
  integer i;
  integer cycle_count = 0;

  // AXI signals between master and slave
  logic awvalidM, wvalidM, breadyM, arvalidM, rreadyM;
  logic awreadyS, wreadyS, bvalidS, arreadyS, rvalidS;
  logic [31:0] awaddrM, wdataM, araddrM, rdataS;

  // Clock generation: 100 MHz
  always #5 clk = ~clk;

  // Cycle counter
  always @(posedge clk) begin
    if (!rstn)
      cycle_count <= 0;
    else
      cycle_count <= cycle_count + 1;
  end

  // Handshake monitor for AXI-Lite signals
  always @(posedge clk) begin
    if (awvalidM && awreadyS)
      $display("[Cycle %0d][%0t] AW_HANDSHAKE addr=0x%0h", cycle_count, $time, awaddrM);

    if (wvalidM && wreadyS)
      $display("[Cycle %0d][%0t] W_HANDSHAKE   data=0x%0h", cycle_count, $time, wdataM);

    if (bvalidS && breadyM)
      $display("[Cycle %0d][%0t] B_HANDSHAKE", cycle_count, $time);

    if (arvalidM && arreadyS)
      $display("[Cycle %0d][%0t] AR_HANDSHAKE addr=0x%0h", cycle_count, $time, araddrM);

    if (rvalidS && rreadyM)
      $display("[Cycle %0d][%0t] R_HANDSHAKE   data=0x%0h", cycle_count, $time, rdataS);
  end

  // Instantiate master
  axi_lite_master master (
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .mode(mode),
    .addr(addr),
    .wdata_in(wdata_in),
    .rdata_out(rdata_outM),
    .done(done),

    .arready(arreadyS),
    .rvalid(rvalidS),
    .rdata(rdataS),
    .arvalid(arvalidM),
    .araddr(araddrM),
    .rready(rreadyM),

    .awready(awreadyS),
    .wready(wreadyS),
    .bvalid(bvalidS),
    .awvalid(awvalidM),
    .awaddr(awaddrM),
    .wvalid(wvalidM),
    .wdata(wdataM),
    .bready(breadyM)
  );

  // Instantiate slave
  axi_lite_slave slave (
    .clk(clk),
    .rstn(rstn),
    .awvalid(awvalidM),
    .awaddr(awaddrM),
    .wvalid(wvalidM),
    .wdata(wdataM),
    .bready(breadyM),
    .arvalid(arvalidM),
    .araddr(araddrM),
    .rready(rreadyM),

    .awready(awreadyS),
    .wready(wreadyS),
    .bvalid(bvalidS),
    .arready(arreadyS),
    .rvalid(rvalidS),
    .rdata(rdataS)
  );

  // Test procedure
  initial begin
    // Init signals
    rstn = 0;
    start = 0;
    mode = 0;
    addr = 0;
    wdata_in = 0;
    breadyM = 1;  // keep ready high to always accept responses
    rreadyM = 1;  // keep ready high to always accept read data

    // Reset pulse
    #20 rstn = 1;
    #15;

    // WRITE test
    $display("----- WRITE TEST -----");
    addr = 32'h10;
    wdata_in = 32'hDEADBAAD;
    mode = 1;       // write
    start = 1;
    #10 start = 0;
    wait(done);
    wait(!done);
    #10;

    // READ test
    $display("----- READ TEST -----");
    mode = 0;       // read
    start = 1;
    #10 start = 0;
    wait(done);

    // Dump memory after test
    $display("----- MEMORY DUMP -----");
    for (i = 0; i < 16; i++) begin
      $display("mem[%0d] = %08h", i,  slave.mem[i]);
    end

    // Check if read data matches written data
    if (rdata_outM == 32'hDEADBAAD) begin
      $display("TEST PASSED ! Read data matches write data: 0x%08h", rdata_outM);
    end else begin
      $display("TEST FAILED ! Read data 0x%08h does not match expected 0xDEADBAAD", rdata_outM);
    end

    #100;
    $finish;
  end

endmodule
