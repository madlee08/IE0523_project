`include "transmit.v"
`include "synchronization.v"
`include "tester_TX.v"
`include "tester_SYNC.v"

/*  banco de pruebas */
module testbench_TX_SYNC;
    wire GTX_CLK, TX_EN, TX_ER;
    wire mr_main_reset;
    wire [7:0] TXD, RXD;
    wire [9:0] tx_code_group;
    wire [2:0] xmit;
    wire COL, transmitting;

    wire mr_loopback,signal_detect; 
    wire [9:0] SUDI;
    wire code_sync_status,rx_even;
    wire [12:0] state;

    /*  se instancia un DUT */
    TRANSMIT TX (
        .GTX_CLK      (GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN        (TX_EN),
        .TX_ER        (TX_ER),
        .receiving    (receiving),
        .xmit         (xmit[2:0]),
        .TXD          (TXD[7:0]),
        .tx_code_group(tx_code_group[9:0]),
        .COL          (COL),
        .transmitting (transmitting)
    );

    /*  se instancia un probador */
    tester_TX probador (
        .GTX_CLK      (GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN        (TX_EN),
        .TX_ER        (TX_ER),
        .receiving    (receiving),
        .xmit         (xmit[2:0]),
        .TXD          (TXD[7:0]),
        .tx_code_group(tx_code_group[9:0]),
        .COL          (COL)
    );

    SYNCHRONIZATION SYNC (
        .clock              (GTX_CLK),
        .mr_main_reset      (mr_main_reset),
        .mr_loopback        (mr_loopback),
        .signal_detect      (signal_detect),
        .rx_code_group      (tx_code_group[9:0]),
        .SUDI               (SUDI[9:0]),
        .code_sync_status   (code_sync_status),
        .rx_even            (rx_even)
    );

    tester_SYNC Probador (
        .mr_loopback        (mr_loopback),
        .signal_detect      (signal_detect),
        .SUDI               (SUDI[9:0]),
        .code_sync_status   (code_sync_status),
        .rx_even            (rx_even)
    );

    /*  para generar las ondas y
        y visualizar en gtkwave
    */
    initial begin
        $dumpfile("./out/tb_TX_SYNC.vcd");
        $dumpvars;
    end
endmodule