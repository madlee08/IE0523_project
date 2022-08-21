`ifndef MACROS_TX
`define MACROS_TX

`include "tablas.v"

`define shift_left(BITS, x) (BITS<<x)
`define UNO_os               `numero_estados_os'h1
`define UNO_cg               `numero_estados_cg'h1
`define UNO_tx_os            `numero_conjuntos_os'h1

//  CODIFICACION DE LOS ESTADOS DE TX ordered set
`define numero_estados_os    8
`define TX_TEST_XMIT        `shift_left(`UNO_os, 0)
`define IDLE                `shift_left(`UNO_os, 1)
`define XMIT_DATA           `shift_left(`UNO_os, 2)
`define START_OF_PACKET     `shift_left(`UNO_os, 3)
`define TX_PACKET           `shift_left(`UNO_os, 4)
`define END_OF_PACKET_NOEXT `shift_left(`UNO_os, 5)
`define EPD2_NOEXT          `shift_left(`UNO_os, 6)
`define EPD3                `shift_left(`UNO_os, 7)

//  CODIFICACION DE LOS ESTADOS DE TX code groups
`define numero_estados_cg    2
`define GENERATE_CODE_GROUPS `shift_left(`UNO_cg, 0)
`define IDLE_I2B             `shift_left(`UNO_cg, 1)

`define numero_conjuntos_os 9

`define tx_os_C             `shift_left(`UNO_tx_os, 0)
`define tx_os_T             `shift_left(`UNO_tx_os, 1)
`define tx_os_R             `shift_left(`UNO_tx_os, 2)
`define tx_os_I             `shift_left(`UNO_tx_os, 3)
`define tx_os_D             `shift_left(`UNO_tx_os, 4)
`define tx_os_S             `shift_left(`UNO_tx_os, 5)
`define tx_os_V             `shift_left(`UNO_tx_os, 6)
`define tx_os_LI            `shift_left(`UNO_tx_os, 7)


module ENCODE (
    input [7:0] valid_cg_8b,
    output reg [9:0] valid_cg_10b
);

always @(valid_cg_8b) begin
    case(valid_cg_8b)
        /*  valid special code groups */
        `K28_0_08b: valid_cg_10b = `K28_0_10b; // K28.0
        `K28_1_08b: valid_cg_10b = `K28_1_10b; // K28.1
        `K28_2_08b: valid_cg_10b = `K28_2_10b; // K28.2
        `K28_3_08b: valid_cg_10b = `K28_3_10b; // K28.3
        `K28_4_08b: valid_cg_10b = `K28_4_10b; // K28.4
        `K28_5_08b: valid_cg_10b = `K28_5_10b; // K28.5
        `K28_6_08b: valid_cg_10b = `K28_6_10b; // K28.6
        `K28_7_08b: valid_cg_10b = `K28_7_10b; // K28.7
        `K23_7_08b: valid_cg_10b = `K23_7_10b; // K23.7 /R/
        `K27_7_08b: valid_cg_10b = `K27_7_10b; // K27.7 /S/
        `K29_7_08b: valid_cg_10b = `K29_7_10b; // K29.7 /T/
        `K30_7_08b: valid_cg_10b = `K30_7_10b; // K30.7 /V/

        /*  valid data code groups */
        `D00_0_08b: valid_cg_10b = `D00_0_10b; // D0.0
        `D01_0_08b: valid_cg_10b = `D01_0_10b; // D1.0
        `D02_0_08b: valid_cg_10b = `D02_0_10b; // D2.0
        `D03_0_08b: valid_cg_10b = `D03_0_10b; // D3.0
        `D02_2_08b: valid_cg_10b = `D02_2_10b; // D2.2
        `D16_2_08b: valid_cg_10b = `D16_2_10b; // D16.2
        `D26_4_08b: valid_cg_10b = `D26_4_10b; // D26.4
        `D06_5_08b: valid_cg_10b = `D06_5_10b; // D6.5
        `D21_5_08b: valid_cg_10b = `D21_5_10b; // D21.5
        `D05_6_08b: valid_cg_10b = `D05_6_10b; // D5.6
    endcase
end
endmodule


module VOID (
    input [`numero_conjuntos_os-1:0] tx_set_in,
    input TX_EN,
    input TX_ER,
    input [7:0] TXD,
    output reg [`numero_conjuntos_os-1:0] tx_set_out
);

always @(*) begin
    if (!TX_EN && TX_ER && TXD[7:0] != 8'h0F)
        tx_set_out = `tx_os_V;
    
    else if (TX_EN && TX_ER) begin
        tx_set_out = `tx_os_V;
    end else
        tx_set_out = tx_set_in;
end

endmodule

module xmit_CHANGE (
    input clk,
    input [2:0] xmit,
    output reg xmitCHANGE
);

    reg [2:0] xmit_old;

    always @(posedge clk ) begin
            xmit_old <= xmit;
    end

    always @(*) begin
        if (xmit == xmit_old)
            xmitCHANGE = `FALSE;

        else
            xmitCHANGE = `TRUE;
    end

endmodule
`endif