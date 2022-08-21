`include "transmit.v"
`include "tester_TX.v"

/*  banco de pruebas */
module testbench_TX;
    wire GTX_CLK, TX_EN, TX_ER;
    wire [7:0] TXD, RXD;
    wire [9:0] tx_code_group, rx_code_group;
    wire [2:0] xmit;
    wire COL, transmitting;

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
        .COL(COL)
    );

    /*  para generar las ondas y
        y visualizar en gtkwave
    */
    initial begin
        $dumpfile("./out/tb_TX.vcd");
        $dumpvars;
    end
endmodule