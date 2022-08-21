`include "PCS_CS.v"
`include "tester.v"

/*  banco de pruebas */
module testbench_PCS_CS;
    wire GTX_CLK, RX_CLK, TX_EN, TX_ER, RX_DV, RX_ER;
    wire mr_main_reset, mr_loopback, signal_detect, COL;
    wire [7:0] TXD, RXD;
    wire [9:0] loopback;
    wire [2:0] xmit;
    wire CRS, repeater_mode;
    
    /*  se instancia un DUT */
    PCS_CS DUT (
        .TXD(TXD),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .GTX_CLK(GTX_CLK),
        .tx_code_group(loopback),
        .RXD(RXD),
        .RX_DV(RX_DV),
        .RX_ER(RX_ER),
        .RX_CLK(RX_CLK),
        .rx_code_group(loopback),
        .xmit(xmit),
        .mr_main_reset(mr_main_reset),
        .mr_loopback(mr_loopback),
        .signal_detect(signal_detect),
        .COL(COL),
        .repeater_mode(repeater_mode),
        .CRS(CRS)
    );

    /*  se instancia un probador */

    tester_PCS_CS probador (
        .TXD(TXD),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .GTX_CLK(GTX_CLK),
        .xmit(xmit),
        .mr_main_reset(mr_main_reset),
        .mr_loopback(mr_loopback),
        .signal_detect(signal_detect),
        .repeater_mode(repeater_mode)
    );

    /*  para generar las ondas y
        y visualizar en gtkwave
    */
    initial begin
        $dumpfile("./out/testbench.vcd");
        $dumpvars;
    end
endmodule