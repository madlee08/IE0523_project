`ifndef MACROS_SYNC
`define MACROS_SYNC

`include "tablas.v"
`include "functions.v"

`define shift_left(BITS, x) (BITS<<x)
`define UNO_sync             `numero_estados_sync'h1

//  CODIFICACION DE LOS ESTADOS DE SYNC
`define numero_estados_sync 13
`define LOSS_OF_SYNC        `shift_left(`UNO_sync, 0)
`define COMMA_DETECT_1      `shift_left(`UNO_sync, 1)
`define ACQUIRE_SYNC_1      `shift_left(`UNO_sync, 2)
`define COMMA_DETECT_2      `shift_left(`UNO_sync, 3)
`define ACQUIRE_SYNC_2      `shift_left(`UNO_sync, 4)
`define COMMA_DETECT_3      `shift_left(`UNO_sync, 5)
`define SYNC_ACQUIRED_1     `shift_left(`UNO_sync, 6)
`define SYNC_ACQUIRED_2     `shift_left(`UNO_sync, 7)
`define SYNC_ACQUIRED_2A    `shift_left(`UNO_sync, 8)
`define SYNC_ACQUIRED_3     `shift_left(`UNO_sync, 9)
`define SYNC_ACQUIRED_3A    `shift_left(`UNO_sync, 10)
`define SYNC_ACQUIRED_4     `shift_left(`UNO_sync, 11)
`define SYNC_ACQUIRED_4A    `shift_left(`UNO_sync, 12)

// CODIFICACION DE SENALES
`define OK   1'b1
`define FAIL 1'b0

// ESTADOS DONDE rx_even = TRUE
`define COMMA_DETECT(STATE) (\ 
	(STATE == `COMMA_DETECT_1) || \ 
	(STATE == `COMMA_DETECT_2) || \ 
	(STATE == `COMMA_DETECT_3) )

`define cgbad(RX_CG, RX_EVEN) ((!`IS_VALID(RX_CG) || (`IS_COMMA(RX_CG) && RX_EVEN)))

`define cggood(RX_CG, RX_EVEN) ((!`cgbad(RX_CG, RX_EVEN)))

module signal_detect_CHANGE (
    input clk,
    input signal_detect,
    output reg signal_detectCHANGE
);

    reg signal_detect_old;

    always @(posedge clk ) begin
            signal_detect_old <= signal_detect;
    end

    always @(*) begin
        if (signal_detect == signal_detect_old)
            signal_detectCHANGE = `FALSE;

        else
            signal_detectCHANGE = `TRUE;
    end

endmodule
`endif