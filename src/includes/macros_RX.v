`ifndef MACROS_RX
`define MACROS_RX

`include "tablas.v"

`define shift_left(BITS, x) (BITS<<x)
`define UNO_rx                 `numero_estados_rx'h1

//  CODIFICACION DE LOS ESTADOS DE RX
`define numero_estados_rx    8
`define WAIT_FOR_K          `shift_left(`UNO_rx, 0)
`define RX_K                `shift_left(`UNO_rx, 1)
`define IDLE_D              `shift_left(`UNO_rx, 2)
`define CARRIER_DETECT      `shift_left(`UNO_rx, 3)
`define FALSE_CARRIER       `shift_left(`UNO_rx, 4)
`define START_OF_PACKET     `shift_left(`UNO_rx, 5)
`define RECEIVE             `shift_left(`UNO_rx, 6)
`define EPD2_CHECK_END      `shift_left(`UNO_rx, 7)

// Si es un caracter de dato que conforma /I/
`define idle_d(RX_CG) ((RX_CG != `D21_5_10b && RX_CG != `D02_2_10b))

// CARRIER_DETECT
`define suma_bit(in) ( \ 
    in[0] + \ 
    in[1] + \ 
    in[2] + \ 
    in[3] + \ 
    in[4] + \ 
    in[5] + \ 
    in[6] + \ 
    in[7] + \ 
    in[8] + \ 
    in[9] )

`define carrier_detect(RX_CG) (`suma_bit(RX_CG) >= 2)

// DECODE
module DECODE (
    input [9:0] valid_cg_10b,
    output reg [7:0] valid_cg_8b
);

always @(valid_cg_10b) begin
    case(valid_cg_10b)
        /*  valid special code groups */
        `K28_0_10b: valid_cg_8b = `K28_0_08b; // K28.0
        `K28_1_10b: valid_cg_8b = `K28_1_08b; // K28.1
        `K28_2_10b: valid_cg_8b = `K28_2_08b; // K28.2
        `K28_3_10b: valid_cg_8b = `K28_3_08b; // K28.3
        `K28_4_10b: valid_cg_8b = `K28_4_08b; // K28.4
        `K28_5_10b: valid_cg_8b = `K28_5_08b; // K28.5
        `K28_6_10b: valid_cg_8b = `K28_6_08b; // K28.6
        `K28_7_10b: valid_cg_8b = `K28_7_08b; // K28.7
        `K23_7_10b: valid_cg_8b = `K23_7_08b; // K23.7 /R/
        `K27_7_10b: valid_cg_8b = `K27_7_08b; // K27.7 /S/
        `K29_7_10b: valid_cg_8b = `K29_7_08b; // K29.7 /T/
        `K30_7_10b: valid_cg_8b = `K30_7_08b; // K30.7 /V/

        /*  valid data code groups */
        `D00_0_10b: valid_cg_8b = `D00_0_08b; // D0.0
        `D01_0_10b: valid_cg_8b = `D01_0_08b; // D1.0
        `D02_0_10b: valid_cg_8b = `D02_0_08b; // D2.0
        `D03_0_10b: valid_cg_8b = `D03_0_08b; // D3.0
        `D02_2_10b: valid_cg_8b = `D02_2_08b; // D2.2
        `D16_2_10b: valid_cg_8b = `D16_2_08b; // D16.2
        `D26_4_10b: valid_cg_8b = `D26_4_08b; // D26.4
        `D06_5_10b: valid_cg_8b = `D06_5_08b; // D6.5
        `D21_5_10b: valid_cg_8b = `D21_5_08b; // D21.5
        `D05_6_10b: valid_cg_8b = `D05_6_08b; // D5.6
    endcase
end
endmodule

`endif