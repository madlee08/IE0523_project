`include "transmit_cg.v"
`include "transmit_os.v"

module TRANSMIT (
    input mr_main_reset,
    input GTX_CLK,
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,
    input receiving,
    input [2:0] xmit,
    output COL,
    output transmitting,
    output [9:0] tx_code_group
);


// variables internas de TX
wire TX_OSET_indicate;
wire [6:0] tx_o_set;
wire tx_even;

TRANSMIT_OS ordered_set (
    // entradas de TX ordered set
    .mr_main_reset(mr_main_reset),
    .GTX_CLK(GTX_CLK),
    .TXD(TXD[7:0]),
    .TX_EN(TX_EN),
    .TX_ER(TX_ER),
    .tx_even(tx_even),
    .receiving(receiving),
    .TX_OSET_indicate(TX_OSET_indicate),
    .xmit(xmit[2:0]),

    // salidas de TX ordered set
    .tx_o_set(tx_o_set),
    .COL(COL),
    .transmitting(transmitting)
);

TRANSMIT_CG code_group (
    // entradas de TX code group
    .mr_main_reset(mr_main_reset),
    .GTX_CLK(GTX_CLK),
    .tx_o_set(tx_o_set),
    .TXD(TXD[7:0]),

    // salidas de TX code group
    .tx_even(tx_even),
    .TX_OSET_indicate(TX_OSET_indicate),
    .tx_code_group(tx_code_group[9:0])
);

endmodule