`include "tester_TX.v"
`include "tester_SYNC.v"

/*  probador */
module tester (
    output [7:0] TXD,
    output TX_EN,
    output TX_ER,
    output GTX_CLK,
    output [2:0] xmit,
    output mr_main_reset,
    output mr_loopback,
    output signal_detect
);


/*  loopback */

    tester_TX probador (
        .GTX_CLK      (GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN        (TX_EN),
        .TX_ER        (TX_ER),
        .xmit         (xmit[2:0]),
        .TXD          (TXD[7:0])
    );

    tester_SYNC Probador (
        .mr_loopback        (mr_loopback),
        .signal_detect      (signal_detect)
    );


endmodule