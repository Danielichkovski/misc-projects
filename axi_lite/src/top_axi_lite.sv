module top_axi_lite (
    input  logic clk,
    input  logic rstn,
    input  logic start,
    input  logic mode,           // 1=write, 0=read
    input  logic [31:0] addr,
    input  logic [31:0] wdata_in,
    output logic [31:0] rdata_out,
    output logic done
);

    // AXI4-Lite signals to connect Master & Slave
    logic        awvalid, awready;
    logic [31:0] awaddr;
    logic        wvalid, wready;
    logic [31:0] wdata;
    logic        bvalid, bready;
    logic        arvalid, arready;
    logic [31:0] araddr;
    logic        rvalid, rready;
    logic [31:0] rdata;
    logic [1:0]  bresp;  // Your slave didn't use bresp signals, so can ignore or tie off

    // Instantiate master
    axi_lite_master master_inst (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .mode(mode),
        .addr(addr),
        .wdata_in(wdata_in),

        .arready(arready),
        .rvalid(rvalid),
        .rdata(rdata),
        .arvalid(arvalid),
        .araddr(araddr),
        .rready(rready),

        .awready(awready),
        .wready(wready),
        .bvalid(bvalid),

        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .bready(bready),

        .rdata_out(rdata_out),
        .done(done)
    );

    // Instantiate slave
    axi_lite_slave slave_inst (
        .clk(clk),
        .rstn(rstn),

        .awvalid(awvalid),
        .awaddr(awaddr),
        .awready(awready),

        .wvalid(wvalid),
        .wdata(wdata),
        .wready(wready),

        .bvalid(bvalid),
        .bready(bready),

        .arvalid(arvalid),
        .araddr(araddr),
        .arready(arready),

        .rvalid(rvalid),
        .rdata(rdata),
        .rready(rready)
    );

endmodule
