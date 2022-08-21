`include "tester_CS.v"
`include "tester_PCS.v"

module tester_PCS_CS (
    output [7:0] TXD,
    output TX_EN,
    output TX_ER,
    output GTX_CLK,
    output [2:0] xmit,
    output mr_main_reset,
    output mr_loopback,
    output signal_detect,
    output receiving,
    output repeater_mode,
    output transmitting
);
    // tester del PCS
    tester probador (
        .TXD(TXD),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .GTX_CLK(GTX_CLK),
        .xmit(xmit),
        .mr_main_reset(mr_main_reset),
        .mr_loopback(mr_loopback),
        .signal_detect(signal_detect)
    );

    // tester del CS
    tester_CS probador_CS (
        .repeater_mode(repeater_mode)
    );

endmodule