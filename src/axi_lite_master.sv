`timescale 1ns / 1ps
//============================================================
// AXI4-Lite Master
// Generates AXI4-Lite read and write transactions.
// Controlled via:
//    start  : Begin a transaction
//    mode   : 1 = write, 0 = read
//    addr   : Target address
//    wdata_in : Data to write (when mode=1)
//
// Produces:
//    rdata_out : Data read (when mode=0)
//    done      : Indicates transaction completion
//============================================================

module axi_lite_master (
    input  logic        clk,
    input  logic        rstn,

    // Control interface
    input  logic        start,       // Start transaction
    input  logic        mode,        // 1 = write, 0 = read
    input  logic [31:0] addr,        // Transaction address
    input  logic [31:0] wdata_in,    // Write data (when mode=1)

    //==============================
    // Read address channel
    //==============================
    input  logic        arready,     // Slave ready to accept read address
    output logic        arvalid,     // Read address valid
    output logic [31:0] araddr,      // Read address

    //==============================
    // Read data channel
    //==============================
    input  logic        rvalid,      // Read data valid
    input  logic [31:0] rdata,       // Read data from slave
    output logic        rready,      // Master ready to accept read data

    //==============================
    // Write address channel
    //==============================
    input  logic        awready,     // Slave ready to accept write address
    output logic        awvalid,     // Write address valid
    output logic [31:0] awaddr,      // Write address

    //==============================
    // Write data channel
    //==============================
    input  logic        wready,      // Slave ready to accept write data
    output logic        wvalid,      // Write data valid
    output logic [31:0] wdata,       // Write data

    //==============================
    // Write response channel
    //==============================
    input  logic        bvalid,      // Write response valid
    output logic        bready,      // Master ready to accept write response

    //==============================
    // Outputs to top-level
    //==============================
    output logic [31:0] rdata_out,   // Data read from slave
    output logic        done         // Transaction complete
);

    //============================================================
    // State Machine Definition
    //============================================================
    typedef enum logic [2:0] {
        IDLE,           // Wait for start
        WRITE_ADDR,     // Send write address
        WRITE_DATA,     // Send write data
        WRITE_RESP,     // Wait for write response
        READ_ADDR,      // Send read address
        READ_DATA,      // Receive read data
        DONE            // Transaction complete
    } state_t;

    state_t state, next_state;

    //============================================================
    // Handshake Signals
    //============================================================
    logic aw_handshake, w_handshake, b_handshake;
    logic ar_handshake, r_handshake;

    assign aw_handshake = awvalid && awready;
    assign w_handshake  = wvalid  && wready;
    assign b_handshake  = bvalid  && bready;

    assign ar_handshake = arvalid && arready;
    assign r_handshake  = rvalid  && rready;

    //============================================================
    // State Register
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= IDLE;
        else
            state <= next_state;
    end

    //============================================================
    // Next-State Logic
    //============================================================
    always_comb begin
        next_state = state;
        case (state)
            IDLE:       if (start) next_state = (mode) ? WRITE_ADDR : READ_ADDR;

            WRITE_ADDR: if (aw_handshake) next_state = WRITE_DATA;
            WRITE_DATA: if (w_handshake)  next_state = WRITE_RESP;
            WRITE_RESP: if (b_handshake)  next_state = DONE;

            READ_ADDR:  if (ar_handshake) next_state = READ_DATA;
            READ_DATA:  if (r_handshake)  next_state = DONE;

            DONE:       if (start) next_state = (mode) ? WRITE_ADDR : READ_ADDR;
                        else       next_state = IDLE;
        endcase
    end

    //============================================================
    // Output Logic (driven by state)
    //============================================================
    assign awvalid = (state == WRITE_ADDR);
    assign awaddr  = addr;

    assign wvalid  = (state == WRITE_DATA);
    assign wdata   = wdata_in;

    assign bready  = (state == WRITE_RESP);

    assign arvalid = (state == READ_ADDR);
    assign araddr  = addr;

    assign rready  = (state == READ_DATA);

    assign done    = (state == DONE);

    //============================================================
    // Read Data Register
    //============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            rdata_out <= 32'b0;
        else if (state == READ_DATA && rvalid)
            rdata_out <= rdata;
    end

endmodule
