`include "functions.v"
`include "macros_TX.v"
`include "macros_AN.v"

module TRANSMIT_OS (
    input mr_main_reset,
    input GTX_CLK,
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,
    input receiving,
    input TX_OSET_indicate,
    input tx_even,
    input [2:0] xmit,
    output reg [6:0] tx_o_set,
    output reg COL,
    output reg transmitting,
    output reg [9:0] tx_code_group
);

// función xmitCHANGE
xmit_CHANGE xmit_C (
    .clk(GTX_CLK),
    .xmit(xmit),
    .xmitCHANGE(xmitCHANGE)
);

// función VOID(X)
VOID void (
    .tx_set_in(`tx_os_D),
    .TX_EN(TX_EN),
    .TX_ER(TX_ER),
    .TXD(TXD[7:0]),
    .tx_set_out(tx_set_void)
);

// variables internas de TX ordered set
wire xmitCHANGE;
wire [`numero_conjuntos_os-1:0] tx_set_void;
reg [`numero_estados_os-1:0] estado_actual;
reg [`numero_estados_os-1:0] estado_siguiente;


always @(posedge GTX_CLK) begin
    if (!mr_main_reset || (xmitCHANGE && TX_OSET_indicate && !tx_even)) begin
        estado_actual <= `TX_TEST_XMIT;
        transmitting = `FALSE;
        COL = `FALSE;
    end else
        estado_actual <= estado_siguiente;
end

always @(*) begin

    // para garantizar el comportamiento del DFF
    estado_siguiente = estado_actual;

    // implementación de la máquina de estados
    // de acuerdo al diagrama ASM
    case(estado_actual)
        // TX_TEST_XMIT
        `TX_TEST_XMIT: begin
            transmitting = `FALSE;
            COL = `FALSE;

            if (xmit == `xmit_IDLE || (xmit == `xmit_DATA && (TX_EN || TX_ER)))
                estado_siguiente = `IDLE;
            
            if (xmit == `xmit_DATA && !TX_EN && !TX_ER)
                estado_siguiente = `xmit_DATA;
        end

        // IDLE
        `IDLE: begin
            tx_o_set = `tx_os_I; // /I/

            if (xmit == `xmit_DATA && TX_OSET_indicate && !TX_EN && !TX_ER)
                estado_siguiente = `XMIT_DATA;
        end

        // XMIT_DATA
        `XMIT_DATA: begin
            tx_o_set = `tx_os_I; // /I/

            if (!TX_EN && TX_OSET_indicate)
                estado_siguiente = `XMIT_DATA;
            
            if (TX_EN && !TX_ER && TX_OSET_indicate)
                estado_siguiente = `START_OF_PACKET;
        end

        // START_OF_PACKET
        `START_OF_PACKET: begin
            tx_o_set = `tx_os_S; // /S/
            transmitting = `TRUE;
            COL = receiving;

            if (TX_OSET_indicate)
                estado_siguiente = `TX_PACKET;
        end

        // TX_PACKET
        `TX_PACKET: begin
            if (TX_EN) begin
                tx_o_set = tx_set_void; // VOID(/D/)
                COL = receiving;
            end
            if (!TX_EN && !TX_ER)
                estado_siguiente = `END_OF_PACKET_NOEXT;
        end

        // END_OF_PACKET_NOEXT
        `END_OF_PACKET_NOEXT: begin
            tx_o_set = `tx_os_T; // /T/
            COL = `FALSE;
            if (!tx_even)
                transmitting = `FALSE;

            if (TX_OSET_indicate)
                estado_siguiente = `EPD2_NOEXT;
        end

        // EPD2_NOEXT
        `EPD2_NOEXT: begin
            tx_o_set = `tx_os_R; // /R/
            transmitting = `FALSE;

            if (TX_OSET_indicate) begin
                if (!tx_even)
                    estado_siguiente = `XMIT_DATA;

                else
                    estado_siguiente = `EPD3;
            end
        end

        // EPD3
        `EPD3: begin
            tx_o_set = `tx_os_R; // /R/

            if(TX_OSET_indicate)
                estado_siguiente = `XMIT_DATA;
        end

        default: estado_siguiente = `TX_TEST_XMIT;
    endcase

end

endmodule