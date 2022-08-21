`include "transmit.v"
`include "receive.v"
`include "synchronization.v"
`include "carrier_sense.v"

/*  physical coding sublayer con las
    partes mínimas que solicita el
    proyecto + carrier sense
*/
module PCS_CS (
    // entradas y salidas de transmisor
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,
    input GTX_CLK,
    output COL,
    output [9:0] tx_code_group,

    // entrada y salidas del receptores
    input [9:0] rx_code_group,
    output [7:0] RXD,
    output RX_DV,
    output RX_ER,
    output RX_CLK,

    // entradas adicionales
    input mr_main_reset,
    input mr_loopback,
    input signal_detect,
    input [2:0] xmit,

    // entrda y salida de carrier sense
    input repeater_mode,
    output CRS
);

// variables internas del PCS
wire receiving;
wire [9:0] SUDI;
wire rx_even;
wire code_sync_status;
wire transmitting;

TRANSMIT TX (
    // entradas de TX
    .mr_main_reset(mr_main_reset),
    .GTX_CLK(GTX_CLK),
    .TXD(TXD),
    .TX_EN(TX_EN),
    .TX_ER(TX_ER),
    .receiving(receiving),
    .xmit(xmit),

    // salidas de TX
    .tx_code_group(tx_code_group),
    .COL(COL),
    .transmitting(transmitting)
);

RECEIVE RX (
    // entradas de RX
    .mr_main_reset(mr_main_reset),
    .clk(GTX_CLK),
    .SUDI(SUDI),
    .EVEN(rx_even),
    .xmit(xmit),

    // salidas de RX
    .RXD(RXD),
    .RX_DV(RX_DV),
    .RX_ER(RX_ER),
    .RX_CLK(RX_CLK),
    .receiving(receiving)
);

SYNCHRONIZATION SYNC (
    // entradas de SYNC
    .mr_main_reset(mr_main_reset),
    .clock(GTX_CLK),
    .mr_loopback(mr_loopback),
    .signal_detect(signal_detect),
    .rx_code_group(rx_code_group),

    // salidas de SYNC
    .SUDI(SUDI),
    .rx_even(rx_even),
    .code_sync_status(code_sync_status)
);

CARRIER_SENSE CS (
    // entradas de CS
    .mr_main_reset(mr_main_reset),
    .CLOCK(GTX_CLK),
    .receiving(receiving),
    .transmitting(transmitting),
    .repeater_mode(repeater_mode),

    // salida de CS
    .CRS(CRS)
);
endmodule