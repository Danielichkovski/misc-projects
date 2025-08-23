`timescale 1ns / 1ps
//============================================================
// AXI4-Lite Slave
// Implements AXI4-Lite read and write transactions with 
// an internal 16-word memory array.
//============================================================

module axi_lite_slave (
    input  logic        clk,
    input  logic        rstn,

    // Write address channel
    input  logic        awvalid,
    input  logic [31:0] awaddr,
    output logic        awready,

    // Write data channel
    input  logic        wvalid,
    input  logic [31:0] wdata,
    output logic        wready,

    // Write response channel
    output logic        bvalid,
    input  logic        bready,

    // Read address channel
    input  logic        arvalid,
    input  logic [31:0] araddr,
    output logic        arready,

    // Read data channel
    output logic        rvalid,
    output logic [31:0] rdata,
    input  logic        rready
);

    //============================================================
    // Internal Memory Array
    // 16 words of 32-bit storage
    //============================================================
    logic [31:0] mem [0:15];
    logic [31:0] awaddr_reg, araddr_reg;

    //============================================================
    // Write Address Handshake: awready pulse for 1 cycle on awvalid
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            awready    <= 0;
            awaddr_reg <= 0;
        end else begin
            if (!awready && awvalid) begin
                awready <= 1;
                awaddr_reg <= awaddr;
            end else begin
                awready <= 0;
            end
        end
    end

    //============================================================
    // Write Data Handshake: wready pulse for 1 cycle on wvalid
    // Write to memory on handshake
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            wready <= 0;
        end else begin
            if (!wready && wvalid) begin
                wready <= 1;
                mem[awaddr_reg[5:2]] <= wdata; // Word aligned address
            end else begin
                wready <= 0;
            end
        end
    end

    //============================================================
    // Write Response Channel: bvalid asserted after write accepted
    // cleared when master asserts bready
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bvalid <= 0;
        end else begin
            if (wvalid && wready)
                bvalid <= 1;
            else if (bvalid && bready)
                bvalid <= 0;
        end
    end

    //============================================================
    // Read Address Handshake: arready pulse for 1 cycle on arvalid
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            arready    <= 0;
            araddr_reg <= 0;
        end else begin
            if (!arready && arvalid) begin
                arready <= 1;
                araddr_reg <= araddr;
            end else begin
                arready <= 0;
            end
        end
    end

    //============================================================
    // Read Data Channel: rvalid asserted when data is ready,
    // cleared when master asserts rready
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rvalid <= 0;
            rdata  <= 0;
        end else begin
            if (arvalid && arready) begin
                rdata  <= mem[araddr_reg[5:2]];
                rvalid <= 1;
            end else if (rvalid && rready) begin
                rvalid <= 0;
            end
        end
    end

endmodule
