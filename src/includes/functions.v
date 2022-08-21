`ifndef FUNCTIONS
`define FUNCTIONS

`define TRUE  1'b1
`define FALSE 1'b0

`include "tablas.v"

// PARA DETECTAR EL CODE GROUP
// SI ES COMMA
`define IS_K28_5(RX_CG) ((RX_CG == `K28_5_10b))

`define IS_COMMA(RX_CG) ( \ 
	(RX_CG == `K28_1_10b) || \ 
	(RX_CG == `K28_5_10b) || \ 
	(RX_CG == `K28_7_10b) )

// SI ES DATO VALIDO
`define IS_DATA(RX_CG) ( \ 
	(RX_CG == `D00_0_10b) || \ 
	(RX_CG == `D01_0_10b) || \ 
	(RX_CG == `D02_0_10b) || \ 
	(RX_CG == `D03_0_10b) || \ 
	(RX_CG == `D02_2_10b) || \ 
	(RX_CG == `D16_2_10b) || \ 
	(RX_CG == `D26_4_10b) || \ 
	(RX_CG == `D06_5_10b) || \ 
	(RX_CG == `D21_5_10b) || \ 
	(RX_CG == `D05_6_10b) )

// SI ES CONTROL VALIDO
`define IS_KONTROL(RX_CG) (\ 
	(RX_CG == `K28_0_10b) || \ 
	(RX_CG == `K28_1_10b) || \ 
	(RX_CG == `K28_2_10b) || \ 
	(RX_CG == `K28_3_10b) || \ 
	(RX_CG == `K28_4_10b) || \ 
	(RX_CG == `K28_5_10b) || \ 
	(RX_CG == `K28_6_10b) || \ 
	(RX_CG == `K28_7_10b) || \ 
	(RX_CG == `K23_7_10b) || \ 
	(RX_CG == `K27_7_10b) || \ 
	(RX_CG == `K29_7_10b) || \ 
	(RX_CG == `K30_7_10b) )

// SI ES CONTROL O DATO VALIDO
`define IS_VALID(RX_CG) ((`IS_DATA(RX_CG)) || (`IS_KONTROL(RX_CG)))

`endif